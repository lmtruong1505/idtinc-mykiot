import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_info_payload_entity.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_item_payload_entity.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_payment_item_payload_entity.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_payment_payload_entity.dart';
import 'package:pharmago/presentation/features/order/domain/repositories/order_repository.dart';

import '../entities/order_service_item_payload_entity.dart';

@injectable
class OrderCreateUseCase
    extends BaseFutureUseCase<OrderCreateInput, OrderCreateOutput> {
  OrderCreateUseCase(this._orderRepository);

  final OrderRepository _orderRepository;

  @override
  Future<OrderCreateOutput> buildUseCase(OrderCreateInput input) async {
    final res = await _orderRepository.createOrder(
      order: input.orderInfo.toJson(),
      orderItem: input.orderItems.map((e) => e.toJson()).toList(),
      orderPayment: input.orderPayment.toJson(),
      orderPaymentItem: input.orderPaymentItem.map((e) => e.toJson()).toList(),
      orderServiceItem: input.orderServiceItem.map((e) => e.toJson()).toList(),
      warehouse: input.warehouse,
      mbUuid: input.mbUuid,
    );
    return OrderCreateOutput(response: res);
  }
}

class OrderCreateInput extends BaseInput {
  final OrderInfoPayloadEntity orderInfo;
  final List<OrderItemPayloadEntity> orderItems;
  final OrderPaymentPayloadEntity orderPayment;
  final List<OrderPaymentItemPayloadEntity> orderPaymentItem;
  final List<OrderServiceItemPayloadEntity> orderServiceItem;
  final int warehouse;
  final String? mbUuid;
  OrderCreateInput({
    required this.orderInfo,
    required this.orderItems,
    required this.orderPayment,
    required this.orderPaymentItem,
    required this.warehouse,
    required this.orderServiceItem,
    this.mbUuid,
  });
}

class OrderCreateOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  OrderCreateOutput({required this.response});
}
