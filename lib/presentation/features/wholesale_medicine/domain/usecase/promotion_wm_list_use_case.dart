import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/mapper/promotion_wm_mapper.dart';
import '../entities/promotion_detail_wm_entity.dart';
import '../repositories/promotion_wm_repository.dart';

@injectable
class PromotionWmListUseCase
    extends BaseFutureUseCase<PromotionWmListInput, PromotionWmListOutput> {
  final PromotionRepository promotionRepository;
  final PromotionDetailMapper promotionDetailMapper;

  PromotionWmListUseCase(
    this.promotionDetailMapper,
    this.promotionRepository,
  );

  @override
  Future<PromotionWmListOutput> buildUseCase(
    PromotionWmListInput input,
  ) async {
    final res = await promotionRepository.getListDetailPromotion(
        idVariant: input.variantId,
        tag: input.tag,
        orderValue: input.orderValue);

    final dataEntity = promotionDetailMapper.mapToListEntity(res.data);
    final output = PromotionWmListOutput(
      response: BaseResponseModel(
        data: dataEntity,
        message: res.message,
        code: res.code,
      ),
    );
    return output;
  }
}

class PromotionWmListInput extends BaseInput {
  final int? variantId;
  final String? tag;
  final int? orderValue;
  const PromotionWmListInput({
    this.variantId,
    this.tag,
    this.orderValue,
  });
}

class PromotionWmListOutput extends BaseOutput {
  final BaseResponseModel<List<PromotionDetailEntity>> response;
  const PromotionWmListOutput({required this.response});
}
