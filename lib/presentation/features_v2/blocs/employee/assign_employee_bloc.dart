import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../data/models/base/response.dart';
import '../../models/employee/emp_model.dart';
import '../../models/employee/working_data_model.dart';
import '../../repositories/employee/emp_repository.dart';

class AssignEmployeeBloc extends Cubit<CubitState> {
  AssignEmployeeBloc() : super(CubitState());

  final repo = EmpRepository();

  final steps = [
    'Nhập mã thành viên',
    'Xác nhận thông tin',
  ];

  int _currentStep = 0;

  int get currentStep => _currentStep;

  EmpModel _model = EmpModel();

  EmpModel? get model => _model;

  void nextStep(int step) {
    _currentStep = step;
    emit(state.copyWith(status: BlocStatus.success));
  }

  List<WorkingDataModel> _workingData = [];

  List<WorkingDataModel> get workingData => _workingData;

  void setWorkingData(List<WorkingDataModel> data) {
    _workingData = data;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void addWorkingData(WorkingDataModel data) {
    final index = _workingData.indexWhere((element) => element.company?.id == data.company?.id);
    if (index != -1) {
      _workingData[index] = data;
    }
    else {
      _workingData.add(data);
    }
    emit(state.copyWith(status: BlocStatus.success));
  }
  void changeWorkingData(WorkingDataModel data) {
    final index = _workingData.indexWhere((element) => element.id == data.id);
    if (index != -1) {
      _workingData[index] = data;
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  void removeWorkingData(int index) {
    _workingData.removeAt(index);
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel> findEmp(String code) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await repo.getEmpByCodePharma(code: code);
    if (res.code == 200) {
      final emp = res.data;
      _model = _model.copyWith(
        userData: emp,
      );
    }
    emit(state.copyWith(status: BlocStatus.success));
    return res;
  }

  void clear() {
    _model = EmpModel();
    _workingData = [];
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel> assign() {
    final company = getCompany ?? -1;
    final payload = {
      'user': _model.userData?.id.validator,
      'workspace': company,
      'working': _workingData
          .map(
            (e) => {
              'workspace': e.company?.id.validator,
              'roles': e.roleData.map((ee) => ee.id).toList(),
            },
          )
          .toList(),
    };
    final res = repo.assignEmp(payload: payload);
    return res;
  }
}
