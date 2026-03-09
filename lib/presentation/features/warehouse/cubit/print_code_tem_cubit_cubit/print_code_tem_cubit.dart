import 'dart:convert';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import 'package:injectable/injectable.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/spacing.dart';
import '../../../../features_v2/blocs/print_invoice/print_bloc.dart';
import '../../data/models/receipt_import_detail_model.dart';
import 'print_code_tem_state.dart';

@injectable
class PrintCodeTemCubit extends Cubit<PrintCodeTemState> {
  PrintCodeTemCubit() : super(const PrintCodeTemState());

  final key = GlobalKey();

  Map<int, GlobalKey> keysShipments = {};

  void init(List<ReceiptImportDetailModel> shipments) {
    for (final item in shipments) {
      keysShipments.addAll({
        item.id!: GlobalKey(),
      });
    }
    emit(state.copyWith(shipments: shipments));
  }

  void selectShipment(ReceiptImportDetailModel item) {
    final list = List<ReceiptImportDetailModel>.from(state.shipments);
    final index = list.indexWhere((e) => e.id == item.id);
    if (index == -1) return;
    list[index] = list[index].copyWith(selected: !list[index].selected);
    emit(state.copyWith(shipments: list));
  }

  void quantityChange(ReceiptImportDetailModel item) {
    final list = List<ReceiptImportDetailModel>.from(state.shipments);
    final index = list.indexWhere((e) => e.id == item.id);
    if (index == -1) return;
    list[index] = item;
    emit(state.copyWith(shipments: list));
  }

  void selectAll() {
    final list = List<ReceiptImportDetailModel>.from(state.shipments);
    for (var i = 0; i < list.length; i++) {
      list[i] = list[i].copyWith(selected: !isSelectedAll);
    }
    emit(state.copyWith(shipments: list));
  }

  bool get isSelectedAll {
    return state.shipments.indexWhere((e) => !e.selected) == -1;
  }

