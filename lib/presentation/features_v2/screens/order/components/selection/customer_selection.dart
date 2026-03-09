import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/bts/bts_add_customer.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/selection/customer_chose.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/selection/customer_select_item.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../../shared/components/button/label_button.dart';
import '../../../../../../shared/components/input/overlay_input.dart';
import '../../../../blocs/order_v2/customer_selection_bloc.dart';
import '../../../../models/customer/v2/customer_model.dart';

class CustomerSelection extends StatefulWidget {
  const CustomerSelection({
    super.key,
    required this.bloc,
    this.type,
    this.isEvent = false,
  });
  final String? type;
  final bool isEvent;
  final CustomerSelectionBloc bloc;

  @override
  State<CustomerSelection> createState() => _CustomerSelectionState();
}

class _CustomerSelectionState extends State<CustomerSelection> {
  final textCtrl = TextEditingController();
  bool autoFocus = false;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerSelectionBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Khách hàng',
                  style: AppStyle.headingLg,
                ).expanded(),
                if (widget.bloc.model != null)
                  ChipCustom(
                    color: AppColors.button_neutral_alpha_textDefault,
                    isBorder: false,
                    title: 'Chọn lại',
                    padding: 12.padingHor + 6.padingVer,
                    onTap: () {
                      widget.bloc.model = null;
                      autoFocus = true;
                    },
                  ),
              ],
            ),
            if (widget.bloc.model == null) ...[
              12.height,
              _buildSearch(),
            ],
            12.height,
            _buildInfo(),
          ],
        );
      },
    );
  }

  SizedBox _buildSearch() {
    return OverlayInput<CustomerV2Model>(
      focusNode: focusNode,
      itemBuilder: (BuildContext context, item, int index) {
        return CustomerSelectItem(
          model: item,
          isSelected: widget.bloc.model?.id == item.id,
        );
      },
      onChanged: (item) {
        widget.bloc.model = item;
      },
      hintText: 'Tìm tên, SĐT khách hàng',
      itemHeight: 72,
      lazyLoad: (isMore) =>
          widget.bloc.getList(textCtrl.text, isMore: isMore, type: widget.type),
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
      autoFocus: autoFocus,
      suffix: InkWell(
        onTap: () {
          context.bottomSheet(
            BtsAddCustomer(
              phone: textCtrl.text,
              isEvent: widget.isEvent,
              success: (value) {
                focusNode.unfocus();
                widget.bloc.model = value;
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
    ).size(height: 40);
  }

  Widget _buildInfo() {
    if (widget.bloc.model == null) {
      return Center(
        child: Text(
          'Chưa có khách hàng\nVui lòng tìm hoặc thêm khách hàng',
          style: AppStyle.bodyMdRegular.copyWith(
            color: AppColors.text_tertiary,
          ),
          textAlign: TextAlign.center,
        ),
      ).padding(40.pading);
    }
    return CustomerChose(
      model: widget.bloc.model!,
      productsSelected: widget.bloc.productExchangePoint,
      productsFromPackage: widget.bloc.productsFromPackage,
      moneyExchange: widget.bloc.moneyExchange,
      update: () {
        context.bottomSheet(
          BtsAddCustomer(
            success: (value) {
              focusNode.unfocus();
              widget.bloc.model = value;
            },
            model: widget.bloc.model,
          ),
        );
      },
      productExchangePointCallBack: ({
        required moneyExchange,
        required productsFromPackage,
        required productsSelected,
      }) {
        widget.bloc.productExchangePoint = productsSelected;
        widget.bloc.productsFromPackage = productsFromPackage;
        widget.bloc.moneyExchange = moneyExchange;
      },
    );
  }
}
