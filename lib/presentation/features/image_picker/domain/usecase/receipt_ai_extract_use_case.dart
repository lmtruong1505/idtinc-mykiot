import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../entities/receipt_ai_extract_response.dart';
import '../repository/image_picker_repository.dart';

@injectable
class ReceiptAiExtractUsecase extends BaseFutureUseCase<ReceiptAiExtractInput, ReceiptAiExtractOutput> {
  ReceiptAiExtractUsecase(this._imagePickerRepository);
  final ImagePickerRepository _imagePickerRepository;
  
  @override
  Future<ReceiptAiExtractOutput> buildUseCase(ReceiptAiExtractInput input) async {
    final res = await _imagePickerRepository.extractInvoice(input.payload);
    final output = ReceiptAiExtractOutput(
      response: res,
    );
    return output;
  }
}

class ReceiptAiExtractInput extends BaseInput {
  final ReceiptAiExtractPayload payload;
  ReceiptAiExtractInput({required this.payload});
}

class ReceiptAiExtractOutput extends BaseOutput {
  final BaseResponseModel<ReceiptAiExtractResponse> response;
  ReceiptAiExtractOutput({required this.response});
}