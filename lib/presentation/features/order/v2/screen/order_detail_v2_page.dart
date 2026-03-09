import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/features/order/cubit/order_create_cubit/order_create_state.dart';
import 'package:pharmago/presentation/features/order/cubit/order_list_cubit/order_list_cubit.dart';
import 'package:pharmago/presentation/features/order/domain/entities/payment_v2_entity.dart';
import 'package:pharmago/presentation/features/order/v2/widget/collect_payment_order.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../shared/style_app/color_app.dart';
import '../../../../../shared/style_app/style_text.dart';
import '../../../../base/button.dart';
import '../../../../constants/asset_path.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../../../shared/utils/event.dart';
import '../../cubit/order_detail_cubit/order_detail_cubit.dart';
import '../../cubit/order_detail_cubit/order_detail_state.dart';
import '../widget/card_product_confirm.dart';

@RoutePage()
class OrderDetailV2Page extends StatefulWidget {
  const OrderDetailV2Page({super.key, required this.id});

  final int id;

  @override
  State<OrderDetailV2Page> createState() => _OrderDetailV2PageState();
}

class _OrderDetailV2PageState extends State<OrderDetailV2Page> {
  final myBloc = getIt.get<OrderDetailCubit>();

  final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..getDetail(widget.id),
      child: BlocBuilder<OrderDetailCubit, OrderDetailState>(
        builder: (context, state) {
          return Scaffold(
            appBar: BaseAppBar(
              title: 'Chi tiết đơn bán hàng',
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: blackColor,
                ),
                onPressed: () {
                  getIt<OrderListCubit>().infiniteListController.onRefresh();
                  context.router.maybePop();
                },
              ),
            ),
            body: state.isLoading ? const BaseLoading() : _buildBody(state),
            bottomNavigationBar: state.order?.totalPaid.validator ==
                    state.order?.totalPrice.validator
                ? null
                : _buildBottom(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(OrderDetailState state) {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        color: borderColor_1,
      ),
      padding: 16.padingHor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            16.height,
            _buildQr(state),
            16.height,
            // _buildElectronicInvoice(state),
            // 16.height,
            _buildMachineInvoice(state),
            16.height,
            _buildZaloPay(state),
            RepaintBoundary(
              key: _globalKey,
              child: Column(
                children: [
                  16.height,
                  _buildUserCreated(state),
                  16.height,
                  _buildCustomer(state),
                  16.height,
                  _buildPaymentInfo(state),
                  16.height,
                  _buildRedOrder(state),
                  16.height,
                  _buildNote(state),
                  16.height,
                  _buildItemInOrder(state),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottom(OrderDetailState state) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            blurRadius: sp4,
            offset: const Offset(sp0, -1),
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: whiteColor,
        ),
        padding: 16.pading,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RowItem(
              title: 'Tổng tiền cần thanh toán',
              content: '${myBloc.havePaid.formatCurrency}đ',
            ),
            16.height,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: ExtraButton(
                    title: 'Xóa',
                    event: () {},
                    borderColor: borderColor_2,
                    largeButton: true,
                    icon: null,
                  ),
                ),
                const SizedBox(width: sp16),
                Expanded(
                  flex: 1,
                  child: MainButton(
                    title: 'Thu tiền',
                    event: () {
                      context.bottomSheet(
                        CollectPaymentOrder(
                          context: context,
                          myBloc: myBloc,
                          onPaymentSuccess: () {
                            myBloc.getDetail(widget.id);
                          },
                          amount: myBloc.havePaid,
                        ),
                      );
                    },
                    largeButton: true,
                    icon: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQr(OrderDetailState state) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: 8.radius,
      ),
      padding: 16.pading,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: Padding(
              padding: 4.padingBottom,
              child: Text(
                state.order?.code ?? '',
                style: StyleApp.medium(color: ColorApp.black),
              ),
            ),
            subtitle: Text(
              (state.order?.createdAt ?? DateTime.now())
                  .fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
              style: StyleApp.medium(
                color: ColorApp.grey,
              ),
            ),
            trailing: Text(
              isProdOrder ? 'Đơn hàng sản phẩm' : 'Đơn hàng dịch vụ',
              style: StyleApp.medium(
                color: isProdOrder ? ColorApp.blue20 : ColorApp.yellowD2,
              ),
            ),
          ),
          16.height,
          if(state.order?.qrCode != null && state.order?.qrCode != '')
            BaseCacheImage(
              url: state.order?.qrCode ?? '',
              width: 196,
              height: 196,
            ),
        ],
      ),
    );
  }

  Widget _buildElectronicInvoice(OrderDetailState state) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 34,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: greyFF,
        borderRadius: 8.radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bạn vui lòng hỏi khách có muốn xuấthoá đơn điện tử?',
            style: StyleApp.normal(),
            textAlign: TextAlign.center,
          ),
          16.height,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 1,
                child: ExtraButton(
                  title: 'Xuất sau',
                  event: _developingFeature,
                  borderColor: greyColor,
                  backgroundColor: whiteColor,
                  largeButton: true,
                  icon: null,
                ),
              ),
              const SizedBox(width: sp16),
              Expanded(
                flex: 1,
                child: MainButton(
                  title: 'Xuất ngay',
                  event: _developingFeature,
                  largeButton: true,
                  icon: null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMachineInvoice(OrderDetailState state) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 34,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: greyFF,
        borderRadius: 8.radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Kiểm tra hoá đơn tại máy',
            style: StyleApp.normal(
              color: greyFF2,
            ),
            textAlign: TextAlign.center,
          ),
          16.height,
          Text(
            '[80212]-[ÉPSON TM-181ll Receipt]-[in Bill] - [in ngoai]',
            style: StyleApp.medium(
              color: greyFF2,
            ),
            textAlign: TextAlign.center,
          ),
          16.height,
          ExtraButton(
            title: 'Xuất sau',
            event: () {
              _shareImageBill();
            },
            borderColor: greyColor,
            backgroundColor: whiteColor,
            icon: SvgPicture.asset(
              '${AssetsPath.icon}/ic_printer.svg',
            ),
          ),
        ],
      ),
    );
  }

  _buildZaloPay(OrderDetailState state) {
    return GestureDetector(
      onTap: _sendZalo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            !state.hadSendZalo ? 'Gửi hoá đơn bán lẻ qua Zalo' : 'Đã gửi hoá đơn bán lẻ qua Zalo (Gửi lại)',
            style: StyleApp.bold(color: ColorApp.blue20),
          ),
          8.width,
          SvgPicture.asset(
            '${AssetsPath.icon}/ic_zalo.svg',
            width: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildUserCreated(OrderDetailState state) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: 8.radius,
      ),
      padding: 16.pading,
      child: Column(
        children: [
          RowItem(title: 'Người tạo', content: state.order?.userCreated ?? ''),
          8.height,
          const RowItem(title: 'Vai trò', content: ''),
        ],
      ),
    );
  }

  Widget _buildCustomer(OrderDetailState state) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: 8.radius,
      ),
      padding: 16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Khách hàng',
            style: StyleApp.normal(
              color: ColorApp.grey79,
            ),
          ),
          const SizedBox(height: sp4),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(sp12),
              border: Border.all(color: bg_2),
            ),
            padding: const EdgeInsets.all(sp16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.order?.customer?.name ?? '',
                          style: p5.copyWith(
                            color: blackColor,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${state.order?.customer?.orders ?? 0} đơn - ${FormatCurrency(
                            state.order?.customer?.revenue ?? 0,
                          )}đ',
                          style: p5.copyWith(color: blackColor),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        await _makePhoneCall(
                          phone: state.order?.customer?.phone ?? '',
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: green_2,
                        ),
                        padding: 12.pading,
                        child: const Center(
                          child: Icon(
                            Icons.phone,
                            color: green_1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                ..._phoneAndAddress(
                  state.order?.customer?.phone ?? '',
                  state.order?.customer?.address?.detail ?? '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _phoneAndAddress(String phone, String address) {
    return [
      Row(
        children: [
          const Icon(
            Icons.phone,
            color: green_1,
            size: 16,
          ),
          8.width,
          Text(
            phone,
            style: p5.copyWith(
              color: blackColor,
              fontWeight: DEFAULT,
            ),
          ),
        ],
      ),
      8.height,
      Row(
        children: [
          const Icon(
            Icons.location_on,
            color: green_1,
            size: 16,
          ),
          8.width,
          Expanded(
            child: Text(
              address.isEmpty ? 'Chưa có thông tin' : address,
              style: p5.copyWith(
                color: blackColor,
                fontWeight: DEFAULT,
              ),
              maxLines: 3,
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildPaymentInfo(OrderDetailState state) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: 8.radius,
      ),
      width: double.infinity,
      padding: 16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin thu tiền',
            style: StyleApp.normal(
              color: ColorApp.grey79,
            ),
          ),
          4.height,
          ...List.generate(state.order?.payments.length ?? 0, (index) {
            final item = state.order?.payments[index];
            return _buildItemPayment(
              item!,
              index + 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildItemPayment(PaymentV2Entity item, int index) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp12),
        border: Border.all(color: bg_2),
      ),
      margin: 8.padingBottom,
      padding: const EdgeInsets.all(sp16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lần $index',
            style: StyleApp.medium(
              fontSize: 16,
            ),
          ),
          8.height,
          RowItem2(
            title: 'Đã thu',
            content: RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: FormatCurrency(item.amount),
                    style: StyleApp.medium(color: green_1),
                  ),
                  TextSpan(
                    text:
                        '/${FormatCurrency(myBloc.state.order?.totalPrice.validator)}',
                    style: StyleApp.medium(color: blackColor),
                  ),
                ],
              ),
            ),
            flexContent: 2,
          ),
          8.height,
          RowItem(
            title: 'Phương thức thanh toán',
            content: item.method?.name.validator ?? '',
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall({required String phone}) async {
    final url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('can not launch url');
    }
  }

  Widget _buildRedOrder(OrderDetailState state) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: 8.radius,
      ),
      padding: 16.pading,
      child: RowItem(
        title: 'Hóa đơn đỏ',
        content: (state.order?.redInvoice ?? false) ? 'Có' : 'Không',
        titleStyle: StyleApp.medium(),
        contetnStyle: StyleApp.medium(),
      ),
    );
  }

  Widget _buildNote(OrderDetailState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: 8.radius,
      ),
      padding: 16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ghi chú đơn hàng',
            style: StyleApp.normal(),
          ),
          8.height,
          Text(
            state.order?.description ?? '',
            style: StyleApp.medium(),
          ),
        ],
      ),
    );
  }

  Widget _buildItemInOrder(OrderDetailState state) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: StyleApp.medium(color: ColorApp.black),
            ).expanded(),
            // Text(
            //   'Chỉnh sửa',
            //   style: StyleApp.medium(color: ColorApp.blue20),
            // ),
          ],
        ),
        24.height,
        const RowItemCardProductConfirmOrder(
          title: 'Sản phẩm',
          amount: 'Số lượng',
          total: 'Thành tiền',
          style: p6,
          color: borderColor_4,
        ),
        8.height,
        const Divider(),
        8.height,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = state.order?.items[index];
            return RowItemCardProductConfirmOrder(
              title: isProdOrder ? item!.name.validator : item!.title.validator,
              amount: (item.quantity ?? 0).toString(),
              total: FormatCurrency(
                (item.unitPrice.validator - item.discount.validator) *
                    item.quantity.validator,
              ),
            );
          },
          separatorBuilder: (context, index) => gapHeight(sp16),
          itemCount: state.order?.items.length ?? 0,
        ),
        16.height,
      ],
    );
  }

  String get title {
    return 'Danh sách ${isProdOrder ? 'sản phẩm' : 'dịch vụ'} (${myBloc.state.order?.items.length})';
  }

  bool get isProdOrder {
    return myBloc.state.order?.type == OrderType.product.code.toLowerCase();
  }

  Future<void> _shareImageBill() async {
    final boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    // Lấy thư mục tạm thời để lưu tệp tin hình ảnh
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/bill.png';

    final xfile = await File(filePath).writeAsBytes(pngBytes);
    Share.shareXFiles([XFile(xfile.path)]);
  }

  void _developingFeature() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng đang phát triển'),
        backgroundColor: ColorApp.red,
        duration: Duration(milliseconds: 200),
      ),
    );
  }

  void _sendZalo() {
    DialogUtils.showLoadingDialog(context, 'Đang gửi hoá đơn');
    myBloc.sendZalo().then((value) {
      context.pop();
      if (value.code == 200 && value.data == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gửi hoá đơn thành công'),
            backgroundColor: ColorApp.green,
            duration: Duration(milliseconds: 1000),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gửi hoá đơn thất bại ${value.message}'),
            backgroundColor: ColorApp.red,
            duration: const Duration(milliseconds: 1000),
          ),
        );
      }
    });
  }
}
