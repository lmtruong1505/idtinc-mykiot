import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product_standard/domain/entities/product_standard_entity.dart';

part 'product_standard_state.freezed.dart';

@freezed
class ProductStandardState with _$ProductStandardState {
  const factory ProductStandardState({
    @Default('') String search,
    @Default(0) int total,
    @Default(ProductStandardEntity()) ProductStandardEntity item,
  }) = _ProductStandardState;
}
