import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/domain/entities/packaging_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/unit_entity.dart';
import 'package:pharmago/presentation/features/product/screens/product_manager_page.dart';

part 'price_list_state.freezed.dart';

@freezed
class PriceListState with _$PriceListState {
  const factory PriceListState({
    @Default(TabProductManagerPage.product) TabProductManagerPage tabSelected,
    @Default('') String search,
    @Default(10) int limit,
    @Default(<PackagingEntity>[]) List<PackagingEntity> packaging,
    UnitEntity? unit,
  }) = _PriceListState;
}
