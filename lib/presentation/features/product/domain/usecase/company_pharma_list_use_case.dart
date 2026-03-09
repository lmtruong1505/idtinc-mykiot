import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/company_pharma_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/entities/company_pharma_entity.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/product_repository.dart';

@injectable
class CompanyPharmaListUseCase
    extends BaseFutureUseCase<CompanyPharmaListInput, CompanyPharmaListOutput> {
  CompanyPharmaListUseCase(
    this._productRepository,
    this._companyPharmaEntityMapper,
  );
  final ProductRepository _productRepository;
  final CompanyPharmaEntityMapper _companyPharmaEntityMapper;

  @override
  Future<CompanyPharmaListOutput> buildUseCase(CompanyPharmaListInput input) async {
    final res = await _productRepository.getListCompanyPharma(
      search: input.search,
      limit: input.limit,
      page: input.page,
      type: input.type,
    );
    final dataEntity = _companyPharmaEntityMapper.mapToListEntity(res.data);
    final output = CompanyPharmaListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class CompanyPharmaListInput extends BaseInput {
  final String? search;
  final int? page;
  final int? limit;
  final String? type;

  CompanyPharmaListInput({
    this.limit,
    this.page,
    this.search,
    this.type,
  });
}

class CompanyPharmaListOutput extends BaseOutput {
  final BaseResponseModel<List<CompanyPharmaEntity>> response;
  CompanyPharmaListOutput({required this.response});
}
