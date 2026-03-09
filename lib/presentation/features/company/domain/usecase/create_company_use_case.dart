import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/company/data/mapper/company_mapper.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_payload_entity.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/company_repository.dart';

@injectable
class CreateCompanyUseCase
    extends BaseFutureUseCase<CreateCompanyInput, CreateCompanyOutput> {
  CreateCompanyUseCase(
    this._companyRepository,
    this._companyMapper,
  );
  final CompanyRepository _companyRepository;
  final CompanyMapper _companyMapper;

  @override
  Future<CreateCompanyOutput> buildUseCase(CreateCompanyInput input) async {
    final payload = input.companyPayloadEntity.toJson();
    final res = await _companyRepository.createCompany(payload, input.id);
    final dataEntity = _companyMapper.mapToEntity(res.data);
    final output = CreateCompanyOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class CreateCompanyInput extends BaseInput {
  final CompanyPayloadEntity companyPayloadEntity;
  final int? id;
  CreateCompanyInput({
    required this.companyPayloadEntity,
    this.id,
  });
}

class CreateCompanyOutput extends BaseOutput {
  final BaseResponseModel<CompanyEntity> response;
  CreateCompanyOutput({required this.response});
}
