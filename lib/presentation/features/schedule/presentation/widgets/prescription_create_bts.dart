import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/double_button.dart';
import '../../../../../shared/components/input/overlay_input.dart';
import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/size_device.dart';
import '../../../../constants/spacing.dart';
import '../../../../di/di.dart';
import '../../../../features_v2/blocs/order_v2/product_selection_bloc.dart';
import '../../../../features_v2/blocs/state/cubit_state.dart';
import '../../../../features_v2/models/product/product_v2_model.dart';
import '../../../../features_v2/screens/order/components/product_order_item.dart';
import '../../../../features_v2/screens/product/components/product_list_item.dart';
import '../../../company/screen_v2/components/workspace_associate_dialog.dart';

class PrescriptionCreateDialog extends StatefulWidget {
  const PrescriptionCreateDialog({super.key, this.callBack});

  final Function(List<ProductV2Model>)? callBack;

  static void show(
    BuildContext context, {
    Function(List<ProductV2Model>)? callBack,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(
          top: Radius.circular(sp16),
        ),
      ),
      builder: (context) {
        return PrescriptionCreateDialog(
          callBack: callBack,
        );
      },
    );
  }

  @override
  State<PrescriptionCreateDialog> createState() =>
      _PrescriptionCreateDialogState();
}

class _PrescriptionCreateDialogState extends State<PrescriptionCreateDialog> {
  final _productSelectionBloc = getIt.get<ProductSelectionBloc>();
  final _textCtl = TextEditingController();
  final _focusNode = FocusNode();
  bool _isRefresh = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightDevice(context) * 0.85,
      child: Padding(
        padding: const EdgeInsets.all(sp16),
        child: Column(
          children: [
            Container(
              width: sp64,
              height: sp4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp24),
                color: AppColors.bg_disable,
              ),
            ),
            sp16.height,
            Text(
              'Thêm sản phẩm',
              style: s16w700.copyWith(
                color: AppColors.text_primary,
              ),
            ),
            sp16.height,
            if (!_isRefresh) _buildSearch,
            sp16.height,
            _buildHuongDan,
            sp16.height,
            Expanded(
              child: _buildList,
            ),
            DoubleButton(
              cancelText: 'Huỷ bỏ',
              confirmText: 'Lưu lại',
              onCancel: () {
                context.pop();
              },
              onConfirm: () {
                context.pop();
                widget.callBack?.call(_productSelectionBloc.list);
              },
            ).size(height: 48),
          ],
        ),
      ),
    );
  }

  OverlayInput<ProductV2Model> get _buildSearch {
    return OverlayInput<ProductV2Model>(
      controller: _textCtl,
      itemBuilder: (BuildContext context, item, int index) {
        return ProductListItem(
          model: item,
          showHead: false,
        );
      },
      onChanged: (item) async {
        setState(() {
          _productSelectionBloc.addProduct(item);
        });
      },
      hintText: 'Tìm tên, mã sản phẩm',
      itemHeight: 105,
      lazyLoad: (isMore) {
        return _productSelectionBloc.getList(_textCtl.text, isMore: isMore);
      },
      borderRadius: 999,
      header: Text(
        'Chọn sản phẩm',
        style: AppStyle.headingMd.copyWith(
          color: AppColors.text_quaternary,
        ),
      ).padding(16.pading.copyWith(top: 12, bottom: 6)),
      elevation: 1,
      prefix: const Icon(
        Icons.search,
        color: AppColors.input_iconDefault,
      ),
      focusNode: _focusNode,
      suffix: InkWell(
        onTap: () {
          _focusNode.unfocus();
          WorkspaceAssociateDialog.show(
            context,
            callBack: (p0) async {
              _productSelectionBloc.wsAssociate = p0;
              setState(() {
                _isRefresh = true;
              });
              await Future.delayed(const Duration(milliseconds: 100));
              setState(() {
                _isRefresh = false;
              });
            },
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const VerticalDivider(
              color: AppColors.input_borderDefault,
              thickness: 1,
              width: 0,
            ).size(height: 48),
            Padding(
              padding: 1.pading,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: sp8),
                decoration: const BoxDecoration(
                  color: AppColors.bg_secondary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(999),
                    bottomRight: Radius.circular(999),
                  ),
                ),
                height: 48,
                width: 100,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text(
                      'Mặc định',
                      style: s12w500.copyWith(color: AppColors.text_primary),
                    ),
                    sp8.width,
                    FaIcon(iconCode: 'f364', type: FaIconType.solid),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _buildList {
    return BlocBuilder<ProductSelectionBloc, CubitState>(
      bloc: _productSelectionBloc,
      builder: (context, state) {
        return ListView.separated(
          itemCount: _productSelectionBloc.list.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Slidable(
              key: Key(_productSelectionBloc.list[index].id.toString()),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    flex: 1,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    onPressed: (context) =>
                        _productSelectionBloc.removeProduct(index),
                    backgroundColor: AppColors.ultility_negative_60,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Xóa',
                  ),
                ],
              ),
              child: ProductOrderItem(
                bloc: _productSelectionBloc,
                model: _productSelectionBloc.list[index],
                onUpdate: (model) => _productSelectionBloc.addProduct(model),
                onDelete: () => _productSelectionBloc.removeProduct(index),
                ghiChu: true,
                isCheckStock: false,
              ),
            );
          },
          separatorBuilder: (context, index) => 8.height,
        );
      },
    );
  }

  Container get _buildHuongDan {
    return Container(
      padding: 8.padingVer + 12.padingHor,
      decoration: BoxDecoration(
        color: AppColors.bg_secondary,
        borderRadius: 8.radius,
      ),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Trượt sang trái để xem thêm',
                  style: AppStyle.bodySmRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
                TextSpan(
                  text: '  Tùy chọn',
                  style: AppStyle.bodyBsMedium.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
              ],
            ),
          ).expanded(),
          FaIcon(iconCode: 'f323', type: FaIconType.solid),
        ],
      ),
    );
  }
}
