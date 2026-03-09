import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/brand_repository.dart';

import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';

@injectable
class BrandUpdateUseCase
    extends BaseFutureUseCase<BrandUpdateInput, BrandUpdateOutput> {
  BrandUpdateUseCase(this._brandRepository);

  final BrandRepository _brandRepository;

  @override
  Future<BrandUpdateOutput> buildUseCase(BrandUpdateInput input) async {
    final res = await _brandRepository.update(
      name: input.name,
      code: input.code,
      description: input.description,
      products: input.products,
      id: input.id,
    );
    final output = BrandUpdateOutput(response: res);
    return output; 
  }
}

class BrandUpdateInput extends BaseInput {
  final String? code;
  final String name;
  final String? description;
  final List<int>? products;
  final int id;
  BrandUpdateInput({
    required this.id,
    required this.name,
    this.code,
    this.description,
    this.products,
  });
}

class BrandUpdateOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  BrandUpdateOutput({required this.response});
}
