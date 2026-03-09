

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../entities/payload_create_export_receipt_entity.dart';
import '../repositories/warehouse_repository.dart';

@injectable
class CreateExportReceiptUsecase extends BaseFutureUseCase<CreateExportReceiptInput, CreateExportReceiptOutput> {
  CreateExportReceiptUsecase(this._warehouseRepository);
  final WarehouseRepository _warehouseRepository;
  
  @override
  Future<CreateExportReceiptOutput> buildUseCase(CreateExportReceiptInput input) async {
    final res = await _warehouseRepository.createExportReceipt(input.payload);
    final output = CreateExportReceiptOutput(
      response: res,
    );
    return output;
  }
}

class CreateExportReceiptInput extends BaseInput {
  final PayloadCreateExportReceiptEntity payload;
  CreateExportReceiptInput({required this.payload});
}

class CreateExportReceiptOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  CreateExportReceiptOutput({required this.response});
}