import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/input/custom_drop_down.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/bg/bg_bts.dart';
import '../../../../../../shared/components/input/app_input.dart';
import '../../../../../../shared/components/widgets/filter_item.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../blocs/event/reminder_bloc.dart';

enum TimeReminderEnum {
  MINUTES('Phút'),
  HOURS('Giờ'),
  DAYS('Ngày');

  final String title;
  const TimeReminderEnum(this.title);

  static TimeReminderEnum fromCode(String code) {
    return TimeReminderEnum.values.firstWhere(
      (value) => value.name == code,
      orElse: () => MINUTES,
    );
  }

  String get code {
    return switch (this) {
      TimeReminderEnum.MINUTES => 'MINUTE',
      TimeReminderEnum.HOURS => 'HOUR',
      TimeReminderEnum.DAYS => 'DAY',
    };
  }
}

class BtsReminderEvent extends StatefulWidget {
  final List<ReminderModel>? list;
  final String? description;
  final DateTime dateTime;
  const BtsReminderEvent({
    this.list,
    this.description,
    required this.dateTime,
  });
  @override
  State<BtsReminderEvent> createState() => _BtsReminderEventState();
}

class _BtsReminderEventState extends State<BtsReminderEvent> {
  final _bloc = ReminderBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.filterData(widget.dateTime);
    if (widget.list.validator.isNotEmpty) {
      _bloc.defaultData = widget.list!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderBloc, CubitState>(
      bloc: _bloc,
      builder: (context, state) {
        return BgBts(
          label: 'Nhắc hẹn',
          confirmText: 'Xác nhận',
          onConfirm: _bloc.isActive
              ? () {
                  context.pop(
                    result: {
                      'list': _bloc.defaultData,
                      'description': _bloc.description,
                    },
                  );
                }
              : null,
          onCancel: () {
            _bloc.resetData();
            context.pop(
              result: {
                'list': _bloc.defaultData,
                'description': _bloc.description,
              },
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilterItem(
                label: 'Thời gian nhắc trước lịch',
                items: _bloc.defaultData
                    .map((e) => '${e.count} ${e.type.title}')
                    .toList(),
                select: _bloc.index,
                chooseList: _bloc.defaultData.map((e) => e.isChoose).toList(),
                onTap: (p0) {
                  _bloc.setChoose(p0);
                },
              ),
              //16.height,
              // ...List.generate(
              //   _bloc.list.length,
              //   (index) => _buildInput(
              //     item: _bloc.list[index],
              //     onChangedCount: (p0) {
              //       _bloc.list[index].count = int.tryParse(p0 ?? '') ?? 0;
              //       _bloc.updateReminder(index, _bloc.list[index]);
              //     },
              //     onChangedType: (p0) {
              //       _bloc.list[index].type = p0!;
              //       _bloc.updateReminder(index, _bloc.list[index]);
              //     },
              //   ).padding(16.padingBottom),
              // ),
              // ChipDashBorder(
              //   onTap: () {
              //     _bloc.addReminder(
              //       ReminderModel(count: 0, type: TimeReminderEnum.DAYS),
              //     );
              //   },
              //   color: AppColors.text_secondary,
              //   title: 'Thêm thời gian',
              //   padding: 6.pading,
              //   titleStyle: AppStyle.bodyBsMedium.copyWith(
              //     color: AppColors.text_secondary,
              //   ),
              //   suffixIcon: const Icon(
              //     Icons.add,
              //     size: 16,
              //     color: AppColors.text_secondary,
              //   ),
              // ),
              24.height,
              InputColumn(
                label: 'Lời nhắn',
                minLines: 5,
                padding: 0.pading,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
                initialValue: widget.description,
                onChanged: _bloc.setDescription,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInput({
    Function(TimeReminderEnum?)? onChangedType,
    Function(String?)? onChangedCount,
    required ReminderModel item,
  }) {
    return Row(
      children: [
        const Icon(
          Icons.radio_button_checked,
          color: AppColors.ultility_blue,
        ),
        10.width,
        AppInputV2(
          hintText: 'Nhập giá trị',
          radius: 8,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(5),
          ],
          textInputType: TextInputType.number,
          initialValue: '${item.count > 0 ? item.count : ''}',
          onChanged: onChangedCount,
          suffixIcon: _chooseType(
            onChanged: onChangedType,
            value: item.type,
          ),
        ).expanded(),
      ],
    );
  }

  Widget _chooseType({
    Function(TimeReminderEnum?)? onChanged,
    TimeReminderEnum? value,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColors.input_borderDefault),
        ),
      ),
      child: CustomDropDown<TimeReminderEnum>(
        items: List.generate(
          TimeReminderEnum.values.length,
          (index) => DropdownMenuItem(
            value: TimeReminderEnum.values[index],
            child: Text(
              TimeReminderEnum.values[index].title,
            ),
          ),
        ),
        value: value,
        onChanged: onChanged,
        hintText: 'Chọn',
        showIconRemove: false,
        contentPadding: 12.padingVer,
        borderRadius: 8.radiusRight,
        borderColor: AppColors.input_borderDefault,
        isBorder: false,
        icon: FaIcon(
          iconCode: 'f0d7',
          type: FaIconType.solid,
        ),
      ).size(width: 100, height: 48),
    );
  }
}


// Container(
//       margin = 1.pading,
//       decoration = BoxDecoration(
//         borderRadius: 8.radiusRight,
//         color: AppColors.bg_secondary,
//         border: const Border(
//           left: BorderSide(color: AppColors.input_borderDefault),
//         ),
//       ),
//       child = Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'Ngày',
//             style: AppStyle.bodyBsRegular,
//           ),
//           4.width,
//           FaIcon(
//             iconCode: 'f0d7',
//             type: FaIconType.solid,
//           ),
//         ],
//       ).padding(12.padingHor),
//     )