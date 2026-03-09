import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_list_state.freezed.dart';


@freezed
class BrandListState with _$BrandListState {
  const factory BrandListState({
    @Default(false) bool isLoading,
    @Default(20) int limit,
    @Default('') String search,
  }) = _BrandListState;
}
