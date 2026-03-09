import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/models/order_wm_payload_model.dart';
import '../entities/order_wm_payload_entity.dart';
import '../repositories/order_wm_repository.dart';

@injectable
class OrderWmCreateUseCase
    extends BaseFutureUseCase<OrderWmCreateInput, OrderWmCreateOutput> {
  final OrderWmRepository _orderRepository;

  OrderWmCreateUseCase(this._orderRepository);

  @override
  Future<OrderWmCreateOutput> buildUseCase(OrderWmCreateInput input) async {
    final payload =
        OrderWmPayloadModel.fromJson(input.orderCreateEntity!.toJson());
    final res = await _orderRepository.createOrder(payload);

    var resModel = BaseResponseModel<int>(
      code: res.code,
      message: res.message,
      data: res.data,
    );
    if (res.code == 200) {
      resModel = resModel.copyWith(
        data: res.data,
      );
    }
    return OrderWmCreateOutput(resModel);
  }
}

class OrderWmCreateInput extends BaseInput {
  final OrderWmCreatePayloadEntity? orderCreateEntity;
  OrderWmCreateInput({
    this.orderCreateEntity,
  });
}

class OrderWmCreateOutput extends BaseOutput {
  final BaseResponseModel<int> response;

  OrderWmCreateOutput(this.response);
}
