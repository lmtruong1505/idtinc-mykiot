import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/base_buttom_bar.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/shopping_cart/cart_voucher_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/product/voucher_model.dart.dart';
import 'package:pharmago/shared/components/button/double_button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../di/di.dart';
import '../../../blocs/state/init_state.dart';

@RoutePage()
class CartVouchersScreen extends StatefulWidget {
  const CartVouchersScreen({
    super.key,
    this.vouchers,
    required this.totalPrice,
    required this.onConfirm,
    required this.voucherSelect,
  });
  final List<VoucherModel>? vouchers;
  final VoucherModel? voucherSelect;
  final num totalPrice;
  final dynamic Function(VoucherModel? value) onConfirm;
  @override
  State<CartVouchersScreen> createState() => _CartVouchersScreenState();
}

class _CartVouchersScreenState extends State<CartVouchersScreen> {
  final bloc = getIt<CartVoucherBloc>();

  late TextEditingController search;
  @override
  void initState() {
    search = TextEditingController();
    super.initState();
    bloc.initData(widget.vouchers, widget.totalPrice, widget.voucherSelect);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Voucher giảm giá',
      ),
      backgroundColor: ColorApp.greyF5,
      body: Container(
        padding: 16.pading.copyWith(bottom: 0),
        child: Column(
          children: [
            _buildSearch(),
            BlocBuilder<CartVoucherBloc, CubitState>(
              bloc: bloc,
              builder: (context, state) {
                if (bloc.vouchersSearch?.isEmpty == true) {
                  return const EmptyContainer(
                    msg: 'Không có chương trình khuyến mãi',
                  ).padding(16.padingVer);
                }
                return VoucherList(
                  vouchers: bloc.vouchersSearch,
                  voucherSelect: bloc.voucherSelect,
                  onTap: (p0) {
                    bloc.selectVoucher(p0);
                  },
                );
                // ListView.separated(
                //   padding: 16.padingVer,
                //   physics: const BouncingScrollPhysics(),
                //   shrinkWrap: true,
                //   itemBuilder: (context, index) {
                //     final voucher = bloc.vouchersSearch?[index];
                //     PromotionVoucherItem? promotionItem;
                //     promotionItem = voucher?.promotionItems?.firstOrNull;
                //     return _voucherItem(voucher, promotionItem);
                //   },
                //   separatorBuilder: (context, index) => 12.height,
                //   itemCount: bloc.vouchersSearch?.length ?? 0,
                // );
              },
            ).expanded(),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<CartVoucherBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          return BaseBottomBar(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: bloc.voucherSelect != null,
                  child: Text.rich(
                    TextSpan(
                      text: 'Bạn được giảm ',
                      style: s12w400.copyWith(color: AppColors.brand),
                      children: [
                        TextSpan(
                          text: bloc.totalDiscountInVoucherScreen.formatVND,
                          style: s12w500.copyWith(color: AppColors.red60),
                        ),
                        TextSpan(
                          text: ' trên đơn hàng!',
                          style: s12w400.copyWith(color: AppColors.brand),
                        ),
                      ],
                    ),
                  ),
                ),
                8.height,
                DoubleButton(
                    confirmText: 'Xác nhận',
                    cancelText: 'Hủy bỏ',
                    onCancel: () => context.router.maybePop(),
                    onConfirm: () {
                      widget.onConfirm(bloc.voucherSelect);
                    }
                    // () {
                    //   bloc.confirmVoucher();
                    //   context.router.maybePop();
                    // },
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearch() {
    return AppInputSupport(
      controller: search,
      hintText: 'Tìm theo tên sản phẩm',
      prefixIcon: const Icon(
        Icons.search_outlined,
      ),
      backgroundColor: ColorApp.white,
      radius: 999,
      onChanged: (p0) {
        bloc.onVoucherSearch(p0);
      },
    );
  }
}

class VoucherList extends StatefulWidget {
  const VoucherList({
    super.key,
    required this.vouchers,
    required this.voucherSelect,
    this.onTap,
    this.canScroll = true,
  });
  final List<VoucherModel>? vouchers;
  final VoucherModel? voucherSelect;
  final void Function(VoucherModel?)? onTap;
  final bool canScroll;

  @override
  State<VoucherList> createState() => _VoucherListState();
}

class _VoucherListState extends State<VoucherList> {
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: 16.padingVer,
      physics: widget.canScroll
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final voucher = widget.vouchers?[index];
        PromotionVoucherItem? promotionItem;
        promotionItem = voucher?.promotionItems?.firstOrNull;
        return _voucherItem(voucher, promotionItem);
      },
      separatorBuilder: (context, index) => 12.height,
      itemCount: widget.vouchers?.length ?? 0,
    );
  }

  Widget _voucherItem(
      VoucherModel? voucher, PromotionVoucherItem? promotionItem) {
    return GestureDetector(
      // onTap: () => bloc.selectVoucher(voucher),
      onTap: () => widget.onTap?.call(voucher),
      child: BaseContainer(
        borderColor: widget.voucherSelect?.id == voucher?.id
            ? AppColors.brand
            : AppColors.grey20,
        padding: 8.pading,
        child: Row(
          children: [
            Image.asset(
              'assets/imgs/img_voucher.png',
              width: 54,
              height: 54,
            ),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voucher?.title ?? '',
                  style: s12w600,
                ),
                12.height,
                Text(
                  'Hết hạn trong ${((voucher?.endDate ?? now).difference(now)).inDays} ngày',
                  style: s12w600.copyWith(color: AppColors.brand),
                ),
                12.height,
                Text(
                  'Đặt tối thiểu ${promotionItem?.valueMin.formatCurrency} đ ',
                  style: s10w400.copyWith(
                    color: AppColors.text_secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
