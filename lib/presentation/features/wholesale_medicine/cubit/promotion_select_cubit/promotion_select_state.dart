import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/promotion_detail_wm_entity.dart';
part 'promotion_select_state.freezed.dart';

@freezed
class PromotionSelectState with _$PromotionSelectState {
  const factory PromotionSelectState({
    @Default([]) List<PromotionDetailEntity> promotions,
    @Default(0) int valueQuery,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingBts,
    PromotionDetailEntity? promotionDetail,
    List<PromotionDetailEntity>? promotionDetailSelectedPromo,
    @Default([]) List<PromotionDetailEntity> listPromoInit,
    int? quantityVariantBuy,
    int? totalPriceBuy,
    String? messageErr,
    @Default(TypePromotion.product) TypePromotion typePromotion,
  }) = _PromotionSelectState;
}
