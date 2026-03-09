import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../entities/payload_create_import_receipt_entity.dart';
import '../repositories/warehouse_repository.dart';

@injectable
class UpdateImportReceiptUsecase extends BaseFutureUseCase<UpdateImportReceiptInput, UpdateImportReceiptOutput> {
  UpdateImportReceiptUsecase(this._warehouseRepository);
  final WarehouseRepository _warehouseRepository;
  
  @override
  Future<UpdateImportReceiptOutput> buildUseCase(UpdateImportReceiptInput input) async {
    final res = await _warehouseRepository.updateImportReceipt(input.payload);
    final output = UpdateImportReceiptOutput(
      response: res,
    );
    return output;
  }
}

class UpdateImportReceiptInput extends BaseInput {
  final PayloadUpdateImportReceiptEntity payload;
  UpdateImportReceiptInput({required this.payload});
}

class UpdateImportReceiptOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  UpdateImportReceiptOutput({required this.response});
}