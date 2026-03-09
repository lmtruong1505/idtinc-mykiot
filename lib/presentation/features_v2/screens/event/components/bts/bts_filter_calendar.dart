import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/gen/flutter_assets.dart';

import 'package:pharmago/presentation/features_v2/blocs/enum/enum_calendar_time.dart';
import 'package:pharmago/presentation/features_v2/blocs/event/list_staff_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/employee/pre_emp_model.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/filter_item.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/input/range_input.dart';
import '../../../../../../shared/components/widgets/range_date_custom.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../blocs/date_time/date_time_bloc.dart';
import '../../../../blocs/date_time/param_date.dart';
import '../../../../models/employee/working_data_model.dart';

class BtsFilterEvent extends StatefulWidget {
  final ParamDate? dateRang;
  final EnumCalendarTime? status;
  final PreEmpModel? doctor;
  final int? companyId;
  final int? doctorId;
  final List<WorkingDataModel>? workingData;
  final Function(
    ParamDate? dateRang,
    EnumCalendarTime? status,
    PreEmpModel? doctor,
    int? companyId,
  )? onChanged;

  const BtsFilterEvent({
    super.key,
    this.dateRang,
    this.status,
    this.doctor,
    this.onChanged,
    this.doctorId,
    this.workingData,
    this.companyId,
  });

  @override
  State<BtsFilterEvent> createState() => _BtsFilterEventState();
}

class _BtsFilterEventState extends State<BtsFilterEvent> {
  int doctorIndex = 0;
  int statusIndex = 0;
  int dateRangeIndex = 0;
  int companyIndex = 0;

  final startCtl = TextEditingController();
  final endCtl = TextEditingController();
  final _empBloc = ListStaffServiceBloc();
  final listDateEnum = DateRangeEnum.values
      .where((element) => !element.val.contains('last'))
      .toList();
  final _dateBloc = DateTimeBloc();

  bool get isOption =>
      dateRangeIndex == listDateEnum.indexOf(DateRangeEnum.option);

  final now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _empBloc.getList();
    if (widget.dateRang != null) {
      dateRangeIndex = listDateEnum.indexOf(widget.dateRang!.dateRange!);
      paramDate = widget.dateRang;
    }

    if (widget.status != null) {
      statusIndex = widget.status!.index;
    }
    if (widget.companyId != null && widget.workingData != null) {
      companyIndex = widget.workingData!
              .indexWhere((element) => element.id == widget.companyId) +
          1;
    }
  }

  ParamDate? paramDate;

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Bộ lọc',
      onCancel: () {
        widget.onChanged?.call(
          null,
          null,
          null,
          null,
        );
        context.pop();
      },
      onConfirm: () {
        if (isOption &&
            (paramDate?.endDate == null || paramDate?.startDate == null)) {
          ToastCustom.show(
            context,
            title: 'Cảnh báo',
            msg: 'Vui lòng chọn khoảng thời gian',
            svgIcon: Assets.svgWarningOutline,
            color: AppColors.ultility_carrot_60,
          );
          return;
        }
        widget.onChanged?.call(
          paramDate,
          EnumCalendarTime.values[statusIndex],
          doctorIndex <= 0 ? null : _empBloc.list[doctorIndex - 1],
          companyIndex <= 0
              ? null
              : widget.workingData == null
                  ? null
                  : widget.workingData![companyIndex - 1].id,
        );
        context.pop();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.doctorId == null)
            BlocConsumer<ListStaffServiceBloc, CubitState>(
              bloc: _empBloc,
              listener: (context, state) {
                if (state.status == BlocStatus.success &&
                    widget.doctor != null) {
                  doctorIndex = _empBloc.list.indexWhere(
                        (element) => element.id == widget.doctor?.id,
                      ) +
                      1;
                }
              },
              builder: (context, state) {
                return FilterItem(
                  label: 'Người thực hiện',
                  onTap: (p0) {
                    doctorIndex = p0;
                    setState(() {});
                  },
                  select: doctorIndex,
                  items: [
                    'Tất cả',
                    ...List.generate(
                      _empBloc.list.length,
                      (index) => _empBloc.list[index].userData?.fullName ?? '',
                    ),
                  ],
                );
              },
            ),
          if (widget.doctorId == null) 16.height,
          FilterItem(
            label: 'Trạng thái lịch hẹn',
            onTap: (p0) {
              statusIndex = p0;
              setState(() {});
            },
            select: statusIndex,
            items: List.generate(
              EnumCalendarTime.values.length,
              (index) => EnumCalendarTime.values[index].title,
            ),
          ),
          16.height,
          FilterItem(
            label: 'Thời gian hẹn',
            onTap: (p0) {
              dateRangeIndex = p0;
              paramDate = _dateBloc.chooseBtn(listDateEnum[dateRangeIndex]);
              setState(() {});
            },
            select: dateRangeIndex,
            items: List.generate(
              listDateEnum.length,
              (index) => listDateEnum[index].title,
            ),
          ),
          if (isOption) ...[
            16.height,
            Text(
              'Chọn khoảng thời gian',
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.input_label,
              ),
            ),
            8.height,
            RangeInput(
              onChanged: (start, end) {},
              onTap: () {
                context
                    .bottomSheet(
                  RangeDateCustom(
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  ),
                )
                    .then(
                  (value) {
                    if (value is List<DateTime?>) {
                      paramDate?.startDate = value.first;
                      paramDate?.endDate = value.last;
                      startCtl.text = value.first.fomatDefaulft;
                      endCtl.text = value.last.fomatDefaulft;
                      setState(() {});
                    }
                  },
                );
              },
              readOnly: true,
              controller1: startCtl,
              controller2: endCtl,
              value1: paramDate?.startDate.fomatDefaulft,
              value2: paramDate?.endDate.fomatDefaulft,
              prefixIcon: const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.input_iconDefault,
                size: 17,
              ),
            ),
          ],
          if (widget.workingData != null) ...[
            16.height,
            FilterItem(
              label: 'Cơ sở',
              onTap: (p0) {
                companyIndex = p0;
                setState(() {});
              },
              select: companyIndex,
              items: [
                'Tất cả',
                ...List.generate(
                  widget.workingData!.length,
                  (index) =>
                      widget.workingData![index].company?.workspaceName ?? '',
                ),
              ],
            ),
            16.height,
          ],
        ],
      ),
    );
  }
}
