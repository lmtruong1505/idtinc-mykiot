

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/order/data/models/order_count_model.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_count_entity.dart';

@injectable
class OrderCountEntityMapper extends BaseDataMapper<OrderCountModel, OrderCountEntity> {
  @override
  OrderCountEntity mapToEntity(OrderCountModel? data) {
    return OrderCountEntity(
      draft: data?.draft ?? 0,
      inProcess: data?.inProcess ?? 0,
      complete: data?.complete ?? 0,
      cancel: data?.cancel ?? 0,
      service: data?.service ?? 0,
      product: data?.product ?? 0,
    );
  }
}