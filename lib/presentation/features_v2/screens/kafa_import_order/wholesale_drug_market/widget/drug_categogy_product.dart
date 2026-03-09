import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_gridview.dart';
import 'package:pharmago/presentation/base/app_text.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/shopping_cart/drug_cart_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/wholesale_drug_maket/wholesale_drug_market_v2_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/product/drug_category_model.dart.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/variant_kafa_model.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/wholesale_drug_market/widget/drug_product_widget.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/dialog/dialog_confirm.dart';
import 'package:pharmago/shared/components/dialog/dialog_message.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

class DrugCategoryProduct extends StatefulWidget {
  const DrugCategoryProduct({
    super.key,
    required this.bloc,
    this.title,
    this.icon,
    this.isShowCate = true,
    this.onMore,
    this.cartBloc,
    this.reload,
  });
  final String? title;
  final String? icon;
  final bool isShowCate;
  final dynamic Function()? onMore;
  final dynamic Function()? reload;
  final WholesaleDrugMarketV2Bloc bloc;
  final DrugCartBloc? cartBloc;

  @override
  State<DrugCategoryProduct> createState() => _DrugCategoryProductState();
}

class _DrugCategoryProductState extends State<DrugCategoryProduct> {
  final delay = DelayCallBack(delay: 1.seconds);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    return BlocBuilder<WholesaleDrugMarketV2Bloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return Visibility(
          visible: bloc.list.isNotEmpty,
          child: Column(
            children: [
              Visibility(
                visible: widget.isShowCate,
                child: Row(
                  children: [
                    FaIcon(
                      iconCode: widget.icon ?? 'f46b',
                      size: 18,
                      color: AppColors.brand,
                      type: FaIconType.solid,
                    ),
                    8.width,
                    Text(
                      widget.title ?? '',
                      style: s16w700.copyWith(color: AppColors.brand),
                    ),
                  ],
                ).padding(16.padingHor),
              ),
              AppGridView(
                physics: const NeverScrollableScrollPhysics(),
                pading: 16.pading,
                crossAxisCount: 2,
                mainAxisExtent: 300,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemCount: bloc.list.length,
                itemBuilder: (context, index) {
                  final variant = bloc.list[index];
                  return GestureDetector(
                    onTap: () async {
                      final result = await context.router
                          .push(VariantKafaDetailRoute(id: variant.id ?? -1));
                      if (result == true) {
                        widget.reload?.call();
                      }
                    },
                    child: DrugProdWidget(
                      variant: variant,
                      onAdd: (p0) => _onAdd(context, variant.id, p0),
                      onMinus: (p0) => _onMinus(context, p0, variant.id),
                      onUpdate: (p0) => _onUpdate(p0, variant),
                    ),
                  );
                },
              ),
              Visibility(
                visible: state.status == BlocStatus.loadList,
                child: const BaseLoading(),
              ),
              Visibility(
                visible: bloc.isMore,
                child: MainButtonV2(
                  title: 'Xem thêm',
                  backgroundColor: AppColors.brand,
                  radius: 999,
                  onTap: () => bloc.getList(getMore: true),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addPrdToCartDialog(BuildContext context, int? id, int p0) {
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
        content: const AppText(
          'Bạn có muốn thêm sản phẩm này vào giỏ hàng?',
          maxLines: 2,
          style: s14w400,
          textAlign: TextAlign.center,
        ),
        confirm: () {
          context.pop();
          widget.bloc.onUpdate(id ?? 0, p0);
          widget.cartBloc?.addPrdToCart(
            prds: [DrugProductModel(id: id, quantity: p0)],
          );
        },
      ),
    );
  }

  void _onAdd(BuildContext context, int? id, int p0) {
    if (p0 == 1) {
      widget.bloc.onUpdate(id ?? 0, p0);
      widget.cartBloc?.addPrdToCart(
        prds: [DrugProductModel(id: id, quantity: p0)],
      );
    } else {
      widget.bloc.onUpdate(id ?? 0, p0);
      delay.debounce(() => widget.cartBloc?.updatePrd(id: id, quantity: p0));
    }
  }

  void _onMinus(BuildContext context, int p0, int? id) {
    if (p0 > 0) {
      widget.bloc.onUpdate(id ?? 0, p0);
      delay.debounce(
        () => widget.cartBloc?.updatePrd(id: id, quantity: p0),
      );
    } else if (p0 == 0) {
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
          content: const AppText(
            'Bạn có chắc muốn xóa sản phẩm này ra khỏi giỏ hàng?',
            maxLines: 2,
            style: s14w400,
            textAlign: TextAlign.center,
          ),
          confirm: () {
            context.pop();
            widget.bloc.onUpdate(id ?? 0, p0);
            widget.cartBloc?.deletePrdOnMarket(deleteIds: [id ?? 0]);
          },
        ),
      );
    }
  }

  void _onUpdate(String? p0, VariantKafaPreviewModel? variant) {
    delay.debounce(
      () {
        final parseQuantity = int.tryParse(p0.removeAllDot()) ?? 1;
        final updateQuantity = parseQuantity > 0 ? parseQuantity : 1;
        if (variant?.quantity == 0) {
          // _addPrdToCartDialog(context, variant?.id, p0);
          widget.bloc.onUpdate(variant?.id ?? 0, updateQuantity);
          widget.cartBloc?.addPrdToCart(
            prds: [DrugProductModel(id: variant?.id, quantity: updateQuantity)],
          );
        } else {
          widget.bloc.onUpdate(variant?.id ?? 0, updateQuantity);
          widget.cartBloc?.updatePrd(id: variant?.id, quantity: updateQuantity);
        }
        FocusScope.of(context).unfocus();
      },
    );
  }
}
