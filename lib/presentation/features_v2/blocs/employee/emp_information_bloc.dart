import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/employee/emp_model.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../../../data/models/base/response.dart';
import '../../repositories/employee/emp_repository.dart';

class EmpInformationBloc extends Cubit<CubitState> {
  EmpInformationBloc() : super(CubitState());

  final repo = EmpRepository();
  EmpModel? _model;
  EmpModel? get model => _model;

  Future<void> init(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final company = getCompany ?? -1;
    final res = await repo.getEmp(id: id, company: company);
    if (res.code == 200) {
      _model = res.data;
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel> changeStatus(int id, String status) async {
    final res = await repo.changeStatus(workspaceId: id, status: status);
    return res;
  }

  Future<BaseResponseModel> terminate(int id) async {
    final company = getCompany ?? -1;
    final res = await repo.terminate(id: id, company: company);
    return res;
  }



}