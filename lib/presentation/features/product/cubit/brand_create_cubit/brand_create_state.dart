import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_entity.dart';

part 'brand_create_state.freezed.dart';

@freezed
class BrandCreateState with _$BrandCreateState {
  const factory BrandCreateState({
    @Default(<ProductEntity>[]) List<ProductEntity> products,
    @Default('') String code,
    @Default('') String name,
    @Default('') String note,
  }) = _BrandCreateState;
}
