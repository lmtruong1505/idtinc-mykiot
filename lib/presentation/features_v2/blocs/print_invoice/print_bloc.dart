import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/features/company/data/models/company_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/order/order_detail_v2_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:image/image.dart' as img;

class PrintBloc extends Cubit<CubitState> {
  PrintBloc() : super(CubitState());

  StreamSubscription<List<Printer>>? _devicesStreamSubscription;
  final _printerPlugin = FlutterThermalPrinter.instance;

  List<Printer> printers = [];
  Printer? printerSelect;
  Map<Permission, PermissionStatus>? statuses;
  PrintType paperSize = PrintType.mm58;

  List<PrintType> listPageSize = [
    PrintType.mm58,
    PrintType.mm72,
    PrintType.mm80,
  ];

  Future<void> requestPermissions() async {
    statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  void checkPermission() {
    if (Platform.isAndroid) {
      if (statuses?[Permission.bluetooth]?.isGranted == true &&
          statuses?[Permission.bluetoothConnect]?.isGranted == true &&
          statuses?[Permission.location]?.isGranted == true) {
        startScan();
      } else {
        openAppSettings();
      }
    } else if (Platform.isIOS) {
      // iOS: chỉ cần đảm bảo đã khai báo đầy đủ trong Info.plist
      startScan();
    }
  }

  // Get Printer List
  void startScan() async {
    emit(state.copyWith(status: BlocStatus.loading));
    _devicesStreamSubscription?.cancel();
    await _printerPlugin.getPrinters(connectionTypes: [ConnectionType.BLE]);
    _devicesStreamSubscription =
        _printerPlugin.devicesStream.listen((List<Printer> event) {
      printers = event;
      printers.removeWhere(
        (element) => element.name == null || element.name == '',
        //  ||
        // !element.name!.toLowerCase().contains('print')
      );
      emit(state.copyWith(status: BlocStatus.success));
    });
  }

  void stopScan() {
    _devicesStreamSubscription?.cancel();
    _printerPlugin.stopScan();
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<void> checkBluetoothStatus() async {
    try {
      final bool isEnabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!isEnabled) {
        emit(
          state.copyWith(status: BlocStatus.error, msg: 'Bluetooth chưa bật'),
        );
      } else {
        requestPermissions();
      }
    } catch (e) {
      print('==========$e');
      emit(
        state.copyWith(
          status: BlocStatus.error,
          msg: 'Lỗi kiểm tra bluetooth: $e',
        ),
      );
    }
  }

  void onPrint(OrderDetailV2Model? order) async {
    try {
      emit(
        state.copyWith(status: BlocStatus.submit, msg: 'Đang in hoá đơn...'),
      );

      final List<int> bytes = [];

      final data = await generateInvoice(order);
      bytes.addAll(data);
      await _printerPlugin.printData(
        printerSelect!,
        bytes,
        longData: true,
      );
      emit(
        state.copyWith(
          status: BlocStatus.submitSuccess,
          msg: 'In hoá đơn thành công',
        ),
      );
    } catch (e) {
      print('==========$e');
      emit(state.copyWith(status: BlocStatus.submitFailure, msg: e.toString()));
    }
  }

  void onPrintData(List<int> data) async {
    try {
      emit(
        state.copyWith(status: BlocStatus.submit, msg: 'Đang in...'),
      );
      final List<int> bytes = [];
      bytes.addAll(data);
      await _printerPlugin.printData(
        printerSelect!,
        bytes,
        longData: true,
      );
      emit(
        state.copyWith(
          status: BlocStatus.submitSuccess,
          msg: 'In thành công',
        ),
      );
    } catch (e) {
      log('==========$e');
      emit(state.copyWith(status: BlocStatus.submitFailure, msg: e.toString()));
    }
  }

  void onPrintWidget(BuildContext context, Widget widget) async {
    try {
      emit(
        state.copyWith(status: BlocStatus.submit, msg: 'Đang in hoá đơn...'),
      );

      // await _printerPlugin.printWidget(
      //   context,
      //   printer: printerSelect!,
      //   widget: widget,
      //   paperSize: paperSize.size,
      //   printOnBle: true,
      // );
      emit(
        state.copyWith(
          status: BlocStatus.submitSuccess,
          msg: 'In hoá đơn thành công',
        ),
      );
    } catch (e) {
      print('==========$e');
      emit(state.copyWith(status: BlocStatus.submitFailure, msg: e.toString()));
    }
  }

  // ESC/POS commands
  static const List<int> escReset = [27, 64]; // ESC @ - Reset printer
  static const List<int> escCut = [29, 86, 65, 0]; // GS V 65 0 - Full cut
  static const List<int> escAlignCenter = [27, 97, 1]; // ESC a 1 - Center align
  static const List<int> escAlignLeft = [27, 97, 0]; // ESC a 0 - Left align
  static const List<int> escAlignRight = [27, 97, 2]; // ESC a 2 - Right align
  static const List<int> escBoldOn = [27, 69, 1]; // ESC E 1 - Bold on
  static const List<int> escBoldOff = [27, 69, 0]; // ESC E 0 - Bold off
  static const List<int> escSizeNormal = [29, 33, 0]; // GS ! 0 - Normal size
  static const List<int> escSize2 = [29, 33, 1];

  Future<List<int>> generateInvoice(OrderDetailV2Model? order) async {
    final CompanyModel? company = order?.company;
    final customer = order?.customer;
    final List<OrderItemV2>? items = order?.items;
    final List<OrderServiceItemV2>? services = order?.services;

    final num totalPriceProd =
        (items?.fold<num>(0, (t, e) => t + e.priceItem * e.quantity) ?? 0) +
            (services?.fold<num>(
                    0, (t, e) => t + e.totalPrice * (e.quantity ?? 1)) ??
                0);

    final num totalDiscount = (items?.fold<num>(
              0,
              (t, e) => t + e.discountPrice.validator * e.quantity,
            ) ??
            0) +
        (services?.fold<num>(0, (t, e) => t + e.totalDiscount) ?? 0);

    final profile = await CapabilityProfile.load();
    final generator = Generator(
      paperSize.size,
      profile,
      codec: utf8,
    );
    //maxLine của 1 dòng máy in là 31,ktra độ dài string để căn lề
    List<int> bytes = [];
    bytes += generator.emptyLines(2);
    bytes += generator.text(
      '${company?.name}',
      styles: const PosStyles(
        bold: true,
        underline: false,
        align: PosAlign.center,
        fontType: PosFontType.fontA,
      ),
    );
    // Địa chỉ cửa hàng
    bytes += generator.text(
      (company?.address?.fullAddress ?? ''),
      styles: const PosStyles(
        align: PosAlign.center,
        fontType: PosFontType.fontB,
      ),
      maxCharsPerLine: 20,
    );
    bytes += generator.text(
      'MST: ${company?.taxCode ?? '---'}    Hotline: ${company?.phone ?? '---'}',
      styles: const PosStyles(
        align: PosAlign.center,
        fontType: PosFontType.fontB,
      ),
    );
    bytes += generator.emptyLines(1);
    // Tiêu đề hóa đơn
    bytes += generator.text(
      'HOÁ ĐƠN THANH TOÁN',
      styles: const PosStyles(
        bold: true,
        underline: false,
        align: PosAlign.center,
        fontType: PosFontType.fontA,
      ),
    );
    bytes += generator.emptyLines(1);
    // Thông tin đơn hàng - căn trái

    // bytes.addAll(escAlignLeft);
    bytes.addAll(
      generator.row([
        _posColum(
          title: 'Mã ĐH: ',
          width: 3,
          style: const PosStyles(
            fontType: PosFontType.fontB,
          ),
        ),
        _posColum(
          title: '${order?.code} ',
          width: 4,
          style: const PosStyles(
            bold: true,
            fontType: PosFontType.fontB,
          ),
        ),
        _posColum(
          title: '${order?.createdAt.fomatCustom(fomat: 'hh:mm-dd/M/y')}',
          width: 5,
          style: const PosStyles(
            bold: true,
            fontType: PosFontType.fontB,
          ),
        ),
      ]),
    );
    bytes.addAll(
      generator.row([
        _posColum(
          title: 'Tên KH: ',
          width: 3,
          style: const PosStyles(
            fontType: PosFontType.fontB,
          ),
        ),
        _posColum(
          title: '${customer?.prefixName} ',
          width: 4,
          style: const PosStyles(
            bold: true,
            fontType: PosFontType.fontB,
          ),
        ),
        _posColum(
          title: 'Sđt: ${customer?.phone ?? '-'}',
          width: 5,
          style: const PosStyles(
            bold: true,
            fontType: PosFontType.fontB,
          ),
        ),
      ]),
    );
    bytes.addAll(
      generator.row([
        _posColum(
          title: 'Thu ngân: ',
          width: 3,
          style: const PosStyles(
            fontType: PosFontType.fontB,
          ),
        ),
        _posColum(
          title: '--- ',
          width: 4,
          style: const PosStyles(
            bold: true,
            fontType: PosFontType.fontB,
          ),
        ),
        _posColum(
          title: 'Sđt: -',
          width: 5,
          style: const PosStyles(
            bold: true,
            fontType: PosFontType.fontB,
          ),
        ),
      ]),
    );
    bytes += generator.emptyLines(1);
    bytes += generator.hr();

    // Tiêu đề bảng - căn trái, in đậm
    bytes.addAll(
      generator.row([
        _posColum(
          title: 'SL ',
          width: 1,
          style: const PosStyles(
            fontType: PosFontType.fontA,
            align: PosAlign.center,
          ),
        ),
        _posColum(
          title: 'ĐVT ',
          width: 2,
          style: const PosStyles(
            fontType: PosFontType.fontA,
            align: PosAlign.center,
          ),
        ),
        _posColum(
          title: 'ĐG ',
          width: 3,
          style: const PosStyles(
            fontType: PosFontType.fontA,
            align: PosAlign.center,
          ),
        ),
        _posColum(
          title: 'CK ',
          width: 2,
          style: const PosStyles(
            fontType: PosFontType.fontA,
            align: PosAlign.center,
          ),
        ),
        _posColum(
          title: 'Tổng',
          width: 4,
          style: const PosStyles(
            fontType: PosFontType.fontA,
            align: PosAlign.center,
          ),
        ),
      ]),
    );
    bytes += generator.hr();
    // Danh sách dịch vụ
    if (services?.isNotEmpty == true) {
      bytes += generator.text(
        'DANH SÁCH DỊCH VỤ:',
        styles: const PosStyles(
          fontType: PosFontType.fontA,
        ),
      );

      for (int i = 0; i < services!.length; i++) {
        final service = services[i];
        final pricePay = service.totalPrice - service.totalDiscount;
        final discount = service.totalDiscount;
        bytes += generator.text(
          '${i + 1}. ${service.service?.title}:',
          styles: const PosStyles(
            bold: true,
          ),
        );
        bytes.addAll(
          generator.row([
            _posColum(
              title: '${service.quantity.toString()} ',
              width: 1,
              style: const PosStyles(
                fontType: PosFontType.fontA,
                align: PosAlign.center,
              ),
            ),
            _posColum(
              title: '${service.service?.price?.priceNameSub} ',
              width: 2,
              style: const PosStyles(
                fontType: PosFontType.fontA,
                align: PosAlign.center,
              ),
            ),
            _posColum(
              title: '${service.price.formatPrice()} ',
              width: 3,
              style: const PosStyles(
                fontType: PosFontType.fontA,
                align: PosAlign.center,
              ),
            ),
            _posColum(
              title: (discount > 0 ? '-${discount.formatPrice()} ' : '0 '),
              width: 2,
              style: const PosStyles(
                fontType: PosFontType.fontA,
                align: PosAlign.center,
              ),
            ),
            _posColum(
              title: pricePay.formatPrice(),
              width: 4,
              style: const PosStyles(
                fontType: PosFontType.fontA,
                align: PosAlign.center,
              ),
            ),
          ]),
        );
      }
      bytes += generator.hr();
    }
    // Danh sách sản phẩm
    if (items?.isNotEmpty == true) {
      bytes += generator.text(
        'DANH SÁCH SẢN PHẨM:',
        styles: const PosStyles(
          fontType: PosFontType.fontA,
        ),
      );
      // bytes.addAll(escSizeNormal);

      for (int i = 0; i < items!.length; i++) {
        final item = items[i];
        final pricePay = item.quantity * item.priceItem;
        final discount = item.discountPrice;

        // bytes.addAll(_textToBytes('${i + 1}. ${item.productData?.name}\n'));
        bytes += generator.text(
          '${i + 1}. ${item.productData?.name}:',
          styles: const PosStyles(
            bold: true,
          ),
        );
        bytes.addAll(
          generator.row([
            _posColum(
              title: '${item.quantity} ',
              width: 1,
              style: const PosStyles(
                fontType: PosFontType.fontA,
                align: PosAlign.center,
              ),
            ),
            _posColum(
              title: '${item.unitData?.name} ',
              width: 2,
              style: const PosStyles(
                fontType: PosFontType.fontA,
                align: PosAlign.center,
              ),
            ),
            _posColum(
              title: '${item.priceItem.formatPrice()} ',
              width: 3,
              style: const PosStyles(
                fontType: PosFontType.fontA,
                align: PosAlign.center,
              ),
            ),
            _posColum(
              title: (discount > 0 ? '-${discount.formatPrice()} ' : '0 '),
              width: 2,
              style: const PosStyles(
                fontType: PosFontType.fontA,
                align: PosAlign.center,
              ),
            ),
            _posColum(
              title: pricePay.formatPrice(),
              width: 4,
              style: const PosStyles(
                fontType: PosFontType.fontA,
                align: PosAlign.center,
              ),
            ),
          ]),
        );
      }
      bytes += generator.hr();
    }
    // Tổng thanh toán - căn phải
    // Tổng tiền hàng
    bytes.addAll(
      generator.row([
        _posColum(
          title: 'Tổng tiền hàng: ',
          width: 7,
          style: const PosStyles(
            fontType: PosFontType.fontA,
          ),
        ),
        _posColum(
          title: '${totalPriceProd.formatPrice()}đ',
          width: 5,
          style: const PosStyles(
            fontType: PosFontType.fontA,
            bold: true,
            align: PosAlign.right,
          ),
        ),
      ]),
    );
    // Chiết khấu
    bytes.addAll(
      generator.row([
        _posColum(
          title: 'Chiết khấu: ',
          width: 7,
          style: const PosStyles(
            bold: false,
            fontType: PosFontType.fontA,
          ),
        ),
        _posColum(
          title: '${totalDiscount.formatPrice()}đ',
          width: 5,
          style: const PosStyles(
            fontType: PosFontType.fontA,
            bold: false,
            align: PosAlign.right,
          ),
        ),
      ]),
    );
    // VAT (nếu có)
    if (order?.redInvoice == true) {
      // VAT cho sản phẩm

      if (items?.isNotEmpty == true) {
        for (int i = 0; i < (items!.length); i++) {
          final item = items[i];
          if (item.vatProd > 0) {
            final vatAmount = item.vatProd;
            bytes.addAll(
              generator.row([
                _posColum(
                  title:
                      'VAT ${item.productData?.vat}% của (${item.priceItem.formatPrice()}): ',
                  width: 7,
                  style: const PosStyles(
                    fontType: PosFontType.fontA,
                    bold: false,
                  ),
                ),
                _posColum(
                  title: '${vatAmount.formatPrice()}đ',
                  width: 5,
                  style: const PosStyles(
                    fontType: PosFontType.fontA,
                    bold: false,
                    align: PosAlign.right,
                  ),
                ),
              ]),
            );
          }
        }
      }
      // VAT cho dịch vụ

      if (services?.isNotEmpty == true) {
        for (int i = 0; i < services!.length; i++) {
          final service = services[i];
          if (service.vat > 0) {
            bytes.addAll(
              generator.row([
                _posColum(
                  title:
                      'VAT ${service.service?.vat}% của (${service.totalPrice.formatPrice()}): ',
                  width: 7,
                  style: const PosStyles(
                    fontType: PosFontType.fontA,
                    bold: false,
                  ),
                ),
                _posColum(
                  title: '${service.vat.formatPrice()}đ',
                  width: 5,
                  style: const PosStyles(
                    fontType: PosFontType.fontA,
                    bold: false,
                    align: PosAlign.right,
                  ),
                ),
              ]),
            );
          }
        }
      }
    }

    // Tổng thanh toán - in đậm, cỡ chữ to
    bytes.addAll(
      generator.row([
        _posColum(
          title: 'Tổng thanh toán: ',
          width: 7,
          style: const PosStyles(
            fontType: PosFontType.fontA,
            bold: false,
          ),
        ),
        _posColum(
          title: '${order?.totalPrice.formatPrice()}đ',
          width: 5,
          style: const PosStyles(
            fontType: PosFontType.fontA,
            bold: true,
            align: PosAlign.right,
          ),
        ),
      ]),
    );
    bytes += generator.emptyLines(1);
    // Lưu ý - căn giữa
    bytes += generator.qrcode(
      order?.code ?? '',
      size: QRSize.size8,
    );
    // handler QR code
    // if (order?.qr != null) {
    //   final response = await Dio().get(
    //     order!.qr!,
    //     options: Options(
    //       responseType:
    //           ResponseType.bytes, // Quan trọng: nhận data dưới dạng bytes
    //       followRedirects: true,
    //       validateStatus: (status) => status! < 500,
    //     ),
    //   );
    //   if (response.statusCode == 200) {
    //     // Chuyển đổi bytes thành Image object
    //     final Uint8List imageBytes = Uint8List.fromList(response.data);
    //     final img.Image? image = img.decodeImage(imageBytes);
    //     log('--- image: $image');
    //     if (image != null) {
    //       bytes += generator.image(image);
    //     }
    //   } else {
    //     log('Failed to load image: ${response.statusCode}');
    //   }
    // }
    bytes += generator.emptyLines(1);
    bytes += generator.text(
      'Quý khách vui lòng kiểm tra hàng và giữ phiếu này để làm căn cứ cho giao dịch sau',
      styles: const PosStyles(
        align: PosAlign.center,
        fontType: PosFontType.fontB,
      ),
      maxCharsPerLine: 25,
    );
    // // Lời cảm ơn - in đậm
    bytes += generator.text(
      'Cảm ơn - Hẹn gặp lại quý khách!',
      styles: const PosStyles(
        bold: true,
        underline: false,
        align: PosAlign.center,
        fontType: PosFontType.fontA,
      ),
    );

    bytes += generator.feed(2);

    return bytes;
  }

  PosColumn _posColum({
    required String title,
    int width = 6,
    PosStyles? style,
  }) {
    return PosColumn(
      textEncoded: _textUint8List(title),
      width: width,
      styles: style ?? const PosStyles(),
    );
  }

  // Hàm chuyển đổi văn bản thành byte (loại bỏ dấu tiếng Việt)
  List<int> _textToBytes(String text) {
    // return latin1.encode(text);
    return utf8.encode(text);
  }

  Uint8List _textUint8List(String text) {
    // return latin1.encode(text);
    return Uint8List.fromList(utf8.encode(text));
  }

  void selectPrinter(Printer result) async {
    emit(
      state.copyWith(
        status: BlocStatus.submit,
        msg: 'Đang kết nối đến máy in',
      ),
    );
    if (result.isConnected ?? false) {
      await _printerPlugin.disconnect(result);
    }

    final isConnected = await _printerPlugin.connect(result);
    if (isConnected == true) {
      printerSelect = result;
      emit(
        state.copyWith(
          status: BlocStatus.submitSuccess,
          msg: 'Kết nối thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.submitFailure,
          msg: 'Không thể kết nối đến máy in',
        ),
      );
    }
  }

  void onDisconnect() async {
    try {
      await _printerPlugin.disconnect(printerSelect!);
      printerSelect = null;
      emit(
        state.copyWith(status: BlocStatus.success, msg: 'Ngắt nối máy in'),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          msg: e.toString(),
        ),
      );
    }
  }

