import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/product/data/mapper/product_detail_entity_mapper.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../entities/product_detail_entity.dart';
import '../repositories/product_repository.dart';

@injectable
class ProductDetailUseCase
    extends BaseFutureUseCase<ProductDetailInput, ProductDetailOutput> {
  ProductDetailUseCase(
    this._productRepository,
    this._productDetailEntityMapper,
  );
  final ProductRepository _productRepository;
  final ProductDetailEntityMapper _productDetailEntityMapper;

  @override
  Future<ProductDetailOutput> buildUseCase(ProductDetailInput input) async {
    final res = await _productRepository.getDetail(id: input.id);
    final dataEntity = _productDetailEntityMapper.mapToEntity(res.data);
    final output = ProductDetailOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class ProductDetailInput extends BaseInput {
  final int id;
  ProductDetailInput({required this.id});
}

class ProductDetailOutput extends BaseOutput {
  final BaseResponseModel<ProductDetailEntity> response;
  ProductDetailOutput({required this.response});
}
