import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/order_detail_entity.dart';

part 'order_detail_state.freezed.dart';

@freezed
class OrderDetailState with _$OrderDetailState {
  const factory OrderDetailState({
    @Default(false) bool isLoading,
    OrderDetailEntity? order,
    @Default(false) bool hadSendZalo,
  }) = _OrderDetailState;
}
