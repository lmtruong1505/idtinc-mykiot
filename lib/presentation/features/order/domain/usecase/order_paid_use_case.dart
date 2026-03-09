import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/order/domain/entities/payment_v2_entity.dart';
import 'package:pharmago/presentation/features/order/domain/repositories/order_repository.dart';

@injectable
class OrderPaidUseCase extends BaseFutureUseCase<OrderPaidInput, OrderPaidOutput> {

  OrderPaidUseCase(this._orderRepository);
  final OrderRepository _orderRepository;

  @override
  Future<OrderPaidOutput> buildUseCase(OrderPaidInput input) async {
    final res = await  _orderRepository.paidOrder(
      id: input.id,
      payload: {
        'amount': input.payment.amount,
        'method': input.payment.method?.code ?? PaymentMethod.cash.code,
      },
    );
    final output = OrderPaidOutput(
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data,
      ),
    );
    return output;
  }

}

class OrderPaidInput extends BaseInput {
  OrderPaidInput({required this.id, required this.payment});
  final int id;
  final PaymentV2Entity payment;
}

class OrderPaidOutput extends BaseOutput {
  final BaseResponseModel response;
  OrderPaidOutput(this.response);
}