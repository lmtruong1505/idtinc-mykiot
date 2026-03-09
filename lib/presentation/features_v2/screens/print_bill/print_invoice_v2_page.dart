import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/features/company/data/models/company_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/print_invoice/print_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/order/order_detail_v2_model.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:qr_flutter/qr_flutter.dart';

@RoutePage()
class PrintInvoiceV2Screen extends StatefulWidget {
  const PrintInvoiceV2Screen({super.key, required this.order});
  final OrderDetailV2Model order;
  @override
  State<PrintInvoiceV2Screen> createState() => _PrintInvoiceV2ScreenState();
}

class _PrintInvoiceV2ScreenState extends State<PrintInvoiceV2Screen> {
  OrderDetailV2Model? get order => widget.order;
  CompanyModel? get company => widget.order.company;
  Customer? get customer => widget.order.customer;
  List<OrderItemV2>? get items => widget.order.items;
  List<OrderServiceItemV2>? get services => widget.order.services;

  num get totalPriceProd =>
      (items?.isEmpty == true
          ? 0
          : items!.fold<num>(0, (t, e) => t + e.priceItem)) +
      (services?.isEmpty == true
          ? 0
          : services!.fold<num>(0, (t, e) => t + e.totalPrice));
  num get totalDiscount => items?.isEmpty == true
      ? 0
      : items!.fold<num>(
            0,
            (t, e) => t + e.discountPrice.validator * e.quantity,
          ) +
          (services?.isEmpty == true
              ? 0
              : services!.fold<num>(0, (t, e) => t + e.totalDiscount));
  final bloc = PrintBloc();

  @override
  void initState() {
    super.initState();
    bloc.checkBluetoothStatus();
  }

