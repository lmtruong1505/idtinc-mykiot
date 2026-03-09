import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/mapper/promotion_wm_mapper.dart';
import '../entities/promotion_detail_wm_entity.dart';
import '../repositories/promotion_wm_repository.dart';

@injectable
class PromotionDetailUseCase
    extends BaseFutureUseCase<PromotionDetailInput, PromotionDetailOutput> {
  final PromotionRepository _promotionRepository;
  final PromotionDetailMapper _promotionDetailMapper;

  PromotionDetailUseCase(
    this._promotionRepository,
    this._promotionDetailMapper,
  );

  @override
  Future<PromotionDetailOutput> buildUseCase(PromotionDetailInput input) async {
    final res = await _promotionRepository.getDetailPromotion(input.id);
    final dataEntity = _promotionDetailMapper.mapToEntity(res.data);

    return PromotionDetailOutput(
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
  }
}

class PromotionDetailInput extends BaseInput {
  final int id;
  PromotionDetailInput(this.id);
}

class PromotionDetailOutput extends BaseOutput {
  final BaseResponseModel<PromotionDetailEntity> response;

  PromotionDetailOutput(this.response);
}
