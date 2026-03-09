import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/double_button.dart';
import '../../../../../shared/components/input/input_column.dart';
import '../../../../../shared/components/widgets/filter_item.dart';
import '../../../../constants/spacing.dart';
import '../../../../features_v2/blocs/event/reminder_bloc.dart';
import '../../../../features_v2/screens/event/components/bts/bts_reminder_event.dart';

class SettingRemindDialog extends StatefulWidget {
  const SettingRemindDialog({
    super.key,
    this.data,
    this.note,
    this.callBack,
  });

  final List<ReminderModel>? data;
  final String? note;
  final Function(List<ReminderModel>?, String)? callBack;

  static void show(
    BuildContext context, {
    List<ReminderModel>? data,
    String? note,
    Function(List<ReminderModel>?, String)? callBack,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Card(
            margin: const EdgeInsets.all(sp16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(sp12),
            ),
            child: SettingRemindDialog(
              data: data,
              note: note,
              callBack: callBack,
            ),
          ),
        );
      },
    );
  }

  @override
  State<SettingRemindDialog> createState() => _SettingRemindDialogState();
}

class _SettingRemindDialogState extends State<SettingRemindDialog> {
  final List<ReminderModel> defaultData = [
    ReminderModel(count: 15, type: TimeReminderEnum.MINUTES),
    ReminderModel(count: 30, type: TimeReminderEnum.MINUTES),
    ReminderModel(count: 1, type: TimeReminderEnum.HOURS),
    ReminderModel(count: 1, type: TimeReminderEnum.DAYS),
  ];

  List<ReminderModel> data = [];
  String note = '';

  @override
  void initState() {
    super.initState();

    data = List.from(widget.data ?? []);
    note = widget.note ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(sp16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cài đặt nhắc hẹn',
                style: s18w700.copyWith(
                  color: AppColors.text_primary,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const CircleAvatar(
                  radius: sp16,
                  backgroundColor: AppColors.bg_disable,
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.icon_iconSecondary,
                    size: sp20,
                  ),
                ),
              )
            ],
          ),
          const Divider(height: sp32),
          FilterItem(
            label: 'Thời gian nhắc trước lịch',
            items:
                defaultData.map((e) => '${e.count} ${e.type.title}').toList(),
            chooseList: defaultData.map((e) => data.contains(e)).toList(),
            onTap: (index) {
              setState(() {
                final item = defaultData[index];
                if (data.contains(item)) {
                  data.remove(item);
                } else {
                  data.add(item);
                }
              });
            },
          ),
          sp24.height,
          InputColumn(
            label: 'Lời nhắn',
            minLines: 5,
            padding: 0.pading,
            inputFormatters: [
              LengthLimitingTextInputFormatter(100),
            ],
            initialValue: widget.note,
            onChanged: (value) {
              note = value;
            },
          ),
          sp16.height,
          DoubleButton(
            onCancel: () {
              context.pop();
            },
            onConfirm: () {
              Navigator.of(context).pop();
              widget.callBack?.call(data, note);
            },
          ).size(height: 32),
        ],
      ),
    );
  }
}
