

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../entities/payload_create_import_receipt_entity.dart';
import '../repositories/warehouse_repository.dart';

@injectable
class CreateImportReceiptUsecase extends BaseFutureUseCase<CreateImportReceiptInput, CreateImportReceiptOutput> {
  CreateImportReceiptUsecase(this._warehouseRepository);
  final WarehouseRepository _warehouseRepository;
  
  @override
  Future<CreateImportReceiptOutput> buildUseCase(CreateImportReceiptInput input) async {
    final res = await _warehouseRepository.createImportReceipt(input.payload);
    final output = CreateImportReceiptOutput(
      response: res,
    );
    return output;
  }
}

class CreateImportReceiptInput extends BaseInput {
  final PayloadCreateImportReceiptEntity payload;
  CreateImportReceiptInput({required this.payload});
}

class CreateImportReceiptOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  CreateImportReceiptOutput({required this.response});
}