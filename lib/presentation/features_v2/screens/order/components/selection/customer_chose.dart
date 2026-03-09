import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/presentation/features_v2/models/customer/v2/customer_model.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../config/app_style/init_app_style.dart';
import '../../../../../constants/spacing.dart';
import '../../../../../features/company/data/models/point_exchange_package_model.dart';
import '../../../../models/customer/v2/customer_point_item_model.dart';
import '../../../../models/product/product_v2_model.dart';
import '../dialog_use_point_exchange.dart';

class CustomerChose extends StatelessWidget {
  const CustomerChose({
    super.key,
    required this.model,
    this.productsSelected,
    this.productsFromPackage,
    this.moneyExchange,
    this.showInfo = true,
    this.update,
    this.productExchangePointCallBack,
  });

  final CustomerV2Model model;
  final List<ProductV2Model>? productsSelected;
  final List<PointExchangePackageModel>? productsFromPackage;
  final CustomerPointItemModel? moneyExchange;
  final bool showInfo;
  final Function()? update;
  final Function({
    required List<ProductV2Model> productsSelected,
    required List<PointExchangePackageModel> productsFromPackage,
    required CustomerPointItemModel moneyExchange,
  })? productExchangePointCallBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: 12.radius,
        border: Border.all(
          color: AppColors.border_tertiary,
          width: 1,
        ),
      ),
      padding: 12.pading,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                model.fullName ?? 'Không có thông tin',
                style: AppStyle.headingMd,
              ),
              4.height,
              Text(
                model.phone ?? 'Không có thông tin',
                style: AppStyle.bodyBsSemiBold
                    .copyWith(color: AppColors.text_tertiary),
              ),
              4.height,
              Row(
                children: [
                  Text(
                    '${model.points?.toStringAsFixed(3) ?? 0}',
                    style: AppStyle.bodyBsSemiBold
                        .copyWith(color: AppColors.text_tertiary),
                  ),
                  sp8.width,
                  SvgPicture.asset('assets/svg/point.svg'),
                ],
              ),
            ],
          ).expanded(),
          if (model.orders != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: model.orders.formatPrice(),
                        style: AppStyle.bodyMdMedium,
                      ),
                      TextSpan(
                        text: ' đơn',
                        style: AppStyle.bodyMdMedium
                            .copyWith(color: AppColors.text_secondary),
                      ),
                    ],
                  ),
                ),
                4.height,
                Text(
                  '${model.revenue.formatCurrency} đ',
                  style: AppStyle.bodyMdMedium
                      .copyWith(color: AppColors.text_secondary),
                ),
                4.height,
                if (showInfo)
                  MainButtonV2(
                    title: 'Đổi điểm',
                    icon: SvgPicture.asset('assets/svg/point.svg'),
                    padding: const EdgeInsets.symmetric(
                      vertical: sp0,
                      horizontal: sp12,
                    ),
                    textStyle: s12w500.copyWith(color: AppColors.text_white),
                    radius: sp48,
                    onTap: () {
                      DialogUsePointExchange.show(
                        context,
                        point: model.points ?? 0,
                        productsSelected: productsSelected ?? [],
                        productsFromPackage: productsFromPackage ?? [],
                        moneyExchange:
                            moneyExchange ?? CustomerPointItemModel(point: 0),
                        callBack: productExchangePointCallBack,
                      );
                    },
                  ),
              ],
            ).expanded(),
          if (model.orders == null)
            ChipCustom(
              color: AppColors.carrot60,
              title: 'Mới',
              perfixIcon: FaIcon(
                iconCode: 'f890',
                color: AppColors.carrot60,
                size: 12,
              ),
            ),
          if (showInfo) 12.width,
          if (showInfo)
            InkWell(
              onTap: () {
                if (model.orders != null) {
                  context.pushRoute(DetailCustomerV2Route(id: model.id ?? -1));
                } else {
                  update?.call();
                }
              },
              child: model.orders == null
                  ? const Icon(
                      Icons.edit,
                      size: 16,
                    ).container(
                      padding: 4.pading,
                      bgColor: AppColors.bg_secondary,
                      radius: 999,
                    )
                  : FaIcon(iconCode: 'f05a'),
            ),
        ],
      ),
    );
  }
}
