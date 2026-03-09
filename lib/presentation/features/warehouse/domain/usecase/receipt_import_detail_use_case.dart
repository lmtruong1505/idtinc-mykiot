import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_detail_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';

@injectable
class ReceiptImportDetailUseCase {
  final WarehouseRepository _repository;

  ReceiptImportDetailUseCase(this._repository);
  Future<BaseResponseModel<List<ReceiptImportDetailModel>>> getListLot(
    ReceiptDetailInput input,
  ) async {
    final res = await _repository.getListLot(input);
    return res;
  }

  Future<BaseResponseModel<ReceitExportModel>> getReceiptInfor(
    ReceiptDetailInput input,
  ) async {
    final res = await _repository.getReceiptInfor(input);
    return res;
  }
}

class ReceiptDetailInput extends BaseInput {
  final int? warehouseId;
  final int? id;

  ReceiptDetailInput({
    this.warehouseId,
    this.id,
  });
}
