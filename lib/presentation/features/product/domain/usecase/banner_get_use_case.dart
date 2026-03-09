import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';

import '../../../../../domain/usecase/base/io/output.dart';
import '../repositories/product_repository.dart';

@injectable
class BannerGetUseCase
    extends BaseFutureUseCase<BannerGetInput, BannerGetOutput> {
  BannerGetUseCase(this._productRepository);
  final ProductRepository _productRepository;

  @override
  Future<BannerGetOutput> buildUseCase(BannerGetInput input) async {
    final res = await _productRepository.getBanner(
      typeBanner: input.typeBanner,
    );
    return BannerGetOutput(res);
  }
}

class BannerGetInput extends BaseInput {
  final String typeBanner;
  BannerGetInput({
    required this.typeBanner,
  });
}

class BannerGetOutput extends BaseOutput {
  final BaseResponseModel<List<String>> response;
  BannerGetOutput(this.response);
}
