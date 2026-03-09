import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_calendar_time.dart';
import 'package:pharmago/presentation/features_v2/blocs/service/service_selection_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/event/reminder_event_model.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/selection/customer_selection.dart';
import 'package:pharmago/shared/components/bg/bg_btn_nav_bar.dart';
import 'package:pharmago/shared/components/button/double_button.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/dialog/dialog_date_time.dart';
import 'package:pharmago/shared/components/dialog/dialog_message.dart';
import 'package:pharmago/shared/components/widgets/progess_stepper.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/dialog/dialog_confirm.dart';
import '../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../../shared/components/widgets/chip_custom.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../router/router.gr.dart';
import '../../blocs/event/create_event_bloc.dart';
import '../../blocs/event/list_staff_bloc.dart';
import '../../blocs/order_v2/customer_selection_bloc.dart';
import '../../models/event/detail_event_model.dart';
import 'components/bts/bts_reminder_event.dart';
import 'components/reminder_zalo_event.dart';
import 'components/service_select_event.dart';

@RoutePage()
class CreateEventV2Page extends StatefulWidget {
  final DetailEventV2Model? event;
  final int? companyId;
  final int? employeeId;
  const CreateEventV2Page({
    super.key,
    this.event,
    this.companyId,
    this.employeeId,
  });

  @override
  State<CreateEventV2Page> createState() => _CreateEventV2PageState();
}

class _CreateEventV2PageState extends State<CreateEventV2Page> {
  final _bloc = CreateEventV2Bloc();
  final _empBloc = ListStaffServiceBloc();
  final customerBloc = CustomerSelectionBloc();
  final serviceBloc = ServiceSelectionEventBloc();

  setDateTime() {
    context
        .dialog(
      DialogDateTime(
        dateTime: _bloc.dateTime,
      ),
    )
        .then(
      (value) {
        if (value is DateTime) {
          _bloc.dateTime = value;
        }
      },
    );
  }

  setReminder() {
    context
        .bottomSheet(
      BtsReminderEvent(
        list: _bloc.listReminder,
        description: _bloc.description,
        dateTime: _bloc.dateTime!,
      ),
    )
        .then((value) {
      if (value is Map) {
        _bloc.description = value['description'];
        _bloc.setListReminder(value['list']);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _empBloc.getList();
    if (widget.event != null) {
      _bloc.initEditData(event: widget.event!);
      customerBloc.model = _bloc.customerData;
    }
    if (widget.companyId != null) {
      _bloc.companyId = widget.companyId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CustomerSelectionBloc, CubitState>(
          bloc: customerBloc,
          listener: (context, state) {
            if (state.status == BlocStatus.success) {
              _bloc.checkData(customerBloc.model, serviceBloc.list);
            }
          },
        ),
        BlocListener<ServiceSelectionEventBloc, CubitState>(
          bloc: serviceBloc,
          listener: (context, state) {
            if (state.status == BlocStatus.success) {
              _bloc.checkData(customerBloc.model, serviceBloc.list);
            }
          },
        ),
        BlocListener<ListStaffServiceBloc, CubitState>(
          bloc: _empBloc,
          listener: (context, state) {
            if (state.status == BlocStatus.success) {
              serviceBloc.addAll(_bloc.listService);
            }
          },
        ),
      ],
      child: BlocBuilder<CreateEventV2Bloc, CubitState>(
        bloc: _bloc,
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              context.unFocus();
            },
            child: Scaffold(
              appBar: AppBarTitleCenter(
                title: widget.event == null
                    ? 'Tạo mới lịch khám'
                    : 'Cập nhật lịch hẹn',
                actions: [
                  GestureDetector(
                    onTap: () {
                      context.router.push(MedicalScheduleEditorRoute());
                    },
                    child: const Icon(
                      Icons.vaccines_rounded,
                    ),
                  ),
                  sp16.width,
                ],
              ),
              bottomNavigationBar: _buildBtnBar(),
              body: SingleChildScrollView(
                padding: 16.pading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStepper(),
                    32.height,
                    _bloc.indexTab == 0 ? _buildChooseData() : _buildTime(),
                    context.padding.bottom.height,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBtnColumn(
          title: 'Ngày hẹn',
          onTap: setDateTime,
          reChoose: setDateTime,
          child: _bloc.dateTime != null ? _buildDateTime() : null,
        ),
        24.height,
        if (_bloc.dateTime != null)
          _buildBtnColumn(
            title: 'Nhắc hẹn',
            onTap: setReminder,
            reChoose: setReminder,
            child: !_bloc.isReminder ? null : _buildReminder(),
          ),
      ],
    );
  }

  Widget _buildDateTime() {
    return Row(
      children: [
        FaIcon(iconCode: 'f133', size: 20),
        Text(
          '${_bloc.dateTime.formatDayOfWeek}, ${_bloc.dateTime.fomatDefaulft}    ${_bloc.dateTime.fomatCustom(fomat: "HH:mm")}',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppStyle.bodyBsSemiBold,
        ).padding(12.padingHor).expanded(),
      ],
    ).container(
      padding: 12.pading,
      radius: 12,
      border: Border.all(color: AppColors.border_tertiary),
      bgColor: AppColors.bg_secondary_subtle,
    );
  }

  Widget _buildReminder() {
    final reminderData = _bloc.listReminder
        .where((element) => element.isChoose)
        .map(
          (e) => ReminderEventModel(
            quantity: e.count,
            unit: e.type.name,
          ),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridView.count(
          crossAxisCount: ((context.width - 46) / 110).floor(),
          shrinkWrap: true,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            reminderData.length,
            (index) => ReminderZalo(
              reminderData[index],
            ),
          ),
        ),
        12.height,
        Text(
          'Lời nhắn',
          style: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_secondary,
          ),
        ),
        2.height,
        Text(
          _bloc.description.isEmptyOrNull
              ? 'Không có ghi chú'
              : _bloc.description!,
          style: _bloc.description.isEmptyOrNull
              ? AppStyle.bodyBsRegular.copyWith(color: AppColors.text_disable)
              : AppStyle.bodyBsMedium,
        ),
      ],
    );
  }

  Widget _buildBtnColumn({
    required String title,
    required Function() onTap,
    Function()? reChoose,
    Widget? child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: AppStyle.headingLg,
            ).expanded(),
            if (child != null)
              ChipCustom(
                color: AppColors.button_neutral_alpha_textDefault,
                isBorder: false,
                title: 'Chọn lại',
                padding: 12.padingHor + 6.padingVer,
                onTap: reChoose,
              ),
          ],
        ),
        8.height,
        if (child == null)
          LabelButton(
            onPressed: onTap,
            label: 'Cấu hình',
            suffixIcon: FaIcon(
              iconCode: 'f013',
              color: AppColors.button_neutral_solid_iconDefault,
            ),
            backgroundColor: AppColors.button_neutral_solid_backgroundDefault,
          ).size(height: 32),
        if (child != null) child,
      ],
    );
  }

  Widget _buildChooseData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomerSelection(
          bloc: customerBloc,
          type: 'IDENTIFIED',
          isEvent: true,
        ),
        24.height,
        ServiceSelectionEvent(
          bloc: serviceBloc,
          employees: _empBloc.list,
        ),
        (context.height * 0.4).height,
      ],
    );
  }

  Widget _buildStepper() {
    return ProgessStepper(
      steps: const [
        'Thông tin lịch hẹn',
        'Chọn lịch hẹn',
      ],
      current: _bloc.indexTab,
    ).container(
      radius: 12,
      bgColor: AppColors.bg_secondary_subtle,
    );
  }

  Widget _buildBtnBar() {
    return BgBtnNavBar(
      child: DoubleButton(
        confirmText: _bloc.indexTab == 0 ? 'Tiếp tục' : 'Xác nhận',
        cancelText: _bloc.indexTab == 0 ? 'Huỷ bỏ' : 'Trở về',
        onCancel: () {
          if (_bloc.indexTab == 0) {
            context.pop();
            return;
          } else {
            _bloc.indexTab = 0;
          }
        },
        onConfirm: !_bloc.isNextTab && _bloc.indexTab == 0
            ? null
            : !_bloc.isActive && _bloc.indexTab == 1
                ? null
                : () {
                    if (_bloc.indexTab == 1 && _bloc.isActive) {
                      if (widget.event != null) {
                        context.dialog(
                          DialogConfirm(
                            title: 'Cảnh báo',
                            closeLabel: 'Để sau',
                            confirmLabel: 'Đồng ý',
                            close: () {
                              context.pop();
                              _bloc.create(context, send_zns: false);
                            },
                            confirm: () {
                              context.pop();
                              _bloc.create(context, send_zns: true);
                            },
                            content: Text(
                              widget.event?.status ==
                                      EnumCalendarTime.canceled.code
                                  ? messageCancelEdit
                                  : messageConfimrmEdit,
                              textAlign: TextAlign.center,
                              style: AppStyle.bodyBsRegular.copyWith(
                                color: AppColors.text_secondary,
                              ),
                            ),
                            icon: IconDiaLog(
                              color: AppColors.bg_warningPrimary,
                              icon: FaIcon(
                                iconCode: 'f071',
                                color: AppColors.ultility_carrot_60,
                                type: FaIconType.solid,
                                size: 24,
                              ),
                            ),
                          ),
                        );
                      } else {
                        _bloc.create(context);
                      }
                      // create
                    } else {
                      _bloc.indexTab = 1;
                    }
                  },
      ),
    );
  }

  final messageCancelEdit = 'Bạn đã cập nhật lại một lịch hẹn đã hủy!\n'
      'Bạn có muốn khôi phục lại lịch hẹn này không!';
  final messageConfimrmEdit = 'Bạn đã thay đổi thông tin lịch hẹn!\n'
      'Bạn có muốn gửi thông báo đến khách hàng không?';
}
