

import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/shipment_data_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';

@injectable
class ListShipmentByProductUseCase {
  final WarehouseRepository _repository;
  ListShipmentByProductUseCase(
    this._repository,
  );

  Future<ShipmentDataEntity?> getListShipmentByProduct(
    ListShipmentByProductInput input,
  ) async {
    final res = await _repository.getListShipmentByProduct(
      productId: input.productId,
      workspace: input.workspace,
    );
    return res.data;
  }
}

class ListShipmentByProductInput extends BaseInput {
  final int productId;
  final int workspace;

  ListShipmentByProductInput({
    required this.productId,
    required this.workspace,
  });
}
