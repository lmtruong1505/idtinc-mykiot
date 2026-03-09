import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/order/data/mapper/order_count_entity_mapper.dart';
import 'package:pharmago/presentation/features/order/data/mapper/order_preview_entity_mapper.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_preview_entity.dart';
import 'package:pharmago/presentation/features/order/domain/repositories/order_repository.dart';

@injectable
class OrderListUseCase
    extends BaseFutureUseCase<OrderListInput, OrderListOutput> {
  final OrderRepository _orderRepository;
  final OrderPreviewEntityMapper _orderPreviewEntityMapper;
  final OrderCountEntityMapper _orderCountEntityMapper;

  OrderListUseCase(
    this._orderPreviewEntityMapper,
    this._orderRepository,
    this._orderCountEntityMapper,
  );

  @override
  Future<OrderListOutput> buildUseCase(OrderListInput input) async {
    final res = await _orderRepository.getList(
      company: input.company,
      limit: input.limit,
      page: input.page,
      search: input.search,
      type: input.type,
      warehouse: input.warehouse,
      orderBy: input.orderBy,
      createdFrom: input.createdFrom,
      createdTo: input.createdTo,
      updatedFrom: input.updatedFrom,
      updatedTo: input.updatedTo,
    );

    final dataEntity = _orderPreviewEntityMapper.mapToListEntity(res.data);
    final extraEntity = _orderCountEntityMapper.mapToEntity(res.extra);
    final output = OrderListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
        extra: extraEntity,
      ),
    );
    return output;
  }
}

class OrderListInput extends BaseInput {
  final int company;
  final int? warehouse;
  final String? search;
  final String? type;
  final int? page;
  final int? limit;
  final String? orderBy;
  final DateTime? createdFrom;
  final DateTime? createdTo;
  final DateTime? updatedFrom;
  final DateTime? updatedTo;
  OrderListInput({
    required this.company,
    this.limit,
    this.page,
    this.search,
    this.type,
    this.warehouse,
    this.createdFrom,
    this.createdTo,
    this.orderBy,
    this.updatedFrom,
    this.updatedTo,
  });
}

class OrderListOutput extends BaseOutput {
  final BaseResponseModel<List<OrderPreviewEntity>> response;
  OrderListOutput({required this.response});
}
