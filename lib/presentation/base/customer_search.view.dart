import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../shared/components/button/label_button.dart';
import '../../shared/components/input/overlay_input.dart';
import '../config/app_style/init_app_style.dart';
import '../features_v2/blocs/order_v2/customer_selection_bloc.dart';
import '../features_v2/models/customer/v2/customer_model.dart';
import '../features_v2/screens/order/components/bts/bts_add_customer.dart';
import '../features_v2/screens/order/components/selection/customer_select_item.dart';

class CustomerSearchView extends StatelessWidget {
  CustomerSearchView({
    super.key,
    this.model,
    this.type,
    this.onChanged,
    this.titleDialog,
    this.parentCustomer,
  });

  final CustomerV2Model? model;
  final String? type;
  final Function(CustomerV2Model)? onChanged;
  final textCtrl = TextEditingController();
  final bloc = CustomerSelectionBloc();
  final String? titleDialog;
  final int? parentCustomer;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return OverlayInput<CustomerV2Model>(
      itemBuilder: (BuildContext context, item, int index) {
        return CustomerSelectItem(
          model: item,
          isSelected: model?.id == item.id,
        );
      },
      onChanged: onChanged,
      hintText: 'Tìm tên, SĐT khách hàng',
      itemHeight: 72,
      lazyLoad: (isMore) => bloc.getList(
        textCtrl.text,
        isMore: isMore,
        type: type,
        parentCustomer: parentCustomer,
      ),
      controller: textCtrl,
      borderRadius: 999,
      header: Text(
        'Chọn khách hàng',
        style: AppStyle.headingMd.copyWith(
          color: AppColors.text_quaternary,
        ),
      ).padding(16.pading.copyWith(top: 12, bottom: 6)),
      elevation: 1,
      prefix: const Icon(
        Icons.search,
        size: 24,
      ),
      autoFocus: false,
      suffix: InkWell(
        onTap: () async {
          focusNode.unfocus();
          FocusScope.of(context).unfocus();
          context.bottomSheet(
            BtsAddCustomer(
              phone: textCtrl.text,
              isEvent: false,
              title: titleDialog,
              success: (value) {
                onChanged?.call(value);
              },
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const VerticalDivider(
              color: AppColors.input_borderDefault,
              thickness: 1,
              width: 0,
            ),
            Padding(
              padding: 1.pading,
              child: LabelButton(
                label: 'Tạo mới',
                labelStyle: AppStyle.bodySmMedium.copyWith(
                  color: AppColors.button_neutral_ghost_textDefault,
                ),
                padding: 12.padingHor,
                radius: 999.radiusRight,
                fixedSize: const Size(double.infinity, 46),
              ),
            ),
          ],
        ),
      ),
      focusNode: focusNode,
    ).size(height: 40);
  }
}
