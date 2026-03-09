import 'package:flutter/material.dart';

import '../../../base/date.dart';
import '../../../base/dialog.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/batch_create_cubit.dart';
import '../domain/entities/batch_entity.dart';

class FormAddConsignment extends StatefulWidget {
  const FormAddConsignment({
    super.key,
    required this.item,
    required this.index,
    required this.myBloc,
  });

  final BatchEntity item;
  final int index;
  final BatchCreateCubit myBloc;

  @override
  State<FormAddConsignment> createState() => _FormAddConsignmentState();
}

class _FormAddConsignmentState extends State<FormAddConsignment> {
  final curency = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
      margin: const EdgeInsets.only(bottom: sp16),
      width: widthDevice(context),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(sp12)),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            offset: const Offset(1, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Thông tin lô ${widget.index + 1}', style: p3),
          ),
          gapHeight(sp12),
          Row(
            children: [
              Expanded(
                child: AppInput(
                  label: 'Mã lô',
                  hintText: 'Nhập mã lô',
                  initialValue: widget.item.code,
                  backgroundColor: bg_5,
                  borderColor: bg_5,
                  onChanged: (value) =>
                      widget.myBloc.changeCode(widget.index, value),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.1),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => DialogUtils.showErrorDialog(
                  context,
                  titleConfirm: 'Xác nhận',
                  accept: () {
                    Navigator.of(context).pop();
                    widget.myBloc.removeBatch(widget.item);
                  },
                  close: () => Navigator.of(context).pop(),
                  content: 'Xác nhận xoá lô sản phẩm??',
                ),
                child: Container(
                  padding: const EdgeInsets.all(sp16),
                  margin: const EdgeInsets.fromLTRB(sp12, sp0, sp0, sp0),
                  decoration: const BoxDecoration(
                    color: red_2,
                    borderRadius: BorderRadius.all(Radius.circular(sp12)),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.delete_outline,
                    size: sp20,
                    color: red_1,
                  ),
                ),
              ),
            ],
          ),
          gapHeight(sp16),
          Row(
            children: [
              _oneDate(
                'Ngày sản xuất',
                widget.item.productionDate,
                (value) =>
                    widget.myBloc.changeProductionDate(widget.index, value),
              ),
              gapWidth(sp16),
              _oneDate(
                'Hạn sử dụng',
                widget.item.expiry,
                (value) => widget.myBloc.changeExpiry(widget.index, value),
              ),
            ],
          ),
          gapHeight(sp16),
          Material(
            elevation: 0.5,
            borderRadius: BorderRadius.circular(sp12),
            child: InputCurrency(
              controller: curency,
              label: 'Số lượng',
              hintText: 'Nhập số lượng',
              initialValue: widget.item.amount,
              backgroundColor: bg_5,
              borderColor: bg_5,
              onChanged: (value) =>
                  widget.myBloc.changeAmount(widget.index, value),
              required: true,
              validate: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Vui lòng nhập số lượng';
                }
                return null;
              },
              suffixIcon: const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _oneDate(String label, DateTime? value, ValueChanged changeDate) =>
      Expanded(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(label, style: p5.copyWith(color: blackColor)),
            ),
            gapHeight(sp8),
            InkWell(
              onTap: () async {
                final dates = await DialogUtils.showCalendarDatePicker(context);
                if (dates != null) changeDate(dates[0]!);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp12,
                  horizontal: sp16,
                ),
                decoration: BoxDecoration(
                  color: bg_5,
                  border: Border.all(color: bg_5),
                  borderRadius: BorderRadius.circular(sp8),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.2),
                      blurRadius: sp2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value == null ? 'Ngày' : Date.formatDateDay(value),
                        style: p6.copyWith(color: blackColor),
                      ),
                    ),
                    gapWidth(sp12),
                    const Icon(
                      Icons.calendar_month,
                      size: sp20,
                      color: greyColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
