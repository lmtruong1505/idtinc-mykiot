import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/order/cubit/order_create_cubit/order_create_state.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_count_entity.dart';

import '../../widgets/bts_filter_order.dart';

part 'order_list_state.freezed.dart';

@freezed
class OrderListState with _$OrderListState {
  const factory OrderListState({
    @Default(20) int limit,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
    DateTime? updatedFrom,
    DateTime? updatedTo,
    OrderFilterOrderBy? orderBy,
    OrderCountEntity? orderCount,
    @Default(OrderType.values) List<OrderType> listFilter,
    @Default(OrderType.all) OrderType selectFilter,
    String? search,
  }) = _OrderListState;
}
