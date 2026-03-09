import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../customer/domain/entities/customer_entity.dart';
import '../../../product/domain/entities/service_entity.dart';
import '../../../product/domain/entities/variant_entity.dart';
import '../../cubit/order_create_cubit/order_create_state.dart';

part 'order_create_v2_state.freezed.dart';

@freezed
class OrderCreateV2State with _$OrderCreateV2State{
  const factory OrderCreateV2State({
    @Default([]) List<VariantEntity> variantSelected,
    @Default([]) List<ServiceEntity> serviceSelected,
    CustomerEntity? customerSelected,
    @Default(OrderType.product) OrderType typeCreate,
    @Default(0) double total,
    @Default(false) bool selectedOrderRed,
    String? note,
    String? mUuid,
    int? idBranch,
  }) = _OrderCreateV2State;
}
