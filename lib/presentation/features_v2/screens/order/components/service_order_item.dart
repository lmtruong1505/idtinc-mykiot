import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../../../shared/components/input/input_qty.dart';
import '../../../../../shared/constants/pref_key.dart';
import '../../../../base/select.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../blocs/event/list_staff_bloc.dart';
import '../../../blocs/order_v2/product_selection_bloc.dart';
import '../../../models/employee/pre_emp_model.dart';
import '../../../models/service/service.dart';
import '../../product/components/bts_chose_product.dart';

class ServiceOrderItem extends StatefulWidget {
  const ServiceOrderItem({
    super.key,
    required this.model,
    required this.empBloc,
    this.onUpdate,
    this.proBloc,
  });

  final ServiceV2Model model;
  final Function(
    ServiceV2Model item, {
    int? quantity,
    num? price,
    PreEmpModel? employee,
  })? onUpdate;
  final ListStaffServiceBloc empBloc;
  final ProductSelectionBloc? proBloc;

  @override
  State<ServiceOrderItem> createState() => _ServiceOrderItemState();
}

class _ServiceOrderItemState extends State<ServiceOrderItem> {
  final amountTec = TextEditingController();

  @override
  void initState() {
    amountTec.text = widget.model.quantity.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        border: Border.all(color: borderColor_2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: sp4,
          horizontal: sp12,
        ),
        leading: Image.network(
          (widget.model.images?.length ?? 0) > 0
              ? widget.model.images!.first
              : PrefKeys.imgProductDefault,
        ),
        title: Text(widget.model.title ?? '', style: p7),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${FormatCurrency(widget.model.priceCustom?.price ?? widget.model.price?.price)} đ',
                  style: p5.copyWith(
                    color: mainColor,
                  ),
                ),
                Visibility(
                  visible: widget.model.discount > 0,
                  child: Text(
                    ' - ${FormatCurrency(widget.model.discount)}đ ',
                    style: p9.copyWith(
                      color: greyTextColor,
                    ),
                  ),
                ),
                Text(
                  '/${widget.model.price?.priceNameSub}',
                  style: p9.copyWith(color: greyTextColor),
                ),
              ],
            ),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InputQuantity(
                  controller: amountTec,
                  action: (value) => update(value),
                  onChanged: (value) {
                    widget.onUpdate?.call(
                      widget.model,
                      quantity: value,
                    );
                  },
                ).expanded(),
                16.width,
                Expanded(
                  flex: 1,
                  child: Visibility(
                    visible: widget.model.relatedProd > 0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _addProd,
                    ),
                  ),
                ),
              ],
            ),
            8.height,
            _buildSearchEmployee,
          ],
        ),
      ),
    );
  }

  Widget get _addProd {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(sp12),
            ),
          ),
          builder: (context) => BtsChoseProduct(
            services: [widget.model.id!],
            initData: widget.proBloc?.list,
            onConfirm: (value) {
              for (final item in value) {
                widget.proBloc?.addProduct(item);
              }
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: sp8, horizontal: sp8),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor_2),
          borderRadius: BorderRadius.circular(sp8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: sp16),
            4.width,
            const Text('SP', style: p5),
          ],
        ),
      ),
    );
  }

  void update(bool isPlus) {
    int amount = int.tryParse(amountTec.text) ?? 0;
    if (isPlus) {
      amount++;
    } else if (!isPlus && amount > 1) {
      amount--;
    }
    amountTec.text = amount.toString();

    widget.onUpdate?.call(widget.model, quantity: int.tryParse(amountTec.text));
  }

  Widget get _buildSearchEmployee {
    final item = widget.empBloc.list
        .firstWhereOrNull((e) => e.employee == widget.model.employee?.employee);
    return CommonDropdown<PreEmpModel>(
      value: item,
      items: List.generate(
        widget.empBloc.list.length,
        (index) => DropdownMenuItem(
          value: widget.empBloc.list[index],
          child: Text(
            widget.empBloc.list[index].userData?.fullName ?? '',
            style: AppStyle.bodyBsRegular,
          ),
        ),
      ),
      onChanged: (value) {
        widget.onUpdate?.call(widget.model, employee: value);
      },
      hintText: 'Chọn người thực hiện',
      required: true,
      height: sp28,
      borderColor: borderColor_3,
    );
  }
}
