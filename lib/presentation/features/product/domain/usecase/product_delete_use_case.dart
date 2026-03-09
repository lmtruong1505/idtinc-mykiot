import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../repositories/product_repository.dart';

@injectable
class ProductDeleteUseCase extends BaseFutureUseCase<ProductDeleteInput, ProductDeleteOutput> {
  ProductDeleteUseCase(this._repo);
  final ProductRepository _repo;

  @override
  Future<ProductDeleteOutput> buildUseCase(ProductDeleteInput input) async {
    final res = await _repo.deleteProduct(id: input.id);
    return ProductDeleteOutput(response: res);
  }

}

class ProductDeleteInput extends BaseInput {
  final int id;
  ProductDeleteInput({required this.id});
}

class ProductDeleteOutput extends BaseOutput {
  final BaseResponseModel response;
  ProductDeleteOutput({required this.response});
}