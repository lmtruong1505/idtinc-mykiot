import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_type_list_state.freezed.dart';

@freezed
class ProductTypeListState with _$ProductTypeListState {
  const factory ProductTypeListState({
    @Default(false) bool isLoading,
    @Default(20) int limit,
    @Default('') String search,
  }) = _ProductTypeListState;
}
