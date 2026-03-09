import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../base/button.dart';
import '../../../../../constants/spacing.dart';
import '../../../../blocs/order_v2/product_selection_bloc.dart';
import '../product_order_item.dart';

class BtsShipmentInProduct extends StatelessWidget {
  const BtsShipmentInProduct({
    super.key,
    required this.bloc,
    required this.product,
    this.onUpdate,
  });

  final ProductSelectionBloc bloc;
  final ProductV2Model product;
  final Function(ProductV2Model)? onUpdate;

  static Future<ProductV2Model?> show(
    BuildContext context, {
    required ProductSelectionBloc bloc,
    required ProductV2Model product,
    Function(ProductV2Model)? onUpdate,
  }) async {
    return showModalBottomSheet<ProductV2Model>(
      context: context,
      builder: (context) {
        return BtsShipmentInProduct(
          bloc: bloc,
          product: product,
          onUpdate: onUpdate,
        );
      },
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: sp16),
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sp24),
              color: AppColors.border_tertiary,
            ),
          ),
          const Text(
            'Chi tiết lô hàng áp dụng',
            style: s20w700,
          ),
          12.height,
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ProductOrderItem(
                bloc: bloc,
                model: product,
                onUpdate: onUpdate,
                editShipment: true,
              ),
            ),
          ),
          Row(
            children: [
              MainButton(
                title: 'Xác nhận',
                event: () {
                  Navigator.of(context).pop();
                },
                radius: sp48,
              ).expanded(),
            ],
          ).padding(const EdgeInsets.all(sp16)),
          16.height,
        ],
      ),
    );
  }
}
