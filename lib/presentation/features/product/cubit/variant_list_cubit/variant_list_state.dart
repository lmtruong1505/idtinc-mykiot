import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/variant_entity.dart';

part 'variant_list_state.freezed.dart';

@freezed
class VariantListState with _$VariantListState {
  const factory VariantListState({
    @Default(10) int limit,
    @Default(false) bool isLoading,
    @Default(false) bool searchLoading,
    @Default('') String search,
    @Default([]) List<VariantEntity> variantSelected,
  }) = _VariantListState;
}
