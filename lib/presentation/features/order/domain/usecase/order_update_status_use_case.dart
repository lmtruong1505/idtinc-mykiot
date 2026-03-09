import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';

import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../repositories/order_repository.dart';

@injectable
class OrderUpdateStatusUseCase
    extends BaseFutureUseCase<OrderUpdateStatusInput, OrderUpdateStatusOutput> {
  OrderUpdateStatusUseCase(
    this._orderRepository,
  );

  final OrderRepository _orderRepository;

  @override
  Future<OrderUpdateStatusOutput> buildUseCase(
    OrderUpdateStatusInput input,
  ) async {
    final res = await _orderRepository.updateStatus(
      id: input.id,
      code: input.code,
    );
    final output = OrderUpdateStatusOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
      ),
    );
    return output;
  }
}

class OrderUpdateStatusInput extends BaseInput {
  final int id;
  final String code;
  OrderUpdateStatusInput({
    required this.id,
    required this.code,
  });
}

class OrderUpdateStatusOutput extends BaseOutput {
  final BaseResponseModel response;
  OrderUpdateStatusOutput({required this.response});
}
