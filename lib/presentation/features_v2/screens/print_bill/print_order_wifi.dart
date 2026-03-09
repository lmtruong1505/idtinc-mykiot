import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/features_v2/models/order/order_detail_v2_model.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../constants/spacing.dart';
import '../../../features/company/data/models/company_model.dart';

@RoutePage()
class PrintOrderWifiPage extends StatefulWidget {
  final OrderDetailV2Model order;
  const PrintOrderWifiPage({super.key, required this.order});

  @override
  State<PrintOrderWifiPage> createState() => _PrintOrderWifiPageState();
}

class _PrintOrderWifiPageState extends State<PrintOrderWifiPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTitleCenter(title: 'In hoá đơn'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Printing.layoutPdf(
            name: 'GomDon',
            onLayout: (_) => _buildPdf(),
          );
        },
        backgroundColor: AppColors.brand,
        child: const Icon(
          Icons.print,
          color: Colors.white,
        ),
      ),
      body: PdfPreview(
        build: (format) => _buildPdf(),
        allowPrinting: false,
        allowSharing: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        pdfPreviewPageDecoration: BoxDecoration(
          color: Colors.white,
          boxShadow: AppShadows.elevator0,
        ),
        scrollViewDecoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }

  Future<Uint8List> _buildPdf() async {
    final doc = pw.Document();
    final font =
        await fontFromAssetBundle('assets/fonts/Roboto/Roboto-Bold.ttf');
    final fontNormal =
        await fontFromAssetBundle('assets/fonts/Roboto/Roboto-Regular.ttf');

    final pw.TextStyle titleStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      font: font,
      color: blackColor,
    );
    final pw.TextStyle normalStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.normal,
      font: fontNormal,
      color: blackColor,
    );
    final pw.TextStyle boldStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      font: font,
      color: blackColor,
    );

    pw.TextStyle emptyTextStyle(String? text) =>
        text.isEmptyOrNull ? normalStyle : boldStyle;

    pw.Widget tabelInfo({
      required String text1,
      required String type,
      String? text2,
      String? text3,
    }) =>
        pw.Row(
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                text1,
                style: normalStyle,
              ),
            ),
            gap(width: 6),
            pw.Expanded(
              flex: 3,
              child: pw.Text(
                text2 ?? ' --- ',
                style: emptyTextStyle(text2),
              ),
            ),
            gap(width: 6),
            pw.Expanded(
              flex: 5,
              child: pw.Row(
                children: [
                  pw.Text(
                    type,
                    style: normalStyle,
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      text3 ?? ' --- ',
                      style: emptyTextStyle(text3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

    final header = pw.Column(
      children: [
        pw.Text(
          _company?.name ?? '',
          style: titleStyle,
          textAlign: pw.TextAlign.center,
        ),
        gap(height: sp4),
        pw.Text(
          _company?.address?.fullAddress ?? '',
          textAlign: pw.TextAlign.center,
          style: normalStyle,
        ),
        gap(height: sp4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              'MST: ${_company?.taxCode ?? "---"}',
              style: normalStyle,
            ),
            gap(width: sp24),
            pw.Text(
              'Hotline: ${_company?.phone ?? '---'}',
              style: normalStyle,
            ),
          ],
        ),
        gap(height: sp24),
        pw.Text(
          'HÓA ĐƠN THANH TOÁN',
          textAlign: pw.TextAlign.center,
          style: titleStyle,
        ),
        gap(height: sp24),
        tabelInfo(
          text1: 'Mã ĐH:',
          type: '',
          text2: _order.code,
          text3: _order.createdAt.fomatCustom(fomat: 'hh:mm - dd/M/y'),
        ),
        gap(height: 4),
        tabelInfo(
          text1: 'Tên KH:',
          type: 'SĐT: ',
          text2: _customer?.prefixName,
          text3: _customer?.phone,
        ),
        gap(height: 4),
        tabelInfo(
          text1: 'Thu ngân:',
          type: 'SĐT: ',
        ),
        gap(height: 24),
        divider,
        gap(height: 24),
      ],
    );
    pw.Row tabelRow({
      String? index,
      int? count,
      String? unit,
      String? price,
      String? discount,
      String? pricePay,
    }) =>
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(
                index ?? '#',
              ),
            ),
            gap(width: 4),
            pw.Expanded(
              child: pw.Text(
                '${count ?? 'SL'}',
                style: count != null ? boldStyle : normalStyle,
              ),
            ),
            gap(width: 4),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                unit ?? 'ĐVT',
                style: unit != null ? boldStyle : normalStyle,
                textAlign: pw.TextAlign.center,
              ),
            ),
            gap(width: 4),
            pw.Expanded(
              flex: 3,
              child: pw.Text(
                price ?? 'Đơn giá',
                style: emptyTextStyle(price),
                textAlign: pw.TextAlign.center,
              ),
            ),
            gap(width: 4),
            pw.Expanded(
              flex: 3,
              child: pw.Text(
                discount ?? 'Chiết khấu',
                style: emptyTextStyle(discount),
                textAlign: pw.TextAlign.center,
              ),
            ),
            gap(width: 4),
            pw.Expanded(
              flex: 3,
              child: pw.Text(
                pricePay ?? 'Thành tiền',
                style: emptyTextStyle(pricePay),
                textAlign: pw.TextAlign.right,
              ),
            ),
          ],
        );

    pw.Padding itemData({
      required int index,
      OrderServiceItemV2? service,
      OrderItemV2? item,
    }) {
      //Service
      final pricePayService = service == null
          ? 0
          : service.quantity.validator *
              (service.price.validator - service.discountPrice.validator);
      final discountService = service == null ? 0 : service.discountPrice;

      //item
      final pricePayItem =
          item == null ? 0 : item.quantity.validator * item.price;
      final discountItem = item == null ? 0 : item.discountPrice;

      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 16),
        child: pw.Column(
          children: [
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Text(
                    '${index + 1}',
                    style: boldStyle,
                  ),
                ),
                gap(width: 4),
                pw.Expanded(
                  flex: 12,
                  child: pw.Text(
                    service?.service?.title ?? item?.productData?.name ?? '',
                    style: boldStyle,
                  ),
                ),
              ],
            ),
            gap(height: 16),
            if (service != null)
              tabelRow(
                index: '',
                unit: service.service?.price?.priceNameSub ?? '',
                count: service.quantity,
                discount:
                    discountService.validator > 0 ? '-$discountService' : '0',
                price: service.price.formatPrice(),
                pricePay: pricePayService.formatPrice(),
              ),
            if (item != null)
              tabelRow(
                index: '',
                unit: item.unitData?.name ?? '',
                count: item.quantity,
                discount: discountItem.validator > 0 ? '-$discountItem' : '0',
                price: item.price.formatPrice(),
                pricePay: pricePayItem.formatPrice(),
              ),
          ],
        ),
      );
    }

    final body = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        tabelRow(),
        gap(height: 12),
        if (_servicesItem.isNotEmpty) ...[
          pw.Container(
            color: blackColor,
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              'Danh sách dịch vụ'.toUpperCase(),
              style: titleStyle.copyWith(
                color: whiteColor,
              ),
            ),
          ),
          pw.ListView.separated(
            padding: pw.EdgeInsets.zero,
            itemCount: _servicesItem.length,
            separatorBuilder: (context, index) => divider,
            itemBuilder: (context, index) => itemData(
              index: index,
              service: _servicesItem[index],
            ),
          ),
        ],
        if (_items.isNotEmpty) ...[
          pw.Container(
            color: blackColor,
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              'Danh sách sản phẩm'.toUpperCase(),
              style: titleStyle.copyWith(
                color: whiteColor,
              ),
            ),
          ),
          pw.ListView.separated(
            padding: pw.EdgeInsets.zero,
            itemCount: _items.length,
            separatorBuilder: (context, index) => divider,
            itemBuilder: (context, index) => itemData(
              index: index,
              item: _items[index],
            ),
          ),
        ],
      ],
    );
    pw.Row rowText({
      required String title,
      required String content,
    }) =>
        pw.Row(
          children: [
            pw.Text(
              title,
              style: normalStyle,
            ),
            gap(width: 12),
            pw.Expanded(
              child: pw.Text(
                content,
                textAlign: pw.TextAlign.right,
                style: normalStyle,
              ),
            ),
          ],
        );

    final buildVat = pw.Column(
      children: [
        ...List.generate(
          _items.length,
          (index) {
            if ((_items[index].productData?.vat ?? 0) > 0) {
              return gap();
            }
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 6),
              child: rowText(
                title:
                    'VAT ${_items[index].productData?.vat}% của (${_items[index].priceItem.formatPrice(type: ' đ')})',
                content: _items[index].vatProd.formatPrice(type: ' đ'),
              ),
            );
          },
        ),
        ...List.generate(
          _servicesItem.length,
          (index) {
            final service = _servicesItem[index].service;
            if ((service?.vat ?? 0) > 0) {
              return gap();
            }

            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 6),
              child: rowText(
                title:
                    'VAT ${service?.vat ?? 0}% của (${_servicesItem[index].totalPrice.formatPrice(type: ' đ')})',
                content: _servicesItem[index].vat.formatPrice(type: ' đ'),
              ),
            );
          },
        ),
      ],
    );

    final payment = pw.Column(
      children: [
        rowText(
          title: 'Tổng tiền hàng',
          content: _totalPriceProd.formatPrice(type: ' đ'),
        ),
        gap(height: 6),
        rowText(
          title: 'Chiết khấu',
          content: _totalDiscount.formatPrice(type: ' đ'),
        ),
        gap(height: 6),
        if (_order.redInvoice) buildVat,
        divider,
        gap(height: 16),
        pw.Row(
          children: [
            pw.Text(
              'Tổng thanh toán',
              style: normalStyle,
            ),
            gap(width: 12),
            pw.Expanded(
              child: pw.Text(
                _order.totalPrice.formatPrice(type: ' đ'),
                textAlign: pw.TextAlign.right,
                style: titleStyle,
              ),
            ),
          ],
        ),
      ],
    );
    final page = pw.Page(
      margin: const pw.EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      build: (context) {
        return pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Column(
            children: [
              header,
              body,
              gap(height: 24),
              payment,
              gap(height: 24),
              pw.Text(
                'Lưu ý',
                textAlign: pw.TextAlign.center,
                style: boldStyle,
              ),
              gap(height: 12),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child: pw.Text(
                  'Quý khách vui lòng kiểm tra hàng và giữ phiếu này để làm căn cứ cho giao dịch sau.',
                  textAlign: pw.TextAlign.center,
                  style: normalStyle,
                ),
              ),
              gap(height: 24),
              pw.Text(
                'Cảm ơn - Hẹn gặp lại quý khách!',
                textAlign: pw.TextAlign.center,
                style: boldStyle,
              ),
            ],
          ),
        );
      },
    );
    doc.addPage(
      page,
    );
    return doc.save();
  }

  final blackColor = PdfColor.fromHex('3A3A3E');
  final whiteColor = PdfColor.fromHex('FFFFFF');
  final greyColor = PdfColor.fromHex('AFAFB5');

  pw.Divider get divider => pw.Divider(
        thickness: 1,
        height: 0,
        color: greyColor,
      );

  pw.SizedBox gap({
    double? height,
    double? width,
  }) =>
      pw.SizedBox(width: width, height: height);
}
