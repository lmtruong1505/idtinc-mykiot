
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../base/filter_button.dart';
import '../../../product/domain/entities/service_entity.dart';
import '../../cubit/order_create_cubit/order_create_state.dart';

part 'service_for_order_state.freezed.dart';

@freezed
class ServiceForOrderState with _$ServiceForOrderState {
  const factory ServiceForOrderState({
    @Default(20) int limit,
    @Default('') String searchKey,
    @Default(<ServiceEntity>[])
    List<ServiceEntity> listServiceSelect,
    @Default(FilterButtonItem('Bán chạy', FilterItemOrder.best_seller)) FilterButtonItem selectFilter,
    @Default(<FilterButtonItem>[
      FilterButtonItem('Đã chọn', FilterItemOrder.had_choose),
      FilterButtonItem('Bán chạy', FilterItemOrder.best_seller),
      FilterButtonItem('Mới nhất', FilterItemOrder.newest),
    ]) List<FilterButtonItem> listFilter,
  }) = _ServiceForOrderState;
}

