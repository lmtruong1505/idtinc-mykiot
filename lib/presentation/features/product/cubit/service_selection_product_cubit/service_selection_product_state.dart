import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/variant_entity.dart';

part 'service_selection_product_state.freezed.dart';

@freezed
class ServiceSelectionProductState with _$ServiceSelectionProductState {
  const factory ServiceSelectionProductState({
    @Default(<VariantEntity>[]) List<VariantEntity> variants,
  }) = _ServiceSelectionProductState;
}
