import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/event/list_event_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/employee/user_data_model.dart';
import 'package:pharmago/presentation/features_v2/models/event/create_event_model.dart';
import 'package:pharmago/presentation/features_v2/models/event/reminder_event_model.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../gen/flutter_assets.dart';
import '../../../../shared/components/toast/toast_custom.dart';
import '../../../base/dialog.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../models/customer/v2/customer_model.dart';
import '../../models/employee/pre_emp_model.dart';
import '../../models/event/detail_event_model.dart';
import '../../models/service/service.dart';
import '../../repositories/events/event_v2_repository.dart';
import '../state/init_state.dart';
import 'reminder_bloc.dart';

class CreateEventV2Bloc extends Cubit<CubitState> {
  CreateEventV2Bloc() : super(CubitState());
  final _blocReminder = ReminderBloc();
  final _repo = EventV2Repository();
  int? idEvent;
  int? companyId = getCompanyId;

  void initEditData({
    required DetailEventV2Model event,
  }) {
    idEvent = event.id;
    customerData = event.customer;

    for (final ServicesEvent element in event.services ?? []) {
      if (element.serviceData != null) {
        final service = element.serviceData;
        service?.employee = PreEmpModel(
          employee: element.employeeData?.id,
          userData: UserDataModel(
            fullName: element.employeeData?.fullName,
          ),
        );
        service?.serviceEventId = element.id;
        listService.add(service!);
      }
    }
    _dateTime = event.meetingAt;

    listReminder = _blocReminder.defaultData;

    for (int i = 0; i < listReminder.length; i++) {
      for (final ReminderEventModel element in event.reminders ?? []) {
        _description = element.message;
        if (listReminder[i].count == element.quantity &&
            element.unit == listReminder[i].type.name) {
          listReminder[i].isChoose = true;
        }
      }
    }

    emit(state.copyWith(status: BlocStatus.success));
  }

  int _indexTab = 0;
  int get indexTab => _indexTab;

  set indexTab(int index) {
    _indexTab = index;
    emit(state.copyWith(status: BlocStatus.success));
  }

  bool get isActive =>
      _dateTime != null && customerData != null && listService.isNotEmpty;

  bool _isNextTab = false;
  bool get isNextTab => _isNextTab;

  DateTime? _dateTime;
  DateTime? get dateTime => _dateTime;

  set dateTime(DateTime? value) {
    _dateTime = value;
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  String? _description;
  String? get description => _description;
  set description(String? value) {
    _description = value;
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  List<ReminderModel> listReminder = [];
  bool get isReminder => listReminder.map((e) => e.isChoose).contains(true);

  CustomerV2Model? customerData;
  List<ServiceV2Model> listService = [];

  setListReminder(List<ReminderModel> value) {
    listReminder = value;
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  checkData(CustomerV2Model? customer, List<ServiceV2Model> list) {
    _isNextTab = customer?.phone != null &&
        list.isNotEmpty &&
        !list.map((e) => e.employee?.employee != null).toList().contains(false);
    customerData = customer;
    listService = list;
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  create(
    BuildContext context, {
    bool? send_zns,
  }) async {
    DialogUtils.showLoadingDialog(
      context,
      'Đang tải...',
    );
    final remindersData =
        listReminder.where((element) => element.isChoose).toList();

    final param = CreateEventV2Model(
      id: idEvent,
      company: companyId,
      send_zns: send_zns,
      customerId: customerData?.id,
      customerName: customerData?.fullName,
      customerPhone: customerData?.phone,
      meetingAt: dateTime?.fomatCustom(fomat: 'yyyy-MM-dd HH:mm'),
      services: listService
          .map(
            (e) => ServicesEventModel(
              employeeId: e.employee?.employee,
              serviceId: e.id,
              id: e.serviceEventId,
              priceId: e.price?.id,
            ),
          )
          .toList(),
      reminders: remindersData
          .map(
            (e) => Reminders(
              message: description,
              quantity: e.count,
              unit: e.type.name,
            ),
          )
          .toList(),
    );
    print('_________');
    print(param.toJson());
    print('_________');
    final res = await _repo.create(param);
    context.pop();

    if (res.code == 200) {
      getIt<ListEventV2Bloc>().getList();
      context.router.popUntil(
        (route) =>
            route.settings.name == ListEventRoute.name ||
            route.settings.name == HomeRoute.name,
      );

      ToastCustom.show(
        context,
        title: 'Thành công',
        msg: '${idEvent == null ? 'Tạo' : "Cập nhật"} lịch hẹn thành công',
        svgIcon: Assets.svgSuccess,
        color: AppColors.ultility_positive_60,
        route: res.data is int ? DetailEventV2Route(id: res.data!) : null,
      );
    } else {
      ToastCustom.show(
        context,
        title: 'Lỗi',
        msg: res.message ??
            '${idEvent == null ? 'Tạo' : "Cập nhật"} lịch hẹn không thành công',
        svgIcon: Assets.svgError,
        color: AppColors.ultility_negative_60,
      );
    }
  }
}
