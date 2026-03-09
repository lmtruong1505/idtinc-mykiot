import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/presentation/features/company/domain/entities/setting_point_entity.dart';

import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../repositories/company_repository.dart';

@injectable
class SettingPointUseCase extends BaseFutureUseCase<SettingPointUseCaseInput,
    SettingPointUseCaseOutput> {
  final CompanyRepository _companyRepository;
  SettingPointUseCase(this._companyRepository);

  @override
  Future<SettingPointUseCaseOutput> buildUseCase(
    SettingPointUseCaseInput input,
  ) async {
    final res = await _companyRepository.settingPoint(
      idCompany: input.idCompany,
      payload: input.payload,
    );
    return SettingPointUseCaseOutput(
      response: res,
    );
  }
}

class SettingPointUseCaseInput extends BaseInput {
  final Map<String, dynamic> payload;
  final int idCompany;
  SettingPointUseCaseInput({
    required this.payload,
    required this.idCompany,
  });
}

class SettingPointUseCaseOutput extends BaseOutput {
  final BaseResponseModel<SettingPointEntity> response;
  SettingPointUseCaseOutput({
    required this.response,
  });
}
