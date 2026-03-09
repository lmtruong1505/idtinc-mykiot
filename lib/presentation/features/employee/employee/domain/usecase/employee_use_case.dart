import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import '../../data/mapper/employee_entity_mapper.dart';
import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

@injectable
class EmployeeUseCase {
  final EmployeeRepository _repository;
  final EmployeeMapper _mapper;
  EmployeeUseCase(this._repository, this._mapper);

  // Future<List<EmployeeEntity>> getList(
  //   int company,
  //   String search,
  //   int page,
  // ) async {
  //   final data = await _repository.getList(company, search, page);
  //   return _mapper.mapToListEntity(data.data);
  // }

  Future<EmployeeEntity> getDetail(int id) async {
    final data = await _repository.getDetail(id);
    return _mapper.mapToEntity(data.data);
  }

  Future<BaseResponseModel<int>> create(EmployeeEntity employee) async {
    final payload = employee.toJson();
    print(employee.toJson());
    if (employee.dob != null) {
      payload['dob'] = '${employee.dob?.toIso8601String()}Z';
    }
    payload.removeWhere((key, value) => value == null || value == '');
    return _repository.create(payload);
  }

  Future<BaseResponseModel> update(EmployeeEntity employee) async {
    return _repository.update(
      employee.id!,
      employee.toJson(),
    );
  }

  Future<BaseResponseModel> delete(int id) async {
    return _repository.delete(id);
  }
}
