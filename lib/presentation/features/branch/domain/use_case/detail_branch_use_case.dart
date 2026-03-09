import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/company/data/mapper/company_mapper.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/company_repository.dart';

import '../../../company/domain/entities/company_entity.dart';

@injectable
class DetailBranchUseCase
    extends BaseFutureUseCase<DetailBranchInput, DetailBranchOutput> {
  DetailBranchUseCase(
    this._companyRepository,
    this._companyMapper,
  );

  final CompanyRepository _companyRepository;
  final CompanyMapper _companyMapper;

  @override
  Future<DetailBranchOutput> buildUseCase(DetailBranchInput input) async {
    final res = await _companyRepository.getDetail(id: input.id);

    final dataEntity = _companyMapper.mapToEntity(res.data);

    final output = DetailBranchOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class DetailBranchInput extends BaseInput {
  final int id;

  DetailBranchInput({required this.id});
}

class DetailBranchOutput extends BaseOutput {
  final BaseResponseModel<CompanyEntity> response;

  DetailBranchOutput({required this.response});
}
