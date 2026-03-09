import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/presentation/features/employee/employee/data/mapper/employee_entity_mapper.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/entities/employee_entity.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/repositories/employee_repository.dart';

import '../../../../../../data/models/base/response.dart';
import '../../../../../../domain/usecase/base/io/input.dart';
import '../../../../../../domain/usecase/base/io/output.dart';

@injectable
class EmployeeListUseCase extends BaseFutureUseCase<EmployeeListInput, EmployeeListOutput>{
  EmployeeListUseCase(
    this._employeeRepository,
    this._employeeMapper,
  );
  final EmployeeRepository _employeeRepository;
  final EmployeeMapper _employeeMapper;

  @override
  Future<EmployeeListOutput> buildUseCase(EmployeeListInput input) async {
    final res = await _employeeRepository.getList(
      limit: input.limit,
      page: input.page,
      company: input.company,
      search: input.search,
    );
    final dataEntity = _employeeMapper.mapToListEntity(res.data);
    final output = EmployeeListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }

}

class EmployeeListInput extends BaseInput {
  final int? company;
  final String? search;
  final int? page;
  final int? limit;

  EmployeeListInput({
    this.company,
    this.limit,
    this.page,
    this.search,
  });
}

class EmployeeListOutput extends BaseOutput {
  final BaseResponseModel<List<EmployeeEntity>> response;
  EmployeeListOutput({required this.response});
}