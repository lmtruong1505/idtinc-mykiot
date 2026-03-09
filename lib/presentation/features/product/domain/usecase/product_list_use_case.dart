import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/count_mapper.dart';
import 'package:pharmago/presentation/features/product/data/mapper/product_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_entity.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/product_repository.dart';

@injectable
class ProductListUseCase
    extends BaseFutureUseCase<ProductListInput, ProductListOutput> {
  ProductListUseCase(
    this._productRepository,
    this._productEntityMapper,
    this._productCountMapper,
  );

  final ProductRepository _productRepository;
  final ProductEntityMapper _productEntityMapper;
  final CountMapper _productCountMapper;
  @override
  Future<ProductListOutput> buildUseCase(ProductListInput input) async {
    final res = await _productRepository.getProducts(
      search: input.search,
      limit: input.limit,
      page: input.page,
      company: input.company,
      brand: input.brand,
      active: input.active,
    );
    final dataEntity = _productEntityMapper.mapToListEntity(res.data);
    final orderCounts = _productCountMapper.mapToListEntity(res.extra);
    final output = ProductListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
        extra: orderCounts,
      ),
    );
    return output;
  }
}

class ProductListInput extends BaseInput {
  final String search;
  final int limit;
  final int page;
  final int? company;
  final int? brand;
  final bool? active;

  ProductListInput({
    required this.search,
    required this.limit,
    required this.page,
    required this.company,
    this.brand,
    this.active,
  });
}

class ProductListOutput extends BaseOutput {
  final BaseResponseModel<List<ProductEntity>> response;

  ProductListOutput({required this.response});
}
