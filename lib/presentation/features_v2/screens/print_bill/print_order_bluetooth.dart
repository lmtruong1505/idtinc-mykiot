import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/features_v2/models/order/order_detail_v2_model.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../constants/spacing.dart';
import '../../../features/company/data/models/company_model.dart';

@RoutePage()
class PrintOrderBluetoothPage extends StatefulWidget {
  final OrderDetailV2Model order;
  const PrintOrderBluetoothPage({super.key, required this.order});

  @override
  State<PrintOrderBluetoothPage> createState() =>
      _PrintOrderBluetoothPageState();
}

class _PrintOrderBluetoothPageState extends State<PrintOrderBluetoothPage> {
  OrderDetailV2Model get _order => widget.order;
  CompanyModel? get _company => _order.company;
  Customer? get _customer => _order.customer;
  List<OrderItemV2> get _items => _order.items;
  List<OrderServiceItemV2> get _servicesItem => _order.services;

  // ReceiptController? controller;

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
          // await Printing.layoutPdf(
          //   name: 'GomDon',
          //   onLayout: (_) => _buildPdf(),
          // );
        },
        backgroundColor: AppColors.brand,
        child: const Icon(
          Icons.print,
          color: Colors.white,
        ),
      ),
      // body: Receipt(
      //   builder: (context) {
      //     return _buildPdf();
      //   },
      //   onInitialized: (controller) {
      //     this.controller = controller;
      //   },
      // )

      //  PdfPreview(
      //   build: (format) => _buildPdf(),
      //   allowPrinting: false,
      //   allowSharing: false,
      //   canChangeOrientation: false,
      //   canChangePageFormat: false,
      //   pdfPreviewPageDecoration: BoxDecoration(
      //     color: Colors.white,
      //     boxShadow: AppShadows.elevator0,
      //   ),
      //   scrollViewDecoration: const BoxDecoration(
      //     color: Colors.white,
      //   ),
      // ),
    );
  }

  Widget _buildPdf() {
    // final font =
    //     await fontFromAssetBundle('assets/fonts/Roboto/Roboto-Bold.ttf');
    // final fontNormal =
    //     await fontFromAssetBundle('assets/fonts/Roboto/Roboto-Regular.ttf');

    final TextStyle titleStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      // font: font,
      color: blackColor,
    );
    final TextStyle normalStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      // font: fontNormal,
      color: blackColor,
    );
    final TextStyle boldStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      // font: font,
      color: blackColor,
    );

    TextStyle emptyTextStyle(String? text) =>
        text.isEmptyOrNull ? normalStyle : boldStyle;

    Widget tabelInfo({
      required String text1,
      required String type,
      String? text2,
      String? text3,
    }) =>
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                text1,
                style: normalStyle,
              ),
            ),
            gap(width: 6),
            Expanded(
              flex: 3,
              child: Text(
                text2 ?? ' --- ',
                style: emptyTextStyle(text2),
              ),
            ),
            gap(width: 6),
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Text(
                    type,
                    style: normalStyle,
                  ),
                  Expanded(
                    child: Text(
                      text3 ?? ' --- ',
                      style: emptyTextStyle(text3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

    Widget header() => Column(
          children: [
            Text(
              _company?.name ?? '',
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            gap(height: sp4),
            Text(
              _company?.address?.fullAddress ?? '',
              textAlign: TextAlign.center,
              style: normalStyle,
            ),
            gap(height: sp4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MST: ${_company?.taxCode ?? "---"}',
                  style: normalStyle,
                ),
                gap(width: sp24),
                Text(
                  'Hotline: ${_company?.phone ?? '---'}',
                  style: normalStyle,
                ),
              ],
            ),
            gap(height: sp24),
            Text(
              'HÓA ĐƠN THANH TOÁN',
              textAlign: TextAlign.center,
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
    Row tabelRow({
      String? index,
      int? count,
      String? unit,
      String? price,
      String? discount,
      String? pricePay,
    }) =>
        Row(
          children: [
            Expanded(
              child: Text(
                index ?? '#',
              ),
            ),
            gap(width: 4),
            Expanded(
              child: Text(
                '${count ?? 'SL'}',
                style: count != null ? boldStyle : normalStyle,
              ),
            ),
            gap(width: 4),
            Expanded(
              flex: 2,
              child: Text(
                unit ?? 'ĐVT',
                style: unit != null ? boldStyle : normalStyle,
                textAlign: TextAlign.center,
              ),
            ),
            gap(width: 4),
            Expanded(
              flex: 3,
              child: Text(
                price ?? 'Đơn giá',
                style: emptyTextStyle(price),
                textAlign: TextAlign.center,
              ),
            ),
            gap(width: 4),
            Expanded(
              flex: 3,
              child: Text(
                discount ?? 'Chiết khấu',
                style: emptyTextStyle(discount),
                textAlign: TextAlign.center,
              ),
            ),
            gap(width: 4),
            Expanded(
              flex: 3,
              child: Text(
                pricePay ?? 'Thành tiền',
                style: emptyTextStyle(pricePay),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        );

    Padding itemData({
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

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '${index + 1}',
                    style: boldStyle,
                  ),
                ),
                gap(width: 4),
                Expanded(
                  flex: 12,
                  child: Text(
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

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        tabelRow(),
        gap(height: 12),
        if (_servicesItem.isNotEmpty) ...[
          Container(
            color: blackColor,
            padding: const EdgeInsets.all(8),
            child: Text(
              'Danh sách dịch vụ'.toUpperCase(),
              style: titleStyle.copyWith(
                color: whiteColor,
              ),
            ),
          ),
          ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: _servicesItem.length,
            separatorBuilder: (context, index) => divider,
            itemBuilder: (context, index) => itemData(
              index: index,
              service: _servicesItem[index],
            ),
          ),
        ],
        if (_items.isNotEmpty) ...[
          Container(
            color: blackColor,
            padding: const EdgeInsets.all(8),
            child: Text(
              'Danh sách sản phẩm'.toUpperCase(),
              style: titleStyle.copyWith(
                color: whiteColor,
              ),
            ),
          ),
          ListView.separated(
            padding: EdgeInsets.zero,
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
    Row rowText({
      required String title,
      required String content,
    }) =>
        Row(
          children: [
            Text(
              title,
              style: normalStyle,
            ),
            gap(width: 12),
            Expanded(
              child: Text(
                content,
                textAlign: TextAlign.right,
                style: normalStyle,
              ),
            ),
          ],
        );

    final buildVat = Column(
      children: [
        ...List.generate(
          _items.length,
          (index) {
            if ((_items[index].productData?.vat ?? 0) > 0) {
              return gap();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
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

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
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

    final payment = Column(
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
        Row(
          children: [
            Text(
              'Tổng thanh toán',
              style: normalStyle,
            ),
            gap(width: 12),
            Expanded(
              child: Text(
                _order.totalPrice.formatPrice(type: ' đ'),
                textAlign: TextAlign.right,
                style: titleStyle,
              ),
            ),
          ],
        ),
      ],
    );
    // final page = Page(
    //   margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    //   build: (context) {

    //   },
    // );
    // doc.addPage(
    //   page,
    // );
    // return doc.save();

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          header(),
          body,
          gap(height: 24),
          payment,
          gap(height: 24),
          const Text(
            'Lưu ý',
            textAlign: TextAlign.center,
            // style: boldStyle,
          ),
          gap(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Quý khách vui lòng kiểm tra hàng và giữ phiếu này để làm căn cứ cho giao dịch sau.',
              textAlign: TextAlign.center,
              // style: normalStyle,
            ),
          ),
          gap(height: 24),
          const Text(
            'Cảm ơn - Hẹn gặp lại quý khách!',
            textAlign: TextAlign.center,
            // style: boldStyle,
          ),
        ],
      ),
    );
  }

  final blackColor = AppColors.bg_black;
  final whiteColor = AppColors.white;
  final greyColor = AppColors.grey60;

  Divider get divider => Divider(
        thickness: 1,
        height: 0,
        color: greyColor,
      );

  SizedBox gap({
    double? height,
    double? width,
  }) =>
      SizedBox(width: width, height: height);
}
