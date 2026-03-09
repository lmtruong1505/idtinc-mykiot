import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/company_repository.dart';
import 'package:pharmago/presentation/features/product/data/mapper/basic_entity_mapper.dart';

import '../../../../../data/models/base/response.dart';
import '../../../product/domain/entities/basic_entity.dart';

@injectable
class ListTypeCompanyUseCase
    extends BaseFutureUseCase<ListTypeCompanyInput, ListTypeCompanyOutput> {
  ListTypeCompanyUseCase(this._repository, this._mapper);

  final CompanyRepository _repository;
  final BasicEntityMapper _mapper;

  @override
  Future<ListTypeCompanyOutput> buildUseCase(ListTypeCompanyInput input) async {
    final res = await _repository.getCompanyType();
    final dataEntity = _mapper.mapToListEntity(res.data);
    return ListTypeCompanyOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
  }
}

class ListTypeCompanyInput extends BaseInput {
  ListTypeCompanyInput();
}

class ListTypeCompanyOutput extends BaseOutput {
  final BaseResponseModel<List<BasicEntity>> response;

  ListTypeCompanyOutput({required this.response});
}
