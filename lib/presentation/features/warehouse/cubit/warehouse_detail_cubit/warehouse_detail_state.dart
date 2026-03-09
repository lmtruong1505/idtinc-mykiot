import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../product/domain/entities/product_entity.dart';
import '../../domain/entities/warehouse_entity.dart';

part 'warehouse_detail_state.freezed.dart';

@freezed
class WarehouseDetailState with _$WarehouseDetailState {
  const factory WarehouseDetailState({
    @Default(false) bool isLoading,
    WarehouseEntity? warehouseEntity,
    List<ProductEntity>? productWarehouse,
  }) = _WarehouseDetailState;
}
