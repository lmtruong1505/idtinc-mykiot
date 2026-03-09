

import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/shipment_data_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';

@injectable
class ScanShipmentDetailUseCase {
  final WarehouseRepository _repository;
  ScanShipmentDetailUseCase(
    this._repository,
  );

  Future<ShipmentItemEntity?> getScanShipmentDetail(
    ScanShipmentDetailInput input,
  ) async {
    final res = await _repository.scanShipmentDetail(code: input.code);
    return res.data;
  }
}

class ScanShipmentDetailInput extends BaseInput {
  final String code;

  ScanShipmentDetailInput({
    required this.code,
  });
}
