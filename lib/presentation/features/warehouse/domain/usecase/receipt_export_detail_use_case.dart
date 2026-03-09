import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';

import '../entities/receipt_export_entity.dart';
import '../repositories/warehouse_repository.dart';

@injectable
class ReceiptExportDetailUseCase {
  final WarehouseRepository _repository;

  ReceiptExportDetailUseCase(this._repository);
  Future<BaseResponseModel<List<ReceiptItemEntity>>> getListLot(
    ReceiptExportDetailInput input,
  ) async {
    final res = await _repository.listShipmentExportReceipt(id: input.id);
    return res;
  }

  Future<BaseResponseModel<ReceiptExportEntity>> getReceiptInfor(
    ReceiptExportDetailInput input,
  ) async {
    final res = await _repository.detailExportReceipt(id: input.id);
    return res;
  }
}

class ReceiptExportDetailInput extends BaseInput {
  final int id;
  final int? warehouseId;

  ReceiptExportDetailInput({
    required this.id,
    this.warehouseId,
  });
}
