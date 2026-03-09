import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';

import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/mapper/order_detail_mapper.dart';
import '../entities/order_detail_entity.dart';
import '../repositories/order_repository.dart';

@injectable
class OrderDetailUseCase
    extends BaseFutureUseCase<OrderDetailInput, OrderDetailOutput> {
  OrderDetailUseCase(
    this._orderRepository,
    this._orderDetailEntityMapper,
  );

  final OrderRepository _orderRepository;
  final OrderDetailMapper _orderDetailEntityMapper;

  @override
  Future<OrderDetailOutput> buildUseCase(OrderDetailInput input) async {
    final res = await _orderRepository.getDetail(id: input.id);
    final dataEntity = _orderDetailEntityMapper.mapToEntity(res.data);
    final output = OrderDetailOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class OrderDetailInput extends BaseInput {
  final int id;
  OrderDetailInput({required this.id});
}

class OrderDetailOutput extends BaseOutput {
  final BaseResponseModel<OrderDetailEntity> response;
  OrderDetailOutput({required this.response});
}
