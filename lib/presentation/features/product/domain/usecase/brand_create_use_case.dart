import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/brand_repository.dart';

import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';

@injectable
class BrandCreateUseCase
    extends BaseFutureUseCase<BrandCreateInput, BrandCreateOutput> {
  BrandCreateUseCase(this._brandRepository);

  final BrandRepository _brandRepository;

  @override
  Future<BrandCreateOutput> buildUseCase(BrandCreateInput input) async {
    final res = await _brandRepository.create(
      name: input.name,
      company: input.company,
      code: input.code,
      description: input.description,
      products: input.products,
    );
    final output = BrandCreateOutput(response: res);
    return output; 
  }
}

class BrandCreateInput extends BaseInput {
  final String? code;
  final String name;
  final String? description;
  final List<int>? products;
  final int company;
  BrandCreateInput({
    required this.company,
    required this.name,
    this.code,
    this.description,
    this.products,
  });
}

class BrandCreateOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  BrandCreateOutput({required this.response});
}
