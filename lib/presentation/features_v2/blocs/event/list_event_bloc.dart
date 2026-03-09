import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/features_v2/blocs/date_time/param_date.dart';
import 'package:pharmago/presentation/features_v2/models/employee/pre_emp_model.dart';
import 'package:pharmago/presentation/features_v2/models/event/filter_event_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../models/event/event_v2_mode.dart';
import '../../repositories/events/event_v2_repository.dart';
import '../enum/enum_calendar_time.dart';
import '../state/init_state.dart';

@Singleton()
class ListEventV2Bloc extends Cubit<CubitState> {
  ListEventV2Bloc() : super(CubitState());

  final _repo = EventV2Repository();

  final List<EventV2Model> list = [];

  init({
    int? companyId,
    int? doctor,
    int? customer,
  }) {
    list.clear();
    param.search = null;
    param.status = null;
    param.dateRang = null;
    param.companyId = companyId ?? getCompanyId;
    param.customerId = customer;
    param.doctor = doctor != null ? PreEmpModel(id: doctor) : null;

    getList();
  }

  final FilterEventModel param = FilterEventModel(
    companyId: getCompanyId,
  );

  bool get isFilter =>
      param.doctor?.id != null ||
      param.status?.code.isEmptyOrNull == false ||
      param.dateRang?.dateRange?.name.isEmptyOrNull == false;

  search(String val) {
    param.search = val;
    getList();
  }

  updateFilter({
    ParamDate? dateRang,
    EnumCalendarTime? status,
    PreEmpModel? doctor,
    int? companyId,
  }) {
    param.dateRang = dateRang;
    param.status = status;
    param.doctor = doctor;
    param.companyId = companyId ?? getCompanyId;
    getList();
  }

  Future<void> getList({bool isMore = false}) async {
    if (isMore) {
      if (list.length < param.limit) {
        return;
      }
      param.page = param.page + 1;
    } else {
      param.page = 1;
      list.clear();
    }

    emit(state.copyWith(status: BlocStatus.loading));

    final res = await _repo.list(param);
    list.addAll(res.data ?? []);
    if (list.isEmpty && isMore) {
      param.page = param.page - 1;
    }

    final isFirst = list.isEmpty && !isFilter && param.search.isEmptyOrNull;
    emit(state.copyWith(status: BlocStatus.success, isFirst: isFirst));
  }
}
