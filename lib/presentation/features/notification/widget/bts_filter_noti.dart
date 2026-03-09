import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/features/notification/cubit/notification_manager_cubit/notification_manager_cubit.dart';

import '../../../base/date.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';

enum FilterType {
  all('Toàn bộ'),
  specificDay('Ngày cụ thể'),
  rangeTime('Khoảng thời gian');

  const FilterType(this.title);

  final String title;
}

class BtsFilterNotification extends StatefulWidget {
  const BtsFilterNotification({required this.myBloc, super.key});

  final NotificationManagerCubit myBloc;

  @override
  State<BtsFilterNotification> createState() => _BtsFilterNotificationState();
}

class _BtsFilterNotificationState extends State<BtsFilterNotification> {
  FilterType? type = FilterType.all;

  late TextEditingController _specificDayController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    _specificDayController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _specificDayController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationManagerCubit>(
      create: (context) => widget.myBloc,
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Đặt lại', style: p3.copyWith(color: green_1)),
                Text('Bộ lọc', style: p3.copyWith(color: blackColor)),
                InkWell(
                  onTap: () {
                    if (_canApply()) {
                      if (type == FilterType.all) {
                        widget.myBloc.setFilter(FilterType.all);
                      }
                      if (type == FilterType.specificDay) {
                        widget.myBloc.setFilter(
                          FilterType.specificDay,
                        );
                      }
                      if (type == FilterType.rangeTime) {
                        widget.myBloc.setFilter(
                          FilterType.rangeTime,
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Áp dụng',
                    style:
                        p3.copyWith(color: _canApply() ? green_1 : blackColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                FilterType.all.title,
                style: type == FilterType.all
                    ? p3.copyWith(color: green_1)
                    : p3.copyWith(color: blackColor),
              ),
              leading: Radio<FilterType>(
                value: FilterType.all,
                groupValue: type,
                activeColor: green_1,
                onChanged: (FilterType? value) {
                  setState(() {
                    type = value;
                    _specificDayController.clear();
                    _startDateController.clear();
                    _endDateController.clear();
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                FilterType.specificDay.title,
                style: type == FilterType.specificDay
                    ? p3.copyWith(color: green_1)
                    : p3.copyWith(color: blackColor),
              ),
              leading: Radio<FilterType>(
                value: FilterType.specificDay,
                groupValue: type,
                activeColor: green_1,
                onChanged: (FilterType? value) {
                  setState(() {
                    type = value;
                    _specificDayController.clear();
                    _startDateController.clear();
                    _endDateController.clear();
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: sp16),
              child: Visibility(
                visible: type == FilterType.specificDay,
                child: AppInputSupport(
                  controller: _specificDayController,
                  hintText: 'Chọn ngày',
                  backgroundColor: whiteColor,
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                  readOnly: true,
                  onTap: () {
                    _showDatePicker(context, _specificDayController);
                  },
                ),
              ),
            ),
            ListTile(
              title: Text(
                FilterType.rangeTime.title,
                style: type == FilterType.rangeTime
                    ? p3.copyWith(color: green_1)
                    : p3.copyWith(color: blackColor),
              ),
              leading: Radio<FilterType>(
                value: FilterType.rangeTime,
                groupValue: type,
                activeColor: green_1,
                onChanged: (FilterType? value) {
                  setState(() {
                    type = value;
                    _specificDayController.clear();
                    _startDateController.clear();
                    _endDateController.clear();
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: sp16),
              child: Visibility(
                visible: type == FilterType.rangeTime,
                child: Row(
                  children: [
                    Expanded(
                      child: AppInputSupport(
                        controller: _startDateController,
                        hintText: 'Từ ngày',
                        backgroundColor: whiteColor,
                        suffixIcon: const Icon(Icons.calendar_month_outlined),
                        readOnly: true,
                        onTap: () {
                          _showDatePicker(context, _startDateController);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppInputSupport(
                        controller: _endDateController,
                        hintText: 'Đến ngày',
                        backgroundColor: whiteColor,
                        suffixIcon: const Icon(Icons.calendar_month_outlined),
                        readOnly: true,
                        onTap: () {
                          _showDatePicker(context, _endDateController);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, TextEditingController controller) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: (controller == _endDateController)
          ? (_startDateController.text.isNotEmpty
              ? widget.myBloc.state.startDate ?? DateTime(2000)
              : DateTime(2000))
          : DateTime(2000),
      lastDate: (controller == _startDateController)
          ? (_endDateController.text.isNotEmpty
              ? widget.myBloc.state.endDate ?? DateTime(2100)
              : DateTime(2100))
          : DateTime(2100),
    ).then((value) {
      if (value != null) {
        controller.text = Date.formatDateDay(value);
        if (controller == _startDateController) {
          widget.myBloc.setStartDate(value);
        }
        if (controller == _endDateController) {
          widget.myBloc.setEndDate(value);
        }
        if (controller == _specificDayController) {
          widget.myBloc.setSpecificDay(value);
        }
        setState(() {});
      }
    });
  }

  bool _canApply() {
    if (type == FilterType.all) {
      return true;
    }
    if (type == FilterType.specificDay) {
      return _specificDayController.text.isNotEmpty;
    }
    if (type == FilterType.rangeTime) {
      return _startDateController.text.isNotEmpty &&
          _endDateController.text.isNotEmpty;
    }
    return false;
  }
}
