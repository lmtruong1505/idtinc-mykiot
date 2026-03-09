import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_payload_entity.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/company_repository.dart';

@injectable
class UpdateBranchUseCase
    extends BaseFutureUseCase<UpdateCompanyInput, UpdateCompanyOutput> {
  UpdateBranchUseCase(
      this._companyRepository,
      );
  final CompanyRepository _companyRepository;

  @override
  Future<UpdateCompanyOutput> buildUseCase(UpdateCompanyInput input) async {
    final payload = input.companyPayloadEntity.toJson();
    final res = await _companyRepository.updateCompany(id: input.id, payload: payload);
    final output = UpdateCompanyOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data,
      ),
    );
    return output;
  }
}

class UpdateCompanyInput extends BaseInput {
  final int id;
  final CompanyPayloadEntity companyPayloadEntity;
  UpdateCompanyInput({required this.id, required this.companyPayloadEntity});
}

class UpdateCompanyOutput extends BaseOutput {
  final BaseResponseModel response;
  UpdateCompanyOutput({required this.response});
}
