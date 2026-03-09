part of 'category_create_cubit.dart';

@freezed
class CategoryCreateState with _$CategoryCreateState {
  const factory CategoryCreateState({
    @Default(<ProductEntity>[]) List<ProductEntity> products,
    @Default('') String code,
    @Default('') String name,
    @Default('') String note,
  }) = _CategoryCreateState;
}
