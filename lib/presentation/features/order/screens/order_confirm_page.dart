import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/features/order/v2/cubit/order_create_v2_state.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../../base/app_bar.dart';
import '../../../base/base_check_box.dart';
import '../../../base/dialog.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../router/router.gr.dart';
import '../../../shared/utils/event.dart';
import '../cubit/order_create_cubit/order_create_state.dart';
import '../v2/cubit/order_create_v2_cubit.dart';
import '../v2/widget/card_product_confirm.dart';

@RoutePage()
class OrderConfirmPage extends StatefulWidget {
  const OrderConfirmPage({
    super.key,
    required this.myBloc,
  });

  final OrderCreateV2Bloc myBloc;

  @override
  State<OrderConfirmPage> createState() => _OrderConfirmPageState();
}

class _OrderConfirmPageState extends State<OrderConfirmPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCreateV2Bloc, OrderCreateV2State>(
      bloc: widget.myBloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bg_4,
          appBar: const BaseAppBar(title: 'Xác nhận đơn hàng'),
          body: Container(
            height: heightDevice(context),
            width: widthDevice(context),
            padding: const EdgeInsets.symmetric(horizontal: sp16),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  25.height,
                  _buildInfoCus(),
                  const SizedBox(height: sp24),
                  Text(
                    title,
                    style: p3.copyWith(color: blackColor),
                  ),
                  const SizedBox(height: sp16),
                  const RowItemCardProductConfirmOrder(
                    title: 'Sản phẩm',
                    amount: 'Số lượng',
                    total: 'Thành tiền',
                    style: p6,
                    color: borderColor_4,
                  ),
                  12.height,
                  if (state.typeCreate == OrderType.product)
                    _buildVar(state)
                  else
                    _buildSer(state),
                  const Divider(),
                  Row(
                    children: [
                      BaseCheckbox(
                        value: state.selectedOrderRed,
                        onChanged: (value) =>
                            widget.myBloc.selectedOrderRedChange(),
                      ),
                      const SizedBox(width: sp12),
                      Text(
                        'Hoá đơn đỏ',
                        style: p5.copyWith(color: blackColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: sp24),
                  AppInputSupport(
                    label: 'Ghi chú đơn hàng',
                    hintText: 'Nhập ghi chú',
                    maxLines: 3,
                    backgroundColor: whiteColor,
                    radius: sp12,
                    onChanged: (value) => {
                      widget.myBloc.noteChange(value),
                    },
                  ),
                  const SizedBox(height: sp24),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(context),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      color: whiteColor,
      padding: const EdgeInsets.symmetric(
        vertical: sp24,
        horizontal: sp16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng tiền',
                style: p6.copyWith(color: greyColor),
              ),
              BlocBuilder<OrderCreateV2Bloc, OrderCreateV2State>(
                bloc: widget.myBloc,
                builder: (context, state) {
                  return Text(
                    '${FormatCurrency(state.total)}đ',
                    style: p5.copyWith(color: mainColor),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: sp24),
          ClipRRect(
            borderRadius: BorderRadius.circular(sp12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(sp12),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(sp12),
                      ),
                      border: Border.all(
                        color: greyColor,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.router.maybePop();
                      },
                      child: const Center(
                        child: Text(
                          'Quay lại',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: sp12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(sp12),
                    decoration: const BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(sp12),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        _createOrderHanle();
                      },
                      child: const Center(
                        child: Text(
                          'Tạo đơn',
                          style: TextStyle(color: whiteColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get title {
    final count = widget.myBloc.state.typeCreate == OrderType.product
        ? widget.myBloc.state.variantSelected.length
        : widget.myBloc.state.serviceSelected.length;
    return 'Danh sách ${widget.myBloc.state.typeCreate.toName.toLowerCase()} ($count)';
  }

  Widget _buildInfoCus() {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp12),
      ),
      padding: const EdgeInsets.all(sp16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Khách hàng',
            style: p6.copyWith(color: greyColor, fontWeight: BOLD),
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
                          widget.myBloc.state.customerSelected?.name ?? '',
                          style: p5.copyWith(color: blackColor),
                        ),
                        Text(
                          '${widget.myBloc.state.customerSelected?.orders ?? 0} đơn - ${FormatCurrency(widget.myBloc.state.customerSelected?.revenue ?? 0)}đ',
                          style: p5.copyWith(color: blackColor),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        _makePhoneCall(
                          phone:
                              widget.myBloc.state.customerSelected?.phone ?? '',
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
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: green_1,
                      size: 16,
                    ),
                    8.width,
                    Text(
                      widget.myBloc.state.customerSelected?.phone ?? '',
                      style: p5.copyWith(
                        color: blackColor,
                        fontWeight: DEFAULT,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

  void _createOrderHanle() {
    DialogUtils.showLoadingDialog(
      context,
      'Đang tạo đơn vui lòng đợi',
    );
    widget.myBloc.createOrder().then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        context.router.popUntil(
          (route) =>
              route.settings.name == 'OrderListRoute' ||
              route.settings.name == 'HomeRoute',
        );
        context.router.push(OrderDetailV2Route(id: value.data));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorApp.main,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp12),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Tạo đơn thành công',
              style: p5.copyWith(color: whiteColor),
            ),
          ),
        );

        // DialogUtils.showSuccessDialog(
        //   context,
        //   content: 'Tạo đơn hàng thành công',
        //   titleClose: 'Danh sách đơn hàng',
        //   titleConfirm: 'Chi tiết',
        //   close: () {
        //     context.router.popUntil((route) =>
        //         route.settings.name == 'OrderListRoute' ||
        //         route.settings.name == 'HomeRoute');
        //     context.router.push(const OrderListRoute());
        //   },
        //   accept: () {
        //     context.router.popUntil((route) =>
        //         route.settings.name == 'OrderListRoute' ||
        //         route.settings.name == 'HomeRoute');
        //     context.router.push(OrderDetailV2Route(id: value.data));
        //   },
        // );
      } else if (value.code == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: yellow_1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp12),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text(
              value.message ?? '',
              style: p5.copyWith(color: whiteColor),
            ),
          ),
        );
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: 'Tạo đơn hàng thất bại ${value.message}',
        );
      }
    });
  }

  Widget _buildVar(OrderCreateV2State state) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final variant =
            state.variantSelected[index];
        return CardProductConfirmOrder(variant: variant);
      },
      separatorBuilder: (context, index) => const Divider(height: sp24),
      itemCount: state.variantSelected.length,
    );
  }

  Widget _buildSer(OrderCreateV2State state) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final service =
            state.serviceSelected[index];
        return RowItemCardProductConfirmOrder(
          title: service.title ?? '',
          amount: service.amount.toString(),
          total:
              '${FormatCurrency((service.price.validator - service.directDiscount.validator) * service.amount)}đ',
        );
      },
      separatorBuilder: (context, index) => const Divider(height: sp24),
      itemCount: state.serviceSelected.length,
    );
  }
}
