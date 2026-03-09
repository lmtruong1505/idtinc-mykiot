import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/basic_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/product_repository.dart';

@injectable
class ProductionStandardListUseCase
    extends BaseFutureUseCase<ProductionStandardListInput, ProductionStandardListOutput> {
  ProductionStandardListUseCase(
    this._productRepository,
    this._basicEntityMapper,
  );
  final ProductRepository _productRepository;
  final BasicEntityMapper _basicEntityMapper;

  @override
  Future<ProductionStandardListOutput> buildUseCase(ProductionStandardListInput input) async {
    final res = await _productRepository.getListProductionStandard(
      search: input.search,
      limit: input.limit,
      page: input.page,
    );
    final dataEntity = _basicEntityMapper.mapToListEntity(res.data);
    final output = ProductionStandardListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class ProductionStandardListInput extends BaseInput {
  final String? search;
  final int? page;
  final int? limit;

  ProductionStandardListInput({
    this.limit,
    this.page,
    this.search,
  });
}

class ProductionStandardListOutput extends BaseOutput {
  final BaseResponseModel<List<BasicEntity>> response;
  ProductionStandardListOutput({required this.response});
}
