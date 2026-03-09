import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_update_state.freezed.dart';

@freezed
class PriceUpdateState with _$PriceUpdateState {
  const factory PriceUpdateState({
    @Default(0) int priceImportNew,
    @Default(0) int priceSellNew,
  }) = _PriceUpdateState;
}