  Future<List<int>> dataPrint() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(
      PrintType.mm80.size,
      profile,
      codec: utf8,
      spaceBetweenRows: 0,
    );
    List<int> bytes = [];
    final listSelected = state.shipments.where((e) => e.selected).toList();
    for (final item in listSelected) {
      for (final _ in List.generate(
        item.quantityPrint ~/ 2,
        (index) => index,
      )) {
        bytes += await generateOneItem(item, generator);
      }
    }
    bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> generateOneItem(
    ReceiptImportDetailModel item,
    Generator generator,
  ) async {
    List<int> bytes = [];
    final key = keysShipments[item.id];
    // final imageEncode = await _test1(key!);
    // bytes += generator.imageRaster(imageEncode, align: PosAlign.center);
    // bytes += generator.image(imageEncode);
    // final zplConverter = ImageZplConverter(
    //   Row(
    //     children: [
    //       Expanded(
    //         child: QrImageView(
    //           padding: const EdgeInsets.all(sp0),
    //           data: 'data.id.toString()',
    //           size: sp48,
    //         ),
    //       ),
    //       8.width,
    //       const Expanded(
    //         flex: 2,
    //         child: Text(
    //           'long',
    //           textAlign: TextAlign.left,
    //           style: s18w700,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    // final zplCommand = await zplConverter.convert();
    // final raw = utf8.encode(zplCommand);
    // bytes += generator.rawBytes(raw);

    // final barCode = generator.barcode(
    //   Barcode.code128(item.id.toString().split('')),
    // );

    // bytes += generator.row([
    //   PosColumn(
    //     textEncoded: Uint8List.fromList(barCode),
    //     width: 6,
    //   ),
    //   PosColumn(
    //     textEncoded: Uint8List.fromList(barCode),
    //     width: 6,
    //   ),
    // ]);

    /// ------ oke ------
    final RenderRepaintBoundary boundary =
        key!.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // chuyển thành hình ảnh
    final imageWidget = await boundary.toImage(
      pixelRatio: 2.0,
    );
    final ByteData? byteData = await imageWidget.toByteData(
      format: ImageByteFormat.png,
    );
    final Uint8List imageBytes = byteData!.buffer.asUint8List();
    final img.Image image = img.decodeImage(imageBytes)!;

    final img.Image resized = img.copyResize(image, width: 558, height: 24);
    // bytes += generator.imageRaster(resized);
    // bytes += generator.cut();
    bytes += generator.row(
      [
        PosColumn(
          text: '${item.productData?.productName} ',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: '${item.productData?.productName} ',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
      ],
    );
    bytes += generator.image(resized);
    bytes += generator.row(
      [
        PosColumn(
          text: '${item.importPrice.formatCurrency}/${item.inputUnitData} ',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: '${item.importPrice.formatCurrency}/${item.inputUnitData} ',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
      ],
    );
    bytes += generator.row(
      [
        PosColumn(
          text: 'HSD: ${item.endDate.fomatCustom()} ',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.center,
            fontType: PosFontType.fontB,
          ),
        ),
        PosColumn(
          text: 'HSD: ${item.endDate.fomatCustom()}',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.center,
            fontType: PosFontType.fontB,
          ),
        ),
      ],
    );
    // bytes += generator.feed(1);
    bytes += generator.emptyLines(1);
    // bytes += generator.drawer(pin: PosDrawer.pin5);
    /// ------ oke ------
    ///
    // bytes += generator.text(
    //   item.productData?.productName ?? '',
    //   styles: const PosStyles(
    //     bold: true,
    //     align: PosAlign.left,
    //     fontType: PosFontType.fontA,
    //   ),
    // );
    // bytes += generator.barcode(
    //   Barcode.code128(item.id.toString().split('')),
    //   align: PosAlign.left,
    //   width: 100
    // );
    // bytes += generator.text(
    //   '${item.importPrice.formatCurrency}/${item.inputUnitData}',
    //   styles: const PosStyles(
    //     align: PosAlign.left,
    //     fontType: PosFontType.fontA,
    //   ),
    // );
    // bytes += generator.text(
    //   'HSD: ${item.endDate.fomatCustom()}',
    //   styles: const PosStyles(
    //     align: PosAlign.left,
    //     fontType: PosFontType.fontA,
    //   ),
    // );

    // Cắt giấy
    // bytes += generator.cut();

    return bytes;
  }

  Future<Uint8List> renderWidgetToImageBytes(
    Widget widget, {
    double pixelRatio = 3.0,
  }) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    final RenderView renderView = RenderView(
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        devicePixelRatio: pixelRatio,
      ),
      view: WidgetsBinding.instance.platformDispatcher.views.first,
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

    final RenderObjectToWidgetElement<RenderBox> rootElement =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
    ).attachToRenderTree(buildOwner);

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final ui.Image image =
        await repaintBoundary.toImage(pixelRatio: pixelRatio);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<img.Image> _test1(GlobalKey globalKey) async {
    try {
      // tìm đối tượng render
      final RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // chuyển thành hình ảnh
      final image = await boundary.toImage(
        pixelRatio: 2.0,
      ); // chỉnh pixelRatio nếu cần

      // encode sang byte
      final ByteData? byteData =
          await image.toByteData(format: ImageByteFormat.png);

      final Uint8List imageBytes = byteData!.buffer.asUint8List();
      // decode the bytes into an image
      final decodedImage = img.decodeImage(imageBytes)!;
      // Create a black bottom layer
      // Resize the image to a 130x? thumbnail (maintaining the aspect ratio).
      img.Image thumbnail = img.copyResize(decodedImage, height: 130);
      // creates a copy of the original image with set dimensions
      final img.Image originalImg =
          img.copyResize(decodedImage, width: 380, height: 130);
      // fills the original image with a white background
      img.fill(originalImg, color: img.ColorRgb8(255, 255, 255));

      //insert the image inside the frame and center it
      // drawImage(originalImg, thumbnail, dstX: padding.toInt());

      // convert image to grayscale
      return img.grayscale(originalImg);
    } catch (e) {
      throw Exception('Chụp widget thất bại: $e');
    }
  }
}
