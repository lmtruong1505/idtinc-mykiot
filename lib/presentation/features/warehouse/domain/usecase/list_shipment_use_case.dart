

import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/shipment_data_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';

@injectable
class ListShipmentUseCase {
  final WarehouseRepository _repository;
  ListShipmentUseCase(
    this._repository,
  );

  Future<List<ShipmentItemEntity>?> getListShipment(
    ListShipmentInput input,
  ) async {
    final res = await _repository.getListShipment(
      workspace: input.workspace,
      offset: input.offset,
      limit: input.limit,
      search: input.search,
    );
    return res.data;
  }
}

class ListShipmentInput extends BaseInput {
  final int workspace;
  final int offset;
  final int limit;
  final String? search;

  ListShipmentInput({
    required this.workspace,
    this.offset = 0,
    this.limit = 20,
    this.search,
  });
}
