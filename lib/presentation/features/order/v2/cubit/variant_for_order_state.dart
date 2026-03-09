import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';

import '../../../../base/filter_button.dart';
import '../../cubit/order_create_cubit/order_create_state.dart';

part 'variant_for_order_state.freezed.dart';

@freezed
class VariantForOrderState with _$VariantForOrderState {
  const factory VariantForOrderState({
    @Default(20) int limit,
    @Default('') String searchKey,
    @Default(<VariantEntity>[])
    List<VariantEntity> listVariantSelect,
    @Default(<VariantEntity>[])
    List<VariantEntity> listVariantPromotionSelect,
    @Default(FilterButtonItem('Bán chạy', FilterItemOrder.best_seller)) FilterButtonItem selectFilter,
    @Default(<FilterButtonItem>[
      FilterButtonItem('Đã chọn', FilterItemOrder.had_choose),
      FilterButtonItem('Bán chạy', FilterItemOrder.best_seller),
      FilterButtonItem('Mới nhất', FilterItemOrder.newest),
    ]) List<FilterButtonItem> listFilter,
  }) = _VariantForOrderState;
}
