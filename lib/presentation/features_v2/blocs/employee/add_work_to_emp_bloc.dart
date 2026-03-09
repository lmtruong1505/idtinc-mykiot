import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/company/data/mapper/company_mapper.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';

import '../../../features/company/domain/repositories/company_repository.dart';
import '../../models/role/role_model.dart';
import '../../repositories/employee/emp_repository.dart';

@injectable
class AddWorkToEmpBloc extends Cubit<CubitState> {
  AddWorkToEmpBloc(this._companyMapper, this._companyRepository) : super(CubitState());

  final CompanyMapper _companyMapper ;
  final CompanyRepository _companyRepository;
  final repo = EmpRepository();


  Future<void> init(int? id, List<RoleListModel>? roleData) async {
    emit(CubitState(status: BlocStatus.loading));
    if (id != null) {
      final res = await _companyRepository.getDetail(id: id);
      final company = _companyMapper.mapToEntity(res.data);
      setCompany(company);
    }
    if (roleData != null) {
      setRoles(roleData);
    }
    emit(CubitState(status: BlocStatus.success));
  }

  CompanyEntity? _company;
  CompanyEntity? get company => _company;
  void setCompany(CompanyEntity? company) {
    _company = company;
    emit(CubitState());
  }

  List<RoleListModel> _roles = [];
  List<RoleListModel> get roles => _roles;
  void setRoles(List<RoleListModel> roles) {
    _roles = roles;
    emit(CubitState());
  }

  void addRole(RoleListModel role) {
    _roles.add(role);
    emit(CubitState());
  }

  void removeRole(int id) {
    _roles.removeWhere((element) => element.id == id);
    emit(CubitState());
  }

  // Future<BaseResponseModel<WorkingDataModel>> update(int oldWs, int newWs, List<int> newRoles) async {
  //   emit(CubitState(status: BlocStatus.loading));
  //   final payload = {
  //     'workspace' : newWs,
  //     'roles' : newRoles
  //   };
  //   final res = await repo.updateWorkingData(oldWorkspace: oldWs, payload: payload);
  //   return res;
  // }

}