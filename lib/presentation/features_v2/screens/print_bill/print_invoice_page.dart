// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:auto_route/auto_route.dart';
// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:pharmago/presentation/base/app_bar.dart';
// import 'package:pharmago/presentation/base/row_item.dart';
// import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
// import 'package:pharmago/presentation/constants/spacing.dart';
// import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
// import 'package:pharmago/presentation/router/router.gr.dart';
// import 'package:pharmago/shared/ext/init_ext.dart';
// import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

// import 'package:pharmago/presentation/features/company/data/models/company_model.dart';
// import 'package:pharmago/presentation/features_v2/models/order/order_detail_v2_model.dart';
// import 'package:image/image.dart' as img;

// @RoutePage()
// class PrintInvoiceScreen extends StatefulWidget {
//   const PrintInvoiceScreen({super.key, required this.order});


//   @override
//   State<PrintInvoiceScreen> createState() => _PrintInvoiceScreenState();
// }

// class _PrintInvoiceScreenState extends State<PrintInvoiceScreen> {
//   // Models & data
//   OrderDetailV2Model get _order => widget.order;
//   CompanyModel? get _company => _order.company;
//   Customer? get _customer => _order.customer;
//   List<OrderItemV2> get _items => _order.items;
//   List<OrderServiceItemV2> get _services => _order.services;

//   num get _totalPriceProd =>
//       _items.fold<num>(0, (t, e) => t + e.priceItem) +
//       _services.fold<num>(0, (t, e) => t + e.totalPrice);
//   num get _totalDiscount =>
//       _items.fold<num>(
//         0,
//         (t, e) => t + e.discountPrice.validator * e.quantity,
//       ) +
//       _services.fold<num>(0, (t, e) => t + e.totalDiscount);

//   List<BluetoothInfo> devices = [];
//   BluetoothInfo? _selectedDevice;
//   bool _isConnected = false;
//   bool _isScanning = false;
//   String _connectionStatus = 'Chưa kết nối';
//   String _printerStatus = '';
//   bool _isPrinting = false;

//   // ESC/POS commands
//   static const List<int> escReset = [27, 64]; // ESC @ - Reset printer
//   static const List<int> escCut = [29, 86, 65, 0]; // GS V 65 0 - Full cut
//   static const List<int> escAlignCenter = [27, 97, 1]; // ESC a 1 - Center align
//   static const List<int> escAlignLeft = [27, 97, 0]; // ESC a 0 - Left align
//   static const List<int> escAlignRight = [27, 97, 2]; // ESC a 2 - Right align
//   static const List<int> escBoldOn = [27, 69, 1]; // ESC E 1 - Bold on
//   static const List<int> escBoldOff = [27, 69, 0]; // ESC E 0 - Bold off
//   static const List<int> escSizeNormal = [29, 33, 0]; // GS ! 0 - Normal size
//   static const List<int> escSize2 = [29, 33, 17]; // GS ! 17 - Double h&w

//   @override
//   void initState() {
//     super.initState();
//     _checkBluetoothStatus();
//   }

//   Future<void> _checkBluetoothStatus() async {
//     try {
//       final bool isEnabled = await PrintBluetoothThermal.bluetoothEnabled;
//       if (!isEnabled) {
//         setState(() => _printerStatus = 'Bluetooth chưa bật');
//       } else {
//         _requestPermissions();
//       }
//     } catch (e) {}
//   }

//   Future<void> _requestPermissions() async {
//     if (Platform.isAndroid) {
//       final Map<Permission, PermissionStatus> statuses = await [
//         Permission.bluetooth,
//         Permission.bluetoothScan,
//         Permission.bluetoothConnect,
//         Permission.location,
//       ].request();

//       if (statuses[Permission.bluetooth]!.isGranted &&
//           statuses[Permission.bluetoothConnect]!.isGranted &&
//           statuses[Permission.location]!.isGranted) {
//         _scanDevices();
//       } else {
//         setState(() {
//           openAppSettings();
//           _printerStatus = 'Cần cấp quyền để sử dụng Bluetooth';
//         });
//       }
//     } else if (Platform.isIOS) {
//       // iOS: chỉ cần đảm bảo đã khai báo đầy đủ trong Info.plist
//       _scanDevices();
//     }
//   }

//   // SỬA LỖI: Loại bỏ kiểm tra kết nối trong quá trình quét
//   Future<void> _scanDevices() async {
//     setState(() {
//       _isScanning = true;
//       devices = [];
//       _printerStatus = 'Đang tìm kiếm thiết bị...';
//     });

//     try {
//       final List<BluetoothInfo> result =
//           await PrintBluetoothThermal.pairedBluetooths;

//       setState(() {
//         devices = result;
//         _isScanning = false;
//         _printerStatus = devices.isEmpty ? 'Không tìm thấy thiết bị' : '';
//       });
//     } catch (e) {
//       setState(() {
//         _isScanning = false;
//         _printerStatus = 'Lỗi khi tìm kiếm thiết bị';
//       });
//     }
//   }

//   Future<void> _connectToDevice(BluetoothInfo device) async {
//     setState(() {
//       _connectionStatus = 'Đang kết nối...';
//     });

//     try {
//       // Đảm bảo ngắt kết nối trước khi kết nối mới
//       if (_isConnected && _selectedDevice != null) {
//         await PrintBluetoothThermal.disconnect;
//       }

//       final bool connected = await PrintBluetoothThermal.connect(
//         macPrinterAddress: device.macAdress,
//       );

//       setState(() {
//         _isConnected = connected;
//         _selectedDevice = device;
//         _connectionStatus =
//             connected ? 'Đã kết nối đến ${device.name}' : 'Kết nối thất bại';
//       });

//       if (connected) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Đã kết nối đến ${device.name}')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Không thể kết nối đến thiết bị')),
//         );
//       }
//     } catch (e) {
//       setState(() => _connectionStatus = 'Lỗi kết nối: ${e.toString()}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lỗi kết nối: ${e.toString()}')),
//       );
//     }
//   }

//   Future<void> _disconnect() async {
//     try {
//       await PrintBluetoothThermal.disconnect;
//       setState(() {
//         _isConnected = false;
//         _selectedDevice = null;
//         _connectionStatus = 'Đã ngắt kết nối';
//       });
//     } catch (e) {}
//   }

//   Future<void> _printInvoice() async {
//     if (!_isConnected || _selectedDevice == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Chưa kết nối đến thiết bị')),
//       );
//       return;
//     }

//     setState(() => _isPrinting = true);

//     try {
//       final invoiceBytes = await _generateInvoice();

//       // Chia nhỏ dữ liệu để gửi an toàn
//       const chunkSize = 100;
//       for (var i = 0; i < invoiceBytes.length; i += chunkSize) {
//         final end = (i + chunkSize < invoiceBytes.length)
//             ? i + chunkSize
//             : invoiceBytes.length;
//         final chunk = invoiceBytes.sublist(i, end);
//         await PrintBluetoothThermal.writeBytes(chunk);
//         await Future.delayed(const Duration(milliseconds: 50));
//       }

//       // await PrintBluetoothThermal.writeBytes(invoiceBytes);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Đã gửi lệnh in thành công!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lỗi khi in: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => _isPrinting = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Hoàn thành lệnh in!')),
//       );
//     }
//   }

//   // void scanForBlePrinters() {
//   //   // final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

//   //   // Bắt đầu quét
//   //   FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

//   //   // Lắng nghe thiết bị tìm được
//   //   FlutterBluePlus.scanResults.listen((results) {
//   //     for (ScanResult r in results) {
//   //       // Lọc theo tên hoặc MAC nếu cần
//   //       if (r.device.name.contains('Printer') || r.device.name.isNotEmpty) {
//   //         print('========FlutterBluePlus suceess');
//   //       }
//   //     }
//   //   });

//   //   // Sau 5s tự dừng quét
//   //   Future.delayed(const Duration(seconds: 5), () {
//   //     FlutterBluePlus.stopScan();
//   //   });
//   // }

// // Tạo nội dung hoá đơn dạng bytes (ESC/POS)
//   Future<List<int>> _generateInvoice() async {
//     final List<int> bytes = [];

//     // Reset máy in
//     bytes.addAll(escReset);

//     // Tiêu đề cửa hàng - căn giữa, in đậm, cỡ chữ to
//     bytes.addAll(escAlignCenter);
//     bytes.addAll(escSize2);
//     bytes.addAll(escSizeNormal);
//     bytes.addAll(_textToBytes('${_company?.name}\n'));
//     bytes.addAll(escSizeNormal);
//     bytes.addAll(escSizeNormal);

//     // Địa chỉ cửa hàng
//     bytes.addAll(_textToBytes('${_company?.address?.fullAddress ?? ''}\n'));

//     // MST và Hotline
//     bytes.addAll(_textToBytes('MST: ${_company?.taxCode ?? '---'}'));
//     bytes.addAll(
//       _textToBytes('   Hotline: ${_company?.phoneNumber ?? '---'}\n\n'),
//     );

//     // Tiêu đề hóa đơn
//     bytes.addAll(escSizeNormal);
//     bytes.addAll(escSize2);
//     bytes.addAll(_textToBytes('HOA DON THANH TOAN\n\n'));
//     bytes.addAll(escSizeNormal);
//     bytes.addAll(escSizeNormal);

//     // Thông tin đơn hàng - căn trái
//     bytes.addAll(escAlignLeft);
//     bytes.addAll(_textToBytes('Ma DH: ${_order.code ?? '---'}\n'));
//     bytes.addAll(
//       _textToBytes(
//         'Thoi gian: ${_order.createdAt.fomatCustom(fomat: 'hh:mm - dd/M/y')}\n',
//       ),
//     );
//     bytes.addAll(_textToBytes('Ten KH: ${_customer?.prefixName ?? '---'}\n'));
//     bytes.addAll(_textToBytes('SDT: ${_customer?.phone ?? '---'}\n'));
//     bytes.addAll(_textToBytes('Thu ngan: [Ten thu ngan]\n'));

//     // Đường kẻ ngang
//     bytes.addAll(escAlignCenter);
//     bytes.addAll(_textToBytes('--------------------------------\n'));

//     // Tiêu đề bảng - căn trái, in đậm
//     bytes.addAll(escAlignLeft);
//     bytes.addAll(escBoldOn);
//     bytes.addAll(
//       _textToBytes(
//         'STT   Ten                          SL   DVT   Don gia   CK   Thanh tien\n',
//       ),
//     );
//     bytes.addAll(escBoldOff);
//     bytes.addAll(_textToBytes('--------------------------------\n'));

//     // Danh sách dịch vụ
//     if (_services.isNotEmpty) {
//       bytes.addAll(escBoldOn);
//       bytes.addAll(_textToBytes('DICH VU:\n'));
//       bytes.addAll(escBoldOff);

//       for (int i = 0; i < _services.length; i++) {
//         final service = _services[i];
//         final pricePay = service.totalPrice;
//         final discount = service.totalDiscount;

//         bytes.addAll(_textToBytes('${i + 1}. ${service.service?.title}\n'));
//         bytes.addAll(_textToBytes('   SL: ${service.quantity}'));
//         bytes.addAll(
//           _textToBytes('   ${service.service?.price?.priceNameSub ?? ''}'),
//         );
//         bytes.addAll(_textToBytes('   ${service.price.formatPrice()}'));
//         bytes.addAll(
//           _textToBytes(
//             '   ${discount > 0 ? '-${discount.formatPrice()}' : '0'}',
//           ),
//         );
//         bytes.addAll(_textToBytes('   ${pricePay.formatPrice()}\n'));
//       }
//       bytes.addAll(_textToBytes('--------------------------------\n'));
//     }

//     // Danh sách sản phẩm
//     if (_items.isNotEmpty) {
//       bytes.addAll(escSizeNormal);
//       bytes.addAll(_textToBytes('SAN PHAM:\n'));
//       bytes.addAll(escSizeNormal);

//       for (int i = 0; i < _items.length; i++) {
//         final item = _items[i];
//         final pricePay = item.quantity * item.priceItem;
//         final discount = item.discountPrice;

//         bytes.addAll(_textToBytes('${i + 1}. ${item.productData?.name}\n'));
//         bytes.addAll(_textToBytes('   SL: ${item.quantity}'));
//         bytes.addAll(_textToBytes('   ${item.unitData?.name ?? ''}'));
//         bytes.addAll(_textToBytes('   ${item.priceItem.formatPrice()}'));
//         bytes.addAll(
//           _textToBytes(
//             '   ${discount > 0 ? '-${discount.formatPrice()}' : '0'}',
//           ),
//         );
//         bytes.addAll(_textToBytes('   ${pricePay.formatPrice()}\n'));
//       }
//       bytes.addAll(_textToBytes('--------------------------------\n'));
//     }

//     // Tổng thanh toán - căn phải
//     bytes.addAll(escAlignRight);

//     // Tổng tiền hàng
//     bytes.addAll(
//       _textToBytes('Tong tien hang: ${_totalPriceProd.formatPrice()}\n'),
//     );

//     // Chiết khấu
//     bytes.addAll(_textToBytes('Chiet khau: ${_totalDiscount.formatPrice()}\n'));

//     // VAT (nếu có)
//     if (_order.redInvoice) {
//       // VAT cho sản phẩm
//       for (int i = 0; i < _items.length; i++) {
//         final item = _items[i];
//         if (item.vatProd > 0) {
//           final vatAmount = item.vatProd;
//           bytes.addAll(
//             _textToBytes(
//               'VAT ${item.productData?.vat}% cua (${item.priceItem.formatPrice()}): ${vatAmount.formatPrice()}\n',
//             ),
//           );
//         }
//       }

//       // VAT cho dịch vụ
//       for (int i = 0; i < _services.length; i++) {
//         final service = _services[i];
//         if (service.vat > 0) {
//           bytes.addAll(
//             _textToBytes(
//               'VAT ${service.service?.vat}% cua (${service.totalPrice.formatPrice()}): ${service.vat.formatPrice()}\n',
//             ),
//           );
//         }
//       }
//     }

//     // Tổng thanh toán - in đậm, cỡ chữ to
//     bytes.addAll(escSizeNormal);
//     bytes.addAll(escSize2);
//     bytes.addAll(
//       _textToBytes(
//         'TONG THANH TOAN: ${_order.totalPrice.formatPrice()}\n\n',
//       ),
//     );
//     bytes.addAll(escSizeNormal);
//     bytes.addAll(escSizeNormal);

//     // Lưu ý - căn giữa
//     bytes.addAll(escAlignCenter);
//     bytes.addAll(_textToBytes('Luu y\n'));
//     bytes.addAll(
//       _textToBytes('Quy khach vui long kiem tra hang va giu phieu nay\n'),
//     );
//     bytes.addAll(_textToBytes('de lam can cu cho giao dich sau.\n\n'));

//     // Lời cảm ơn - in đậm
//     bytes.addAll(escBoldOn);
//     bytes.addAll(_textToBytes('Cam on - Hen gap lai quy khach!\n\n\n'));
//     bytes.addAll(escBoldOff);

//     // Cắt giấy
//     bytes.addAll(escCut);

//     return bytes;
//   }

//   // Hàm chuyển đổi văn bản thành byte (loại bỏ dấu tiếng Việt)
//   List<int> _textToBytes(String text) {
//     const withDia =
//         'ÀÁÂãÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠạẢảẤấẦầẨẩẪẫẬậẮắẰằẲẳẴẵẶặẸẹẺẻẼẽẾếỀềỂểỄễỆệỈỉỊịỌọỎỏỐốỒồỔổỖỗỘộỚớỜờỞởỠỡỢợỤụỦủỨứỪừỬửỮữỰựỲỳỴỵỶỷỸỹ';
//     const withoutDia =
//         'AAAAEEEIIOOOOUUYaaaaeeeiioooouuyAaDdIiUuOoUuAaAaAaAaAaAaAaAaAaAaAaAaEeEeEeEeEeEeEeEeIiIiOoOoOoOoOoOoOoOoOoOoOoOoUuUuUuUuUuUuUuYyYyYyYy';

//     for (int i = 0; i < withDia.length; i++) {
//       text = text.replaceAll(withDia[i], withoutDia[i]);
//     }

//     return latin1.encode(text);
//   }

//   String optionprinttype = "58 mm";
//   Future<List<int>> testTicket() async {
//     List<int> bytes = [];
//     // Using default profile
//     final profile = await CapabilityProfile.load();
//     final generator = Generator(
//         optionprinttype == '58 mm' ? PaperSize.mm58 : PaperSize.mm80, profile);
//     //bytes += generator.setGlobalFont(PosFontType.fontA);
//     bytes += generator.reset();

//     final ByteData data = await rootBundle.load('assets/logo.png');
//     final Uint8List bytesImg = data.buffer.asUint8List();
//     final img.Image? image = img.decodeImage(bytesImg);

//     if (Platform.isIOS) {
//       // Resizes the image to half its original size and reduces the quality to 80%
//       final resizedImage = img.copyResize(image!,
//           width: image.width ~/ 1.3,
//           height: image.height ~/ 1.3,
//           interpolation: img.Interpolation.nearest);
//       final bytesimg = Uint8List.fromList(img.encodeJpg(resizedImage));
//       //image = img.decodeImage(bytesimg);
//     }

//     //Using `ESC *`
//     //bytes += generator.image(image!);

//     bytes += generator.text(
//         'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
//     bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ',
//         styles: const PosStyles(codeTable: 'CP1252'));
//     bytes += generator.text('Special 2: blåbærgrød',
//         styles: const PosStyles(codeTable: 'CP1252'));

//     bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
//     bytes +=
//         generator.text('Reverse text', styles: const PosStyles(reverse: true));
//     bytes += generator.text('Underlined text',
//         styles: const PosStyles(underline: true), linesAfter: 1);
//     bytes += generator.text('Align left',
//         styles: const PosStyles(align: PosAlign.left));
//     bytes += generator.text('Align center',
//         styles: const PosStyles(align: PosAlign.center));
//     bytes += generator.text('Align right',
//         styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

//     bytes += generator.row([
//       PosColumn(
//         text: 'col3',
//         width: 3,
//         styles: const PosStyles(align: PosAlign.center, underline: true),
//       ),
//       PosColumn(
//         text: 'col6',
//         width: 6,
//         styles: const PosStyles(align: PosAlign.center, underline: true),
//       ),
//       PosColumn(
//         text: 'col3',
//         width: 3,
//         styles: const PosStyles(align: PosAlign.center, underline: true),
//       ),
//     ]);

//     //barcode

//     final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
//     bytes += generator.barcode(Barcode.upcA(barData));

//     //QR code
//     bytes += generator.qrcode('example.com');

//     bytes += generator.text(
//       'Text size 50%',
//       styles: const PosStyles(
//         fontType: PosFontType.fontB,
//       ),
//     );
//     bytes += generator.text(
//       'Text size 100%',
//       styles: const PosStyles(
//         fontType: PosFontType.fontA,
//       ),
//     );
//     bytes += generator.text(
//       'Text size 200%',
//       styles: const PosStyles(
//         height: PosTextSize.size2,
//         width: PosTextSize.size2,
//       ),
//     );

//     bytes += generator.feed(2);
//     //bytes += generator.cut();
//     return bytes;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: BaseAppBar(
//         title: 'In Hoá Đơn Bluetooth',
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.print,
//               color: AppColors.black,
//             ),
//             onPressed: () async {
//               final result = await context.router.push(
//                 SelectPrintRoute(
//                   deviceSelected: _selectedDevice,
//                   devices: devices,
//                 ),
//               );
//               if (result is BluetoothInfo) {
//                 _connectToDevice(result);
//               }
//             },
//             // tooltip: 'Quét lại thiết bị',
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Trạng thái máy in
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               color: Colors.grey[200],
//               child: Row(
//                 children: [
//                   Icon(
//                     _isConnected
//                         ? Icons.bluetooth_connected
//                         : Icons.bluetooth_disabled,
//                     color: _isConnected ? Colors.blue : Colors.grey,
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _connectionStatus,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color:
//                                 _isConnected ? Colors.green : Colors.grey[700],
//                           ),
//                         ),
//                         if (_printerStatus.isNotEmpty)
//                           Text(
//                             _printerStatus,
//                             style: TextStyle(
//                               color: Colors.orange[700],
//                               fontSize: 12,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Nút in hoá đơn và ngắt kết nối
//             if (_isConnected)
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         icon: const Icon(Icons.print),
//                         label: const Text('IN HOÁ ĐƠN'),
//                         onPressed: _isPrinting ? null : _printInvoice,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     ElevatedButton.icon(
//                       icon: const Icon(Icons.bluetooth_disabled),
//                       label: const Text('NGẮT'),
//                       onPressed: _disconnect,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 15,
//                           horizontal: 15,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             _buildPdf().padding(16.pading),

//             // Tiêu đề danh sách thiết bị
//             // Padding(
//             //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             //   child: Row(
//             //     children: [
//             //       const Text(
//             //         'THIẾT BỊ BLUETOOTH',
//             //         style: TextStyle(
//             //           fontWeight: FontWeight.bold,
//             //           color: Colors.blue,
//             //         ),
//             //       ),
//             //       const Spacer(),
//             //       if (_isScanning)
//             //         const SizedBox(
//             //           width: 20,
//             //           height: 20,
//             //           child: CircularProgressIndicator(strokeWidth: 2),
//             //         ),
//             //     ],
//             //   ),
//             // ),

//             // Danh sách thiết bị
//             // devices.isEmpty
//             //     ? Center(
//             //         child: Column(
//             //           mainAxisAlignment: MainAxisAlignment.center,
//             //           children: [
//             //             Icon(
//             //               Icons.bluetooth,
//             //               size: 50,
//             //               color: Colors.grey[400],
//             //             ),
//             //             const SizedBox(height: 20),
//             //             Text(
//             //               _isScanning
//             //                   ? 'Đang tìm kiếm thiết bị...'
//             //                   : 'Không tìm thấy thiết bị',
//             //               style: TextStyle(color: Colors.grey[600]),
//             //             ),
//             //             const SizedBox(height: 20),
//             //             ElevatedButton(
//             //               onPressed: _requestPermissions,
//             //               child: const Text('QUÉT LẠI THIẾT BỊ'),
//             //             ),
//             //           ],
//             //         ),
//             //       )
//             //     : ListView.builder(
//             //         physics: const NeverScrollableScrollPhysics(),
//             //         shrinkWrap: true,
//             //         itemCount: devices.length,
//             //         itemBuilder: (context, index) {
//             //           final device = devices[index];
//             //           return Card(
//             //             margin: const EdgeInsets.symmetric(
//             //               horizontal: 10,
//             //               vertical: 5,
//             //             ),
//             //             elevation: 2,
//             //             child: ListTile(
//             //               leading: const Icon(Icons.print, color: Colors.blue),
//             //               title: Text(
//             //                 device.name,
//             //                 style: const TextStyle(fontWeight: FontWeight.w500),
//             //               ),
//             //               subtitle: Text(device.macAdress),
//             //               trailing:
//             //                   _selectedDevice?.macAdress == device.macAdress
//             //                       ? const Icon(
//             //                           Icons.check_circle,
//             //                           color: Colors.green,
//             //                         )
//             //                       : null,
//             //               onTap: () => _connectToDevice(device),
//             //             ),
//             //           );
//             //         },
//             //       ),

//             // if (devices.isNotEmpty)
//             //   MainButtonV2(
//             //     title: 'Chọn thiết bị',
//             //     onTap: () {
//             //       context.router.push(SelectPrintRoute(
//             //         deviceSelected: _selectedDevice,
//             //         devices: devices,
//             //         onPrint: () => _printInvoice(),
//             //       ));
//             //     },
//             //   )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPdf() {
//     // Hàm loại bỏ dấu tiếng Việt (giống trong _generateInvoice)
//     String removeDiacritics(String text) {
//       const withDia =
//           'ÀÁÂãÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠạẢảẤấẦầẨẩẪẫẬậẮắẰằẲẳẴẵẶặẸẹẺẻẼẽẾếỀềỂểỄễỆệỈỉỊịỌọỎỏỐốỒồỔổỖỗỘộỚớỜờỞởỠỡỢợỤụỦủỨứỪừỬửỮữỰựỲỳỴỵỶỷỸỹ';
//       const withoutDia =
//           'AAAAEEEIIOOOOUUYaaaaeeeiioooouuyAaDdIiUuOoUuAaAaAaAaAaAaAaAaAaAaAaAaEeEeEeEeEeEeEeEeIiIiOoOoOoOoOoOoOoOoOoOoOoOoUuUuUuUuUuUuUuYyYyYyYy';

//       for (int i = 0; i < withDia.length; i++) {
//         text = text.replaceAll(withDia[i], withoutDia[i]);
//       }
//       return text;
//     }

//     // Helper để tạo text không dấu
//     Widget noDiacriticText(String text, [TextStyle? style]) {
//       return Text(
//         removeDiacritics(text),
//         style: style,
//       );
//     }

//     // Helper để tạo text không dấu với căn chỉnh
//     Widget noDiacriticTextAlign(
//       String text,
//       TextAlign align, [
//       TextStyle? style,
//     ]) {
//       return Text(
//         removeDiacritics(text),
//         style: style,
//         textAlign: align,
//       );
//     }

//     final TextStyle titleStyle = TextStyle(
//       fontSize: 24,
//       fontWeight: FontWeight.bold,
//       color: blackColor,
//     );

//     final TextStyle normalStyle = TextStyle(
//       fontSize: 18,
//       fontWeight: FontWeight.normal,
//       color: blackColor,
//     );

//     final TextStyle boldStyle = TextStyle(
//       fontSize: 18,
//       fontWeight: FontWeight.bold,
//       color: blackColor,
//     );

//     TextStyle emptyTextStyle(String? text) =>
//         text.isEmptyOrNull ? normalStyle : boldStyle;

//     Widget tabelInfo({
//       required String text1,
//       required String type,
//       String? text2,
//       String? text3,
//     }) =>
//         Row(
//           children: [
//             Expanded(
//               flex: 2,
//               child: noDiacriticText(text1, normalStyle),
//             ),
//             gap(width: 6),
//             Expanded(
//               flex: 3,
//               child: noDiacriticText(
//                 text2 ?? ' --- ',
//                 emptyTextStyle(text2),
//               ),
//             ),
//             gap(width: 6),
//             Expanded(
//               flex: 5,
//               child: Row(
//                 children: [
//                   noDiacriticText(type, normalStyle),
//                   Expanded(
//                     child: noDiacriticText(
//                       text3 ?? ' --- ',
//                       emptyTextStyle(text3),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );

//     Widget header() => Column(
//           children: [
//             noDiacriticTextAlign(
//               _company?.name ?? '',
//               TextAlign.center,
//               titleStyle,
//             ),
//             gap(height: sp4),
//             noDiacriticTextAlign(
//               _company?.address?.fullAddress ?? '',
//               TextAlign.center,
//               normalStyle,
//             ),
//             gap(height: sp4),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 noDiacriticText(
//                   'MST: ${_company?.taxCode ?? "---"}',
//                   normalStyle,
//                 ),
//                 gap(width: sp24),
//                 noDiacriticText(
//                   'Hotline: ${_company?.phone ?? '---'}',
//                   normalStyle,
//                 ),
//               ],
//             ),
//             gap(height: sp24),
//             noDiacriticTextAlign(
//               'HOA DON THANH TOAN',
//               TextAlign.center,
//               titleStyle,
//             ),
//             gap(height: sp24),
//             _item('Ma DH:', title: _order.code),
//             _item(
//               'Thoi gian:',
//               title: _order.createdAt.fomatCustom(fomat: 'hh:mm - dd/M/y'),
//             ),
//             _item('Ten KH:', title: _customer?.prefixName),
//             _item('SDT:', title: _customer?.phone),
//             _item('Thu ngan:'),
//             _item('SDT:'),
//             // tabelInfo(
//             //   text1: 'Ma DH:',
//             //   type: '',
//             //   text2: _order.code,
//             //   text3: _order.createdAt.fomatCustom(fomat: 'hh:mm - dd/M/y'),
//             // ),
//             // gap(height: 4),
//             // tabelInfo(
//             //   text1: 'Ten KH:',
//             //   type: 'SDT: ',
//             //   text2: _customer?.prefixName,
//             //   text3: _customer?.phone,
//             // ),
//             // gap(height: 4),
//             // tabelInfo(
//             //   text1: 'Thu ngan:',
//             //   type: 'SDT: ',
//             // ),
//             gap(height: 24),
//             divider,
//             gap(height: 24),
//           ],
//         );

//     Row tabelRow({
//       String? index,
//       int? count,
//       String? unit,
//       String? price,
//       String? discount,
//       String? pricePay,
//     }) =>
//         Row(
//           children: [
//             Expanded(
//               child: noDiacriticText(
//                 index ?? '#',
//               ),
//             ),
//             gap(width: 4),
//             Expanded(
//               child: noDiacriticText(
//                 '${count ?? 'SL'}',
//                 count != null ? boldStyle : normalStyle,
//               ),
//             ),
//             gap(width: 4),
//             Expanded(
//               flex: 2,
//               child: noDiacriticText(
//                 unit ?? 'DVT',
//                 unit != null ? boldStyle : normalStyle,
//               ),
//             ),
//             gap(width: 4),
//             Expanded(
//               flex: 3,
//               child: noDiacriticText(
//                 price ?? 'Don gia',
//                 emptyTextStyle(price),
//               ),
//             ),
//             gap(width: 4),
//             Expanded(
//               flex: 3,
//               child: noDiacriticText(
//                 discount ?? 'Chiet khau',
//                 emptyTextStyle(discount),
//               ),
//             ),
//             gap(width: 4),
//             Expanded(
//               flex: 3,
//               child: noDiacriticText(
//                 pricePay ?? 'Thanh tien',
//                 emptyTextStyle(pricePay),
//               ),
//             ),
//           ],
//         );

//     Padding itemData({
//       required int index,
//       OrderServiceItemV2? service,
//       OrderItemV2? item,
//     }) {
//       //Service
//       final pricePayService = service == null
//           ? 0
//           : service.quantity.validator *
//               (service.price.validator - service.discountPrice.validator);
//       final discountService = service == null ? 0 : service.discountPrice;

//       //item
//       final pricePayItem =
//           item == null ? 0 : item.quantity.validator * item.price;
//       final discountItem = item == null ? 0 : item.discountPrice;

//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: noDiacriticText(
//                     '${index + 1}',
//                     boldStyle,
//                   ),
//                 ),
//                 gap(width: 4),
//                 Expanded(
//                   flex: 12,
//                   child: noDiacriticText(
//                     service?.service?.title ?? item?.productData?.name ?? '',
//                     boldStyle,
//                   ),
//                 ),
//               ],
//             ),
//             gap(height: 16),
//             if (service != null)
//               tabelRow(
//                 index: '',
//                 unit: service.service?.price?.priceNameSub ?? '',
//                 count: service.quantity,
//                 discount: discountService.validator > 0
//                     ? '-${discountService.formatPrice()}'
//                     : '0',
//                 price: service.price.formatPrice(),
//                 pricePay: pricePayService.formatPrice(),
//               ),
//             if (item != null)
//               tabelRow(
//                 index: '',
//                 unit: item.unitData?.name ?? '',
//                 count: item.quantity,
//                 discount: discountItem.validator > 0
//                     ? '-${discountItem.formatPrice()}'
//                     : '0',
//                 price: item.priceItem.formatPrice(),
//                 pricePay: pricePayItem.formatPrice(),
//               ),
//           ],
//         ),
//       );
//     }

//     final body = Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         tabelRow(),
//         gap(height: 12),
//         if (_services.isNotEmpty) ...[
//           Container(
//             color: blackColor,
//             padding: const EdgeInsets.all(8),
//             child: noDiacriticText(
//               'DANH SACH DICH VU'.toUpperCase(),
//               titleStyle.copyWith(
//                 color: whiteColor,
//               ),
//             ),
//           ),
//           ListView.separated(
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             padding: EdgeInsets.zero,
//             itemCount: _services.length,
//             separatorBuilder: (context, index) => divider,
//             itemBuilder: (context, index) => itemData(
//               index: index,
//               service: _services[index],
//             ),
//           ),
//         ],
//         if (_items.isNotEmpty) ...[
//           Container(
//             color: blackColor,
//             padding: const EdgeInsets.all(8),
//             child: noDiacriticText(
//               'DANH SACH SAN PHAM'.toUpperCase(),
//               titleStyle.copyWith(
//                 color: whiteColor,
//               ),
//             ),
//           ),
//           ListView.separated(
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             padding: EdgeInsets.zero,
//             itemCount: _items.length,
//             separatorBuilder: (context, index) => divider,
//             itemBuilder: (context, index) => itemData(
//               index: index,
//               item: _items[index],
//             ),
//           ),
//         ],
//       ],
//     );

//     Row rowText({
//       required String title,
//       required String content,
//     }) =>
//         Row(
//           children: [
//             noDiacriticText(
//               title,
//               normalStyle,
//             ),
//             gap(width: 12),
//             Expanded(
//               child: noDiacriticText(
//                 content,
//                 normalStyle,
//               ),
//             ),
//           ],
//         );

//     final buildVat = Column(
//       children: [
//         ...List.generate(
//           _items.length,
//           (index) {
//             if ((_items[index].productData?.vat ?? 0) <= 0) {
//               return gap();
//             }
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 6),
//               child: rowText(
//                 title:
//                     'VAT ${_items[index].productData?.vat}% cua (${_items[index].priceItem.formatPrice(type: ' d')})',
//                 content: _items[index].vatProd.formatPrice(type: ' d'),
//               ),
//             );
//           },
//         ),
//         ...List.generate(
//           _services.length,
//           (index) {
//             final service = _services[index].service;
//             if ((service?.vat ?? 0) <= 0) {
//               return gap();
//             }

//             return Padding(
//               padding: const EdgeInsets.only(bottom: 6),
//               child: rowText(
//                 title:
//                     'VAT ${service?.vat ?? 0}% cua (${_services[index].totalPrice.formatPrice(type: ' d')})',
//                 content: _services[index].vat.formatPrice(type: ' d'),
//               ),
//             );
//           },
//         ),
//       ],
//     );

//     final payment = Column(
//       children: [
//         rowText(
//           title: 'Tong tien hang',
//           content: _totalPriceProd.formatPrice(type: ' d'),
//         ),
//         gap(height: 6),
//         rowText(
//           title: 'Chiet khau',
//           content: _totalDiscount.formatPrice(type: ' d'),
//         ),
//         gap(height: 6),
//         if (_order.redInvoice) buildVat,
//         divider,
//         gap(height: 16),
//         Row(
//           children: [
//             noDiacriticText(
//               'Tong thanh toan',
//               normalStyle,
//             ),
//             gap(width: 12),
//             Expanded(
//               child: noDiacriticText(
//                 _order.totalPrice.formatPrice(type: ' d'),
//                 titleStyle,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );

//     return Container(
//       alignment: Alignment.center,
//       child: Column(
//         children: [
//           header(),
//           body,
//           gap(height: 24),
//           payment,
//           gap(height: 24),
//           noDiacriticTextAlign(
//             'Luu y',
//             TextAlign.center,
//           ),
//           gap(height: 12),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30),
//             child: noDiacriticTextAlign(
//               'Quy khach vui long kiem tra hang va giu phieu nay de lam can cu cho giao dich sau.',
//               TextAlign.center,
//             ),
//           ),
//           gap(height: 24),
//           noDiacriticTextAlign(
//             'Cam on - Hen gap lai quy khach!',
//             TextAlign.center,
//             boldStyle,
//           ),
//         ],
//       ),
//     );
//   }

//   RowItem _item(String name, {String? title}) {
//     return RowItem(
//       title: name,
//       content: title ?? '---',
//       titleStyle: s18w400.copyWith(color: AppColors.text_primary),
//       contetnStyle: s18w700,
//     );
//   }

//   final blackColor = AppColors.bg_black;
//   final whiteColor = AppColors.white;
//   final greyColor = AppColors.grey60;

//   Divider get divider => Divider(
//         thickness: 1,
//         height: 0,
//         color: greyColor,
//       );

//   SizedBox gap({
//     double? height,
//     double? width,
//   }) =>
//       SizedBox(width: width, height: height);
// }
