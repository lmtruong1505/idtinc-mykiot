import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/brand_repository.dart';

import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';

@injectable
class BrandDeleteUseCase
    extends BaseFutureUseCase<BrandDeleteInput, BrandDeleteOutput> {
  BrandDeleteUseCase(this._brandRepository);

  final BrandRepository _brandRepository;

  @override
  Future<BrandDeleteOutput> buildUseCase(BrandDeleteInput input) async {
    final res = await _brandRepository.delete(input.id);
    final output = BrandDeleteOutput(response: res);
    return output;
  }
}

class BrandDeleteInput extends BaseInput {
  final int id;
  BrandDeleteInput({
    required this.id,
  });
}

class BrandDeleteOutput extends BaseOutput {
  final BaseResponseModel response;
  BrandDeleteOutput({required this.response});
}