  void onPrintBarCode(
    List<ProductV2Model> prds,
    bool isPrintShopName,
    bool isPrintName,
    bool isPrintBarcode,
    bool isPrintPrice,
    bool isPrintUnit,
    String shopName,
  ) async {
    try {
      emit(state.copyWith(status: BlocStatus.submit, msg: 'Đang in hoá đơn'));
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      final List<int> bytes = [];

      for (int i = 0; i < prds.length; i++) {
        final prd = prds[i];

        if (prd.barcode.isEmptyOrNull) {
          // if (isPrintShopName) {
          //   bytes.addAll(
          //     _textToBytesV2(shopName, generator),
          //   );
          // }

          // if (isPrintName) {
          //   bytes.addAll(_textToBytesV2('${prd.name}\n', generator));
          // }
          // // bytes.addAll(
          // //   generator.barcode(
          // //     Barcode.code128(((prd.barcode.isEmptyOrNull == true
          // //             ? 'ĐÉO CÓ BARCODE'
          // //             : prd.barcode))
          // //         .split('')),
          // //     height: 30,
          // //   ),
          // // );
          // if (isPrintBarcode && !prd.barcode.isEmptyOrNull) {
          //   bytes.addAll(_textToBytesV2('${prd.barcode}\n', generator));
          // }
          // if (isPrintPrice) {
          //   bytes.addAll(
          //     _textToBytesV2(
          //       '${prd.unitSell?.sellPrice.formatCurrency} ${isPrintUnit ? 'VNĐ' : ''}\n',
          //       generator,
          //     ),
          //   );
          // }

          bytes.addAll(escAlignCenter);
          bytes.addAll(escSize2);
          bytes.addAll(escSizeNormal);
          if (isPrintShopName) {
            bytes.addAll(_textToBytes('$shopName\n'));
          }
          if (isPrintName) {
            bytes.addAll(_textToBytes('${prd.name}\n'));
          }
          bytes.addAll(
            generator.barcode(
              Barcode.code128(
                (prd.barcode.isEmptyOrNull ? 'ĐÉO CÓ BARCODE' : prd.barcode!)
                    .split(''),
              ),
              height: 50,
            ),
          );
          if (isPrintBarcode && !prd.barcode.isEmptyOrNull) {
            bytes.addAll(_textToBytes('${prd.barcode}\n'));
          }
          if (isPrintPrice) {
            bytes.addAll(
              _textToBytes(
                '${prd.unitSell?.sellPrice.formatCurrency} ${isPrintUnit ? 'VNĐ' : ''}\n',
              ),
            );
          }
        }

        bytes.addAll(_textToBytes('\n'));
      }
      // Cắt giấy
      bytes.addAll(escCut);

      await _printerPlugin.printData(printerSelect!, bytes, longData: true);
      emit(
        state.copyWith(
          status: BlocStatus.submitSuccess,
          msg: 'In hoá đơn thành công',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BlocStatus.submitFailure,
          msg: 'In hoá đơn thất bại, ${e.toString()}',
        ),
      );
    }
  }

  void selectSize(PrintType size) {
    paperSize = size;
    emit(state.copyWith(status: BlocStatus.reload));
  }

  // void initData(OrderDetailV2Model value) {
  //   _order = value;
  // }
}

enum PrintType {
  mm58('mm58', 0, PaperSize.mm58),
  mm72('mm72', 14, PaperSize.mm72),
  mm80('mm80', 22, PaperSize.mm80);

  const PrintType(this.name, this.line, this.size);
  final String name;
  final int line;
  final PaperSize size;
}
