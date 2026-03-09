import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/base_buttom_bar.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/row_custom.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/shopping_cart/confirm_kafa_order_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/shopping_cart/drug_cart_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/product/drug_category_model.dart.dart';
import 'package:pharmago/presentation/features_v2/models/product/voucher_model.dart.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/confirm_kafa_order_page/confirm_kafa_order_page.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/shopping_cart/widget/drug_cart_product_item.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/components/widgets/app_switch.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../di/di.dart';

@RoutePage()
class ConfirmKafaOrderV2Page extends StatefulWidget {
  const ConfirmKafaOrderV2Page({
    super.key,
    required this.readySaleCategory,
    required this.totalDiscount,
    required this.totalPrice,
    this.promotionActive,
  });
  final List<DrugCategoryModel> readySaleCategory;
  final num totalDiscount;
  final num totalPrice;
  final PromotionVoucherItem? promotionActive;

  @override
  State<ConfirmKafaOrderV2Page> createState() => _ConfirmKafaOrderV2PageState();
}

class _ConfirmKafaOrderV2PageState extends State<ConfirmKafaOrderV2Page> {
  final bloc = getIt.get<DrugCartBloc>();
  final cubit = getIt.get<ConfirmKafaOrderBloc>();

  @override
  void initState() {
    super.initState();
    cubit.initData(
      widget.readySaleCategory,
      widget.totalDiscount,
      widget.totalPrice,
      widget.promotionActive,
    );
  }

  num get totalPrdsSelect => widget.readySaleCategory
          .expand((cate) => cate.products ?? [])
          .fold(0, (pre, value) {
        return pre + (value.quantity ?? 0);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Xác nhận đơn hàng',
      ),
      backgroundColor: ColorApp.greyF5,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: 16.pading,
              child: BaseContainer(
                borderColor: AppColors.white,
                padding: 4.pading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danh sách sản phẩm ($totalPrdsSelect)',
                      style: s16w500,
                    ),
                    const Divider().padding(4.padingVer),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final cate = widget.readySaleCategory[index];
                        return Column(
                          children: [
                            Row(
                              children: [
                                FaIcon(
                                  iconCode: 'f5a2',
                                  color: AppColors.yellow60,
                                ),
                                16.width,
                                Text(
                                  cate.title ?? '',
                                  style: s14w600,
                                ),
                              ],
                            ),
                            const Divider(
                              height: 1,
                            ).padding(8.padingVer),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final prd = cate.products?[index];
                                return DrugCartPrdItem(
                                  prd: prd,
                                  bloc: bloc,
                                  isConfirmPage: true,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider().padding(8.padingVer),
                              itemCount: cate.products?.length ?? 0,
                            ),
                          ],
                        ).padding(16.padingHor);
                      },
                      separatorBuilder: (context, index) => 12.height,
                      itemCount: widget.readySaleCategory.length,
                    ),
                  ],
                ),
              ),
            ),
            _buildTypePayment(),
            8.height,
            _buildNote(),
            8.height,
            _buildTotalPrice(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Widget _buildTypePayment() {
    return Padding(
      padding: 16.padingHor,
      child: Row(
        children: [
          const Text('Hóa đơn đỏ', style: s12w500),
          const Spacer(),
          BlocBuilder<DrugCartBloc, CubitState>(
            bloc: bloc,
            builder: (context, state) {
              return AppSwitch(
                value: bloc.isRedInvoid,
                onChanged: (value) => bloc.toggleRedInvoice(),
              );
            },
          ),
        ],
      ).container(),
    );
  }

  Widget _buildNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Ghi chú đơn hàng',
          style: s14w500,
        ),
        8.height,
        AppInput(
          hintText: 'Nhập ghi chú',
          backgroundColor: AppColors.white,
          maxLines: 5,
        ),
      ],
    ).padding(16.padingHor);
  }

  Widget _buildTotalPrice() {
    return BaseContainer(
      borderRadius: 0,
      borderColor: AppColors.white,
      padding: 12.pading,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Chi tiết thanh toán', style: s14w500),
          8.height,
          RowItem(
            title: 'Tổng tiền hàng',
            content: '${FormatCurrency(widget.totalPrice)} đ',
            titleStyle: s14w400,
            contetnStyle: s14w400,
          ),
          const Divider(thickness: 1),
          Text(
            'Giảm giá đơn hàng',
            style: s14w400.copyWith(color: ColorApp.grey79),
          ),
          8.height,
          Visibility(
            visible: widget.promotionActive != null,
            child: Column(
              children: [
                RowItem(
                  title:
                      'Giảm giá ${widget.promotionActive?.discount.formatNumber}${widget.promotionActive?.type == 1 ? 'đ' : '%'}',
                  content: '- ${FormatCurrency(widget.totalDiscount)} đ',
                  titleStyle: s14w400,
                  contetnStyle: s14w400.copyWith(color: AppColors.red60),
                ),
                8.height,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return BaseBottomBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                children: [
                  RowCustom(
                    title: 'Thanh toán',
                    data: (widget.totalPrice - widget.totalDiscount).formatVND,
                    titleStyle: s12w500,
                    dataStyle: s14w700.copyWith(
                      color: AppColors.brand,
                    ),
                  ),
                  RowCustom(
                    title: 'Tổng giảm giá: ',
                    data: widget.totalDiscount.formatVND,
                    titleStyle: s10w400,
                    dataStyle: s12w400.copyWith(
                      color: AppColors.red60,
                    ),
                  ),
                ],
              ).expanded(),
              16.width,
              MainButton(
                title: 'Đặt hàng',
                radius: 999,
                event: _onBuyNow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onBuyNow() {
    DialogUtils.showLoadingDialog(context, 'Đang tạo đơn hàng...');
    cubit.createOrder().then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        bloc.getCart();
        DialogUtils.showSuccessDialog(
          context,
          content: 'Tạo đơn hàng thành công',
          titleClose: 'Danh sách',
          titleConfirm: 'Xem giỏ hàng',
          close: () {
            context.pop();
            // context.router
            //     .popUntil((route) => route.settings.name == DrugCartRoute.name);
            // context.router.push(const ListImportOrderRoute());
          },
          accept: () {
            context.pop();
            // context.router
            //     .popUntil((route) => route.settings.name == 'HomeRoute');
            // context.router
            //     .popUntil((route) => route.settings.name == DrugCartRoute.name);

            // context.router.push(const ListImportOrderRoute());
            // context.router.push(KafaOrderDetailRoute(id: value.data));
          },
        );
      } else {
        DialogUtils.showErrorDialog(context, content: '${value.message}');
      }
    });
  }
}
