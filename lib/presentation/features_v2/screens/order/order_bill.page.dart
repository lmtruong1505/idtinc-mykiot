import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../../features/company/data/models/company_model.dart';
import '../../models/order/order_detail_v2_model.dart';

@RoutePage()
class OrderBillPage extends StatefulWidget {
  const OrderBillPage({super.key, required this.order});

  final OrderDetailV2Model order;

  @override
  State<OrderBillPage> createState() => _OrderBillPageState();
}

class _OrderBillPageState extends State<OrderBillPage> {
  final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: 16.padingHor + 24.padingVer,
        width: widthDevice(context),
        child: SingleChildScrollView(
          child: SafeArea(
            child: RepaintBoundary(
              key: _globalKey,
              child: Column(
                children: [
                  _header,
                  gapHeight(sp24),
                  DividerCustom(),
                  gapHeight(sp24),
                  _body,
                  gapHeight(sp24),
                  _payment,
                  gapHeight(sp24),
                  _bottom,
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          await Printing.layoutPdf(
            format: PdfPageFormat.roll57,
            onLayout: (_) => genPdf(),
          );
        },
        child: const CircleAvatar(
          radius: sp24,
          child: Icon(
            Icons.print_rounded,
          ),
        ),
      ),
    );
  }

  Future<Uint8List> genPdf() async {
    final pdf = pw.Document();
    final boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(16),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Image(
              pw.MemoryImage(pngBytes),
            ),
          ); // Center
        },
      ),
    ); //
    return pdf.save();
  }

  Widget get _header {
    return Column(
      children: [
        Text(
          _company?.name ?? '',
          style: h6.copyWith(color: blackColor),
        ),
        gapHeight(sp4),
        Text(
          _company?.address?.fullAddress ?? '',
          style: p9.copyWith(color: blackColor),
        ),
        gapHeight(sp4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MST: ${_company?.taxCode ?? ''}',
              style: p9.copyWith(color: blackColor),
            ),
            gapWidth(sp24),
            Text(
              'Hotline: ${_company?.phone}',
              style: p9.copyWith(color: blackColor),
            ),
          ],
        ),
        gapHeight(sp24),
        Text(
          'HÓA ĐƠN THANH TOÁN',
          style: h6.copyWith(color: blackColor),
        ),
        gapHeight(sp24),
        Row(
          children: [
            const Expanded(
              flex: 2,
              child: Text('Mã ĐH:', style: p9),
            ),
            Expanded(
              flex: 3,
              child: Text(_order.code ?? '', style: p7),
            ),
            Expanded(
              flex: 5,
              child: Text(
                _order.createdAt.fomatCustom(fomat: 'hh:mm ∙ dd/M/y'),
                style: p7,
              ),
            ),
          ],
        ),
        gapHeight(sp4),
        Row(
          children: [
            const Expanded(
              flex: 2,
              child: Text('Tên KH:', style: p9),
            ),
            Expanded(
              flex: 3,
              child: Text(_customer?.prefixName ?? '', style: p7),
            ),
            Expanded(
              flex: 5,
              child: Text('SĐT: ${_customer?.phone ?? '-'}', style: p7),
            ),
          ],
        ),
        gapHeight(sp4),
        const Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('Thu ngân:', style: p9),
            ),
            Expanded(
              flex: 3,
              child: Text('Chưa có thông tin', style: p7),
            ),
            Expanded(
              flex: 5,
              child: Text('SĐT: Chưa có thông tin', style: p7),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _body {
    return Column(
      children: [
        _itemBill(),
        _divider,
        Visibility(
          visible: _order.type == 'service',
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: sp8, vertical: sp4),
            margin: const EdgeInsets.symmetric(vertical: sp8),
            color: blackColor,
            child: Text(
              'DANH SÁCH DỊCH VỤ',
              style: p7.copyWith(color: whiteColor),
            ),
          ),
        ),
        Visibility(
          visible: _order.type == 'service',
          child: _services,
        ),
        Visibility(
          visible: _order.type == 'service' && _items.isNotEmpty,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: sp8, vertical: sp4),
            margin: const EdgeInsets.symmetric(vertical: sp8),
            color: blackColor,
            child: Text(
              'DANH SÁCH SẢN PHẨM',
              style: p7.copyWith(color: whiteColor),
            ),
          ),
        ),
        _products,
      ],
    );
  }

  Widget get _products {
    return ListView.separated(
      padding: const EdgeInsets.all(sp0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${index + 1}',
                  style: h6,
                ),
              ),
              Expanded(
                flex: 12,
                child: Text(
                  _items[index].productData?.name ?? '',
                  style: p7,
                ),
              ),
            ],
          ),
          gapHeight(sp12),
          _itemBill(
            quantity: _items[index].quantity,
            unit: _items[index].unitData?.name,
            price: _items[index].price,
            discount: _items[index].discountPrice,
            total: _items[index].quantity.validator *
                _items[index].price.validator,
          ),
        ],
      ),
      separatorBuilder: (context, index) => _divider,
      itemCount: _items.length,
    );
  }

  Widget get _services {
    return ListView.separated(
      padding: const EdgeInsets.all(sp0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${index + 1}',
                  style: h6,
                ),
              ),
              Expanded(
                flex: 12,
                child: Text(
                  _servicesItem[index].service?.title ?? '',
                  style: p7,
                ),
              ),
            ],
          ),
          gapHeight(sp12),
          _itemBill(
            quantity: _servicesItem[index].quantity,
            unit: _servicesItem[index].service?.price?.priceNameSub,
            price: _servicesItem[index].price,
            discount: _servicesItem[index].discountPrice,
            total: _servicesItem[index].quantity.validator *
                (_servicesItem[index].price.validator -
                    _servicesItem[index].discountPrice.validator),
          ),
        ],
      ),
      separatorBuilder: (context, index) => _divider,
      itemCount: _servicesItem.length,
    );
  }

  Widget get _payment {
    return Column(
      children: [
        RowItem(
          title: 'Tổng tiền hàng',
          content: '${FormatCurrency(_totalPriceProd)} đ',
        ),
        gapHeight(sp4),
        RowItem(
          title: 'Chiết khấu',
          content: '${FormatCurrency(_totalDiscount)} đ',
        ),
        gapHeight(sp4),
        Visibility(
          visible: _order.redInvoice,
          child: Column(
            children: [
              Column(
                children: _items
                    .map(
                      (e) => Visibility(
                        visible: (e.productData?.vat ?? 0) > 0,
                        child: Container(
                          margin: const EdgeInsets.only(top: sp4),
                          child: RowItem(
                            title:
                                'VAT ${e.productData?.vat}% của (${FormatCurrency(e.priceItem)} đ)',
                            content: '${FormatCurrency(e.vatProd)} đ',
                            titleStyle: p9,
                            contetnStyle: p9,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              Column(
                children: _servicesItem
                    .map(
                      (e) => Visibility(
                        visible: (e.service?.vat ?? 0) > 0,
                        child: Container(
                          margin: const EdgeInsets.only(top: sp4),
                          child: RowItem(
                            title:
                                'VAT ${e.service?.vat}% của (${FormatCurrency(e.totalPrice)} đ)',
                            content: '${FormatCurrency(e.vat)} đ',
                            titleStyle: p9,
                            contetnStyle: p9,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const Divider(height: sp24),
        RowItem(
          title: 'Tổng thanh toán',
          content: '${FormatCurrency(_order.totalPrice)} đ',
        ),
        gapHeight(sp32),
        const Text(
          'Quét mã để thanh toán',
          style: p6,
        ),
        if (_order.qr != null)
          Image.network(
            _order.qr!,
            width: widthDevice(context) / 2,
          ),
      ],
    );
  }

  Widget get _bottom {
    return Column(
      children: [
        const Text('Lưu ý', style: p5),
        const Text(
          'Quý khách vui lòng kiểm tra hàng và giữ phiếu này để làm căn cứ cho giao dịch sau.',
          style: p6,
        ),
        gapHeight(sp16),
        const Text(
          'Cảm ơn - Hẹn gặp lại quý khách!',
          style: p5,
        ),
      ],
    );
  }

  Widget _itemBill({
    int? quantity,
    String? unit,
    num? price,
    num? discount,
    num? total,
  }) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            '',
          ),
        ),
        Expanded(
          child: Text(
            '${quantity ?? 'SL'}',
            style: quantity != null ? p7 : p9,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            unit ?? 'ĐVT',
            style: unit != null ? p7 : p9,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            price != null ? FormatCurrency(price) : 'Đơn giá',
            style: price != null ? p7 : p9,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            discount != null ? FormatCurrency(discount) : 'Chiết khấu',
            style: discount != null ? p7 : p9,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            total != null ? FormatCurrency(total) : 'Thành tiền',
            style: total != null ? p7 : p9,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget get _divider {
    return Row(
      children: List.generate(
        150 ~/ 2,
        (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: sp12),
            color: index % 2 == 0 ? Colors.transparent : greyColor,
            height: 1,
          ),
        ),
      ),
    );
  }

  OrderDetailV2Model get _order => widget.order;
  CompanyModel? get _company => _order.company;
  Customer? get _customer => _order.customer;
  List<OrderItemV2> get _items => _order.items;
  List<OrderServiceItemV2> get _servicesItem => _order.services;

  num get _totalPriceProd {
    final totalProd = _items.fold<num>(0, (total, e) {
      total += e.priceItem;
      return total;
    });
    final totalServices = _servicesItem.fold<num>(0, (total, e) {
      total += e.totalPrice;
      return total;
    });
    return totalProd + totalServices;
  }

  num get _totalDiscount {
    final disProd = _items.fold<num>(0, (total, e) {
      total += e.discountPrice.validator * e.quantity;
      return total;
    });

    final disServices = _servicesItem.fold<num>(0, (total, e) {
      total += e.totalDiscount;
      return total;
    });

    return disProd + disServices;
  }

  Future<void> _shareImageBill() async {
    final boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    // Lấy thư mục tạm thời để lưu tệp tin hình ảnh
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/bill.png';

    final xfile = await File(filePath).writeAsBytes(pngBytes);
    Share.shareXFiles([XFile(xfile.path)]);
  }
}
