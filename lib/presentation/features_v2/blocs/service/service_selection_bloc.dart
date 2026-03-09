import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/local/get_data.dart';
import '../../models/employee/pre_emp_model.dart';
import '../../models/service/service.dart';
import '../../repositories/service/serrvice_v2_repository.dart';
import '../state/init_state.dart';

class ServiceSelectionEventBloc extends Cubit<CubitState> {
  ServiceSelectionEventBloc() : super(CubitState());

  int _page = 1;
  final int _limit = 20;
  int get page => _page;
  int get limit => _limit;
  final _repo = ServiceV2Repository();
  final List<ServiceV2Model> list = [];
  List<int?> get _ids => list.map((e) => e.price?.id ?? e.id).toList();

  addAll(List<ServiceV2Model> values) {
    list.clear();
    list.addAll(values);
    emit(state.copyWith(status: BlocStatus.success));
  }

  removeList() {
    list.clear();
    emit(state.copyWith(status: BlocStatus.success));
  }

  addService(ServiceV2Model value) {
    if (!_ids.contains(value.id)) {
      list.add(value);
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  updateDoctor(
    int index,
    PreEmpModel value,
  ) {
    list[index].employee = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  remove(
    int index,
  ) {
    list.removeAt(index);
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<List<ServiceV2Model>> getList(
    String? search, {
    bool isMore = false,
  }) async {
    if (!isMore) {
      _page = 1;
    } else {
      _page++;
    }
    final res = await _repo.getList(
      page: _page,
      companyId: getCompanyId,
      search: search,
      limit: _limit,
      isActive: true,
      splitUnit: true,
    );
    if (res.data != null && res.data!.isEmpty) _page--;
    return res.data ?? [];
  }
}
