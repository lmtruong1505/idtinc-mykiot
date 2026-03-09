import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/order/data/mapper/order_entity_mapper.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_entity.dart';
import 'package:pharmago/presentation/features/order/domain/repositories/order_repository.dart';

@injectable
class OrderScanUseCase
    extends BaseFutureUseCase<OrderScanInput, OrderScanOutput> {
  OrderScanUseCase(
    this._orderRepository,
    this._orderEntityMapper,
  );
  final OrderRepository _orderRepository;
  final OrderEntityMapper _orderEntityMapper;

  @override
  Future<OrderScanOutput> buildUseCase(OrderScanInput input) async {
    final res = await _orderRepository.scan(code: input.code);
    final dataEntity = _orderEntityMapper.mapToEntity(res.data);
    final output = OrderScanOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class OrderScanInput extends BaseInput {
  final String code;
  OrderScanInput({required this.code});
}

class OrderScanOutput extends BaseOutput {
  final BaseResponseModel<OrderEntity> response;
  OrderScanOutput({required this.response});
}
