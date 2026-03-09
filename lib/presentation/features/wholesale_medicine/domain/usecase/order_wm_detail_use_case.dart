import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/data/mapper/order_wm_mapper.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/entities/order_wm_entity.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../repositories/order_wm_repository.dart';

@injectable
class OrderWmDetailUseCase
    extends BaseFutureUseCase<OrderWmDetailInput, OrderWmDetailOutput> {
  final OrderWmRepository _orderRepository;
  final OrderWmMapper _orderWmMapper;
  OrderWmDetailUseCase(
    this._orderRepository,
    this._orderWmMapper,
  );

  @override
  Future<OrderWmDetailOutput> buildUseCase(OrderWmDetailInput input) async {
    final res = await _orderRepository.detail(id: input.id);
    final dataEntity = _orderWmMapper.mapToEntity(res.data);
    var resModel = BaseResponseModel<OrderWmDetailEntity>(
      code: res.code,
      message: res.message,
      data: dataEntity,
    );
    if (res.code != 200) {
      resModel = resModel.copyWith(
        data: null,
      );
    }
    return OrderWmDetailOutput(resModel);
  }
}

class OrderWmDetailInput extends BaseInput {
  final int id;
  OrderWmDetailInput({
    required this.id,
  });
}

class OrderWmDetailOutput extends BaseOutput {
  final BaseResponseModel<OrderWmDetailEntity> response;

  OrderWmDetailOutput(this.response);
}
