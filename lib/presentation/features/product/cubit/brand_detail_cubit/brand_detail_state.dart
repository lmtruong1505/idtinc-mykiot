import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/domain/entities/brand_entity.dart';

part 'brand_detail_state.freezed.dart';

@freezed
class BrandDetailState with _$BrandDetailState {
  const factory BrandDetailState({
    BrandEntity? brand,
  }) = _BrandDetailState;
}
