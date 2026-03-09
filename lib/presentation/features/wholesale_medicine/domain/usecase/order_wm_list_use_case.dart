import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/data/mapper/order_wm_mapper.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/entities/order_wm_entity.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../repositories/order_wm_repository.dart';

@injectable
class OrderWmListUseCase
    extends BaseFutureUseCase<OrderWmListInput, OrderWmListOutput> {
  final OrderWmRepository _orderRepository;
  final OrderWmMapper _orderWmMapper;

  OrderWmListUseCase(
    this._orderRepository,
    this._orderWmMapper,
  );

  @override
  Future<OrderWmListOutput> buildUseCase(OrderWmListInput input) async {
    final res = await _orderRepository.list(
      page: input.page,
      limit: input.limit,
      search: input.search,
      status: input.status,
    );
    final dataEntity = _orderWmMapper.mapToListEntity(res.data);
    final resModel = BaseResponseModel<List<OrderWmDetailEntity>>(
      code: res.code,
      message: res.message,
      data: dataEntity,
    );
    return OrderWmListOutput(resModel);
  }
}

class OrderWmListInput extends BaseInput {
  final int? page;
  final int? limit;
  final String? search;
  final int? status;
  OrderWmListInput({
    this.page,
    this.limit,
    this.search,
    this.status,
  });
}

class OrderWmListOutput extends BaseOutput {
  final BaseResponseModel<List<OrderWmDetailEntity>> response;

  OrderWmListOutput(this.response);
}
