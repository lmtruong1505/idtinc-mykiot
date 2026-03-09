import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import '../repositories/order_repository.dart';


@injectable
class OrderHubActionUseCase
    extends BaseFutureUseCase<OrderHubActionInput, OrderHubActionOutput> {
  OrderHubActionUseCase(this._orderRepository);

  final OrderRepository _orderRepository;

  @override
  Future<OrderHubActionOutput> buildUseCase(OrderHubActionInput input) async {
    final res = await _orderRepository.orderHubAction(
      accept: input.accept,
      workspace: input.workspace,
      notiId: input.notiId,
    );
    return OrderHubActionOutput(response: res);
  }
}

class OrderHubActionInput extends BaseInput {
  final bool accept;
  final int workspace;
  final int notiId;
  OrderHubActionInput({
    required this.accept,
    required this.workspace,
    required this.notiId,
  });
}

class OrderHubActionOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  OrderHubActionOutput({required this.response});
}
