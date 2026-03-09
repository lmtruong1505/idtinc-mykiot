import 'package:pharmago/data/models/base/response.dart';

import '../entities/receipt_ai_extract_response.dart';

abstract class ImagePickerRepository {
  Future<BaseResponseModel<ReceiptAiExtractResponse>> extractInvoice(
    ReceiptAiExtractPayload payload,
  );
}
