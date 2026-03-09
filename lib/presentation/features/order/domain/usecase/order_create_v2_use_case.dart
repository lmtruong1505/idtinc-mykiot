import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_payload_v2_entity.dart';
import 'package:pharmago/presentation/features/order/domain/repositories/order_repository.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../entities/item_order_payload_v2_entity.dart';

@injectable
class OrderCreateV2UseCase extends BaseFutureUseCase <OrderCreateV2Input, OrderCreateV2Output>{
  OrderCreateV2UseCase(this._orderRepository);

  final OrderRepository _orderRepository;

  @override
  Future<OrderCreateV2Output> buildUseCase(OrderCreateV2Input input) async {
    final res = await _orderRepository.createOrderV2(
      order: input.order.toJson(),
      items: input.items.map((e) => e.toJson()).toList(),
    );
    return OrderCreateV2Output(response: res);
  }
}

class OrderCreateV2Input extends BaseInput{
  final OrderPayloadV2Entity order;
  final List<ItemOrderPayloadV2Entity> items;
  OrderCreateV2Input({required this.order, required this.items});
}

class OrderCreateV2Output extends BaseOutput{
  final BaseResponseModel<int> response;
  OrderCreateV2Output({required this.response});
}