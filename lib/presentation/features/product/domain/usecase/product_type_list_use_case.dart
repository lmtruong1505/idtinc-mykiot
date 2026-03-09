import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/product_type_entity_mappper.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_type_entity.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/product_type_repository.dart';

@injectable
class ProductTypeListUseCase
    extends BaseFutureUseCase<ProductTypeListInput, ProductTypeListOutput> {
  ProductTypeListUseCase(
    this._productTypeRepository,
    this._productTypeEntityMapper,
  );
  final ProductTypeRepository _productTypeRepository;
  final ProductTypeEntityMapper _productTypeEntityMapper;

  @override
  Future<ProductTypeListOutput> buildUseCase(ProductTypeListInput input) async {
    final res = await _productTypeRepository.getList(
      search: input.search,
      limit: input.limit,
      page: input.page,
      company: input.company,
    );
    final dataEntity = _productTypeEntityMapper.mapToListEntity(res.data);
    final output = ProductTypeListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class ProductTypeListInput extends BaseInput {
  final int? company;
  final String? search;
  final int? page;
  final int? limit;

  ProductTypeListInput({
    this.company,
    this.limit,
    this.page,
    this.search,
  });
}

class ProductTypeListOutput extends BaseOutput {
  final BaseResponseModel<List<ProductTypeEntity>> response;
  ProductTypeListOutput({required this.response});
}
