import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/company_repository.dart';

@injectable
class AssignStaffUseCase extends BaseFutureUseCase<AssignStaffInput, AssignStaffOutput> {
  AssignStaffUseCase(this._repo);
  final CompanyRepository _repo;

  @override
  Future<AssignStaffOutput> buildUseCase(AssignStaffInput input) async {
    final res = await _repo.assignStaff(
      company: input.company,
      assign: input.assign,
      remove: input.remove,
    );
    return AssignStaffOutput(response: res);
  }

}

class AssignStaffInput extends BaseInput{
  final int company;
  final List<int> assign;
  final List<int> remove;
  AssignStaffInput({
    required this.company,
    required this.assign,
    required this.remove,
  });
}

class AssignStaffOutput extends BaseOutput{
  final BaseResponseModel response;
  AssignStaffOutput({
    required this.response,
  });
}