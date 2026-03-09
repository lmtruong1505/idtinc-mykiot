import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/order_wm_entity.dart';
import '../order_wm_create_cubit/order_wm_create_state.dart';
part 'order_wm_detail_state.freezed.dart';

@freezed
class OrderWmDetailState with _$OrderWmDetailState {
  const factory OrderWmDetailState({
    @Default(null) TypeOrder? typeOrder,
    @Default(true) bool isLoading,
    @Default(null) int? idReasonDeny,
    @Default(null) dynamic data,
    @Default(null) OrderWmDetailEntity? orderDetail,
    @Default(<OrderItemEntity>[]) List<OrderItemEntity> variants,
    @Default(<OrderItemEntity>[]) List<OrderItemEntity> variantsGift,
    @Default(<OrderItemEntity>[]) List<OrderItemEntity> variantsPromo,
    @Default(false) bool isDrafOrder,
    @Default('') String titleReason,
  }) = _OrderWmDetailState;
}
