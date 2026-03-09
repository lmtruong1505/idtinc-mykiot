import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/domain/entities/brand_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_entity.dart';

part 'brand_update_state.freezed.dart';

@freezed
class BrandUpdateState with _$BrandUpdateState {
  const factory BrandUpdateState({
    @Default(false) bool isLoading,
    BrandEntity? brand,
    @Default(<ProductEntity>[]) List<ProductEntity> products,
  }) = _BrandUpdateState;
}
