import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/app_text.dart';
import 'package:pharmago/presentation/base/base_buttom_bar.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/base/row_custom.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/shopping_cart/drug_cart_bloc.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/shopping_cart/widget/drug_cart_product_item.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/dialog/dialog_confirm.dart';
import 'package:pharmago/shared/components/dialog/dialog_message.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../di/di.dart';
import '../../../blocs/state/init_state.dart';

@RoutePage()
class DrugCartScreen extends StatefulWidget {
  const DrugCartScreen({super.key});

  @override
  State<DrugCartScreen> createState() => _DrugCartScreenState();
}

class _DrugCartScreenState extends State<DrugCartScreen> {
  final bloc = getIt.get<DrugCartBloc>();

  @override
  void initState() {
    bloc.getCart();
    bloc.resetReloadPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrugCartBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        final suggestPrm = bloc.suggestPromotion;
        final addPrice =
            ((bloc.suggestPromotion?.valueMin ?? 0) - bloc.totalPrice)
                .formatVND;
        final discountSuggest =
            '${suggestPrm?.discount.formatNumber} ${suggestPrm?.type == 1 ? 'đ' : '%'}';
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: BaseAppBar(
              leading: BackButton(
                onPressed: () {
                  context.pop(result: bloc.reloadPreviousPage);
                },
              ),
              // GestureDetector(
              //   onTap: ,
              //   child: const Icon(Icons.arrow_back_ios),
              // ),
              title: 'Giỏ hàng',
              elevation: 1,
            ),
            backgroundColor: ColorApp.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    BaseCheckbox2(
                      value: bloc.isSelectAll,
                      onChanged: (value) => bloc.onToggleAll(),
                    ),
                    8.width,
                    Text(
                      'Chọn tất cả',
                      style: StyleApp.bold(color: ColorApp.black),
                      textAlign: TextAlign.right,
                    ),
                    const Spacer(),
                    Visibility(
                      visible: bloc.totalPrdsSelect > 0,
                      child: InkWell(
                        onTap: () {
                          _showDetelePrdDialog(context);
                        },
                        child: Text(
                          'Xoá ${bloc.isSelectAll ? 'tất cả' : 'đã chọn'} ',
                          style: StyleApp.bold(color: ColorApp.black),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ).padding(16.pading),
                (bloc.cartPrds.isEmpty == true)
                    ? EmptyComfirm(text: 'Chưa có sản phẩm')
                    : RefreshIndicator(
                        onRefresh: () async => bloc
                          ..getCart()
                          ..getVouchers(),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final cate = bloc.cartPrds[index];
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    BaseCheckbox2(
                                      value: cate.isSelect,
                                      onChanged: (value) {
                                        bloc.onSelectCategory(cate);
                                      },
                                    ),
                                    16.width,
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
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider().padding(8.padingVer),
                                  itemCount: cate.products?.length ?? 0,
                                ),
                              ],
                            ).padding(16.padingHor);
                          },
                          separatorBuilder: (context, index) => const Divider(
                            thickness: 16,
                          ).padding(12.padingVer),
                          itemCount: bloc.cartPrds.length,
                        ),
                      ).expanded(),
              ],
            ),
            bottomNavigationBar: BaseBottomBar(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Voucher giảm giá',
                        style: s12w700.copyWith(color: AppColors.brand),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => context.router.push(
                          CartVouchersRoute(
                            vouchers: bloc.vouchers,
                            totalPrice: bloc.totalPrice,
                            voucherSelect: bloc.voucherSelect,
                            onConfirm: (value) {
                              bloc.confirmVoucher(value);
                              context.router.maybePop();
                            },
                          ),
                        ),
                        child: Row(
                          children: [
                            bloc.voucherSelected != null
                                ? BaseContainer(
                                    borderRadius: 4,
                                    padding: 4.pading,
                                    borderColor: AppColors.red60,
                                    child: Text(
                                      bloc.totalDiscount.formatVND,
                                      style: s10w400.copyWith(
                                        color: AppColors.red60,
                                        height: 1,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Chọn mã giảm giá của bạn',
                                    style: s10w400.copyWith(
                                      color: AppColors.text_tertiary,
                                    ),
                                  ),
                            4.width,
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  8.height,
                  Visibility(
                    visible: bloc.voucherSelected != null &&
                        bloc.suggestPromotion != null,
                    child: BaseContainer(
                      borderColor: AppColors.red10,
                      borderRadius: 8,
                      color: AppColors.red10,
                      padding: 4.padingVer + 8.padingHor,
                      child: Row(
                        children: [
                          FaIcon(
                            iconCode: 'f145',
                            type: FaIconType.light,
                            color: AppColors.red60,
                          ),
                          12.width,
                          Text(
                            'Mua thêm $addPrice để được giảm giá $discountSuggest',
                            style: s10w400.copyWith(
                              color: AppColors.text_secondary,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          RowCustom(
                            title: 'Tổng tiền',
                            data: bloc.totalPrice.formatVND,
                            titleStyle: s10w400,
                            dataStyle: s14w700.copyWith(
                              color: AppColors.brand,
                            ),
                          ),
                          RowCustom(
                            title: 'Tổng giảm giá: ',
                            data: bloc.totalDiscount.formatVND,
                            titleStyle: s10w400,
                            dataStyle: s12w700.copyWith(
                              color: AppColors.brand,
                            ),
                          ),
                          RowCustom(
                            title: 'Thanh toán ',
                            data: (bloc.totalPrice - bloc.totalDiscount)
                                .formatVND,
                            titleStyle: s12w500,
                            dataStyle: s12w700.copyWith(
                              color: AppColors.brand,
                            ),
                          ),
                        ],
                      ).expanded(),
                      8.width,
                      MainButtonV2(
                        radius: 999,
                        title: 'Xác nhận (${bloc.totalPrdsSelect})',
                        onTap: bloc.totalPrdsSelect > 0
                            ? () {
                                context.router.push(
                                  ConfirmKafaOrderV2Route(
                                    readySaleCategory: bloc.cartSelected,
                                    totalDiscount: bloc.totalDiscount,
                                    totalPrice: bloc.totalPrice,
                                    promotionActive:
                                        bloc.voucherPromotionActive,
                                  ),
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ).padding(16.padingBottom),
            ),
          ),
        );
      },
    );
  }

  void _showDetelePrdDialog(BuildContext context) {
    context.dialog(
      DialogConfirm(
        icon: IconDiaLog(
          color: AppColors.fg_warning.withOpacity(0.1),
          icon: FaIcon(
            iconCode: 'f071',
            color: AppColors.fg_warning,
            type: FaIconType.solid,
          ),
        ),
        title: 'Xác nhận',
        content: AppText(
          'Bạn có chắc muốn xóa ${bloc.isSelectAll ? 'tất cả' : 'những'} sản phẩm này ra khỏi giỏ hàng?',
          maxLines: 2,
          style: s14w400,
          textAlign: TextAlign.center,
        ),
        confirm: () {
          context.pop();
          bloc.deletePrds(
            deletePrds: bloc.cartPrds
                .expand((cate) => cate.products!)
                .where((prd) => prd.isSelect)
                .toList(),
          );
        },
      ),
    );
  }
}
