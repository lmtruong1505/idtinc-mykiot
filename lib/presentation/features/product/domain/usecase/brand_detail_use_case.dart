import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/brand_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/brand_repository.dart';

import '../../../../../domain/usecase/base/future_use_case.dart';
import '../entities/brand_entity.dart';

@injectable
class BrandDetailUseCase
    extends BaseFutureUseCase<BrandDetailInput, BrandDetailOutput> {
  BrandDetailUseCase(
    this._brandRepository,
    this._brandEntityMapper,
  );

  final BrandRepository _brandRepository;
  final BrandEntityMapper _brandEntityMapper;

  @override
  Future<BrandDetailOutput> buildUseCase(BrandDetailInput input) async {
    final res = await _brandRepository.getDetail(id: input.id);
    final dataEntity = _brandEntityMapper.mapToEntity(res.data);
    final output = BrandDetailOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class BrandDetailInput extends BaseInput {
  final int id;
  BrandDetailInput({required this.id});
}

class BrandDetailOutput extends BaseOutput {
  final BaseResponseModel<BrandEntity> response;
  BrandDetailOutput({required this.response});
}
