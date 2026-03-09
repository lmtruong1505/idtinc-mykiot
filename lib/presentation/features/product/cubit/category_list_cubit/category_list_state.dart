import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_list_state.freezed.dart';


@freezed
class CategoryListState with _$CategoryListState {
  const factory CategoryListState({
    @Default(false) bool isLoading,
    @Default(20) int limit,
    @Default('') String search,
  }) = _CategoryListState;
}