  @override
  void dispose() {
    bloc.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<PrintBloc, CubitState>(
        builder: (context, state) {
          return _body(context);
        },
        listener: _listener,
      ),
    );
  }

  Scaffold _body(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: BaseAppBar(
        title: 'In Hoá Đơn Bluetooth',
        actions: [
          IconButton(
            icon: const Icon(
              Icons.print,
              color: AppColors.black,
            ),
            onPressed: () async {
              final result =
                  await context.router.push(SelectPrintRoute(bloc: bloc));
              if (result is Printer) {
                bloc.selectPrinter(result);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _selectSizePaper(),
            _buildInvoice(),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: bloc.printerSelect != null,
        child: Padding(
          padding: 16.pading,
          child: Row(
            children: [
              MainButtonV2(
                icon: const Icon(Icons.print),
                title: 'IN HOÁ ĐƠN',
                onTap: () {
                  bloc.onPrint(widget.order);
                  // bloc.onPrintWidget(context, receiptWidget('aaaaa'));
                },
              ).expanded(),
              16.width,
              MainButtonV2(
                icon: const Icon(Icons.bluetooth_disabled),
                title: 'NGẮT',
                onTap: () => bloc.onDisconnect(),
                backgroundColor: AppColors.red60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoice() {
    TextStyle emptyTextStyle(String? text) =>
        text.isEmptyOrNull ? s18w400 : s18w500;

    Widget header() => Column(
          children: [
            Text(
              company?.name ?? '',
              textAlign: TextAlign.center,
              style: s24w700,
            ),
            4.height,
            Text(
              company?.address?.fullAddress ?? '',
              textAlign: TextAlign.center,
              style: s18w400,
            ),
            4.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MST: ${company?.taxCode ?? "---"}',
                  style: s18w400,
                ),
                24.width,
                Text(
                  'Hotline: ${company?.phone ?? '---'}',
                  style: s18w400,
                ),
              ],
            ),
            24.height,
            const Text(
              'HOÁ ĐƠN THANH TOÁN',
              textAlign: TextAlign.center,
              style: s24w700,
            ),
            24.height,
            _item('Mã ĐH:', title: order?.code),
            _item(
              'Thời gian:',
              title: order?.createdAt.fomatCustom(fomat: 'hh:mm - dd/M/y'),
            ),
            _item('Tên KH:', title: customer?.prefixName),
            _item('SĐT:', title: customer?.phone),
            _item('Thu ngân:'),
            _item('SĐT:'),
            24.height,
            DividerCustom(),
            24.height,
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
            4.width,
            Text(
              '${count ?? 'SL'}',
              style: count != null ? s18w500 : s18w400,
            ).expanded(),
            4.width,
            Text(
              unit ?? 'ĐVT',
              style: unit != null ? s18w500 : s18w400,
            ).expanded(flex: 2),
            4.width,
            Text(
              price ?? 'ĐG',
              style: emptyTextStyle(price),
            ).expanded(flex: 3),
            4.width,
            Text(
              discount ?? 'CK',
              style: emptyTextStyle(discount),
            ).expanded(flex: 3),
            4.width,
            Text(
              pricePay ?? 'Tổng',
              style: emptyTextStyle(pricePay),
            ).expanded(flex: 3),
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
                Text(
                  '${index + 1}',
                  style: s18w500,
                ).expanded(),
                4.width,
                Text(
                  service?.service?.title ?? item?.productData?.name ?? '',
                  style: s18w500,
                ).expanded(flex: 12),
              ],
            ),
            16.height,
            if (service != null)
              tabelRow(
                index: '',
                unit: service.service?.price?.priceNameSub ?? '',
                count: service.quantity,
                discount: discountService.validator > 0
                    ? '-${discountService.formatPrice()}'
                    : '0',
                price: service.price.formatPrice(),
                pricePay: pricePayService.formatPrice(),
              ),
            if (item != null)
              tabelRow(
                index: '',
                unit: item.unitData?.name ?? '',
                count: item.quantity,
                discount: discountItem.validator > 0
                    ? '-${discountItem.formatPrice()}'
                    : '0',
                price: item.priceItem.formatPrice(),
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
        12.height,
        if (services?.isNotEmpty == true) ...[
          Text('DANH SÁCH DỊCH VỤ'.toUpperCase(), style: s24w700),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: services?.length ?? 0,
            separatorBuilder: (context, index) => DividerCustom(),
            itemBuilder: (context, index) => itemData(
              index: index,
              service: services?[index],
            ),
          ),
        ],
        if (items?.isNotEmpty == true) ...[
          Text('DANH SÁCH SẢN PHẨM'.toUpperCase(), style: s24w700),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: items?.length ?? 0,
            separatorBuilder: (context, index) => DividerCustom(),
            itemBuilder: (context, index) => itemData(
              index: index,
              item: items?[index],
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
              style: s18w400,
            ),
            12.width,
            Text(
              content,
              style: s18w400,
            ).expanded(),
          ],
        );

    final buildVat = Column(
      children: [
        if (items?.isNotEmpty == true)
          ...List.generate(
            items!.length,
            (index) {
              if ((items![index].productData?.vat ?? 0) <= 0) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: rowText(
                  title:
                      'VAT ${items![index].productData?.vat}% của (${items![index].priceItem.formatPrice(type: ' đ')})',
                  content: items![index].vatProd.formatPrice(type: ' d'),
                ),
              );
            },
          ),
        if (services?.isNotEmpty == true)
          ...List.generate(
            services!.length,
            (index) {
              final service = services![index].service;
              if ((service?.vat ?? 0) <= 0) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: rowText(
                  title:
                      'VAT ${service?.vat ?? 0}% của (${services![index].totalPrice.formatPrice(type: ' đ')})',
                  content: services![index].vat.formatPrice(type: ' d'),
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
          content: totalPriceProd.formatPrice(type: ' d'),
        ),
        6.height,
        rowText(
          title: 'Chiếu khấu',
          content: totalDiscount.formatPrice(type: ' d'),
        ),
        6.height,
        if (order?.redInvoice == true) buildVat,
        DividerCustom(),
        16.height,
        Row(
          children: [
            const Text(
              'Tổng thanh toán',
              style: s18w400,
            ),
            12.width,
            Text(
              (order?.totalPrice).formatPrice(type: ' d'),
              style: s24w700,
            ).expanded(),
          ],
        ),
        Image.network(
          order?.qr ?? '',
          width: widthDevice(context) / 2,
        ),
      ],
    );

    return Container(
      padding: 16.pading,
      alignment: Alignment.center,
      child: Column(
        children: [
          header(),
          body,
          24.height,
          payment,
          12.height,
          const Text('Lưu ý', textAlign: TextAlign.center, style: s16w500),
          8.height,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Quý khách vui lòng kiểm tra hàng \n và giữ phiếu này để làm căn cứ \n cho giao dịch sau.',
              textAlign: TextAlign.center,
            ),
          ),
          24.height,
          const Text(
            'Cảm ơn - Hẹn gặp lại quý khách!',
            textAlign: TextAlign.center,
            style: s18w500,
          ),
        ],
      ),
    );
  }

  RowItem _item(String name, {String? title}) {
    return RowItem(
      title: name,
      content: title ?? '---',
      titleStyle: s18w400.copyWith(color: AppColors.text_primary),
      contetnStyle: s18w700,
    );
  }

  void _listener(BuildContext context, CubitState state) {
    if (state.status == BlocStatus.error) {
      DialogUtils.showErrorDialog(
        context,
        content: state.msg,
        accept: () => context.pop(),
        close: () => context.pop(),
      );
    } else if (state.status == BlocStatus.submitSuccess) {
      context.pop();
      DialogUtils.showSuccessDialog(
        context,
        content: state.msg,
        accept: () => context.pop(),
        close: () => context.pop(),
        isClose: false,
      );
    } else if (state.status == BlocStatus.submitFailure) {
      context.pop();
      DialogUtils.showErrorDialog(
        context,
        content: state.msg,
        accept: () => context.pop(),
        close: () => context.pop(),
        isClose: false,
      );
    } else if (state.status == BlocStatus.submit) {
      DialogUtils.showLoadingDialog(context, state.msg);
    }
    // else if (state.status == BlocStatus.success) {
    //   DialogUtils.showLoadingDialog(context, state.msg);
    // }
  }

  Widget _selectSizePaper() {
    return BlocBuilder<PrintBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn khổ giấy',
              style: s14w600,
            ),
            8.height,
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final size = bloc.listPageSize[index];
                  return MainButtonV2(
                    backgroundColor: size == bloc.paperSize
                        ? AppColors.brand
                        : AppColors.ultility_gray_20,
                    onTap: () => bloc.selectSize(size),
                    title: bloc.listPageSize[index].name,
                  );
                },
                separatorBuilder: (context, index) => 8.width,
                itemCount: bloc.listPageSize.length,
              ),
            ),
          ],
        );
      },
    ).padding(16.pading);
  }
}

Widget receiptWidget(String printerType) {
  return SizedBox(
    // width: 40,
    // height: 100,
    child: Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'FLUTTER THERMAL PRINTER',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 10),
            _buildReceiptRow('Item', 'Price'),
            const Divider(),
            _buildReceiptRow('Apple', '\$1.00'),
            _buildReceiptRow('Banana', '\$0.50'),
            _buildReceiptRow('Orange', '\$0.75'),
            const Divider(thickness: 2),
            _buildReceiptRow('Total', '\$2.25', isBold: true),
            const SizedBox(height: 20),
            _buildReceiptRow('Printer Type', printerType),
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'Thank you for your purchase!',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildReceiptRow(String leftText, String rightText,
    {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          rightText,
          style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    ),
  );
}
