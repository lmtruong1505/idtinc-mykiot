import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/features_v2/models/employee/pre_emp_model.dart';

import '../../repositories/employee/emp_repository.dart';
import '../state/init_state.dart';

class ListStaffServiceBloc extends Cubit<CubitState> {
  ListStaffServiceBloc() : super(CubitState());
  final _repo = EmpRepository();
  final List<PreEmpModel> list = [];

  Future<void> getList() async {
    list.clear();
    emit(
      state.copyWith(
        status: BlocStatus.loading,
      ),
    );
    final res = await _repo.getEmpSerrvice(company: getCompanyId!);
    list.addAll(res.data ?? []);
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }
}
