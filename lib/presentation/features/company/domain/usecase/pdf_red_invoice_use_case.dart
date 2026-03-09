import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';

import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../enum/enum_data.dart';
import '../repositories/electric_invoice_repository.dart';

@injectable
class PdfRedInvoiceUseCase extends BaseFutureUseCase<PdfRedInvoiceUseCaseInput,
    PdfRedInvoiceUseCaseOutput> {
  final ElectricInvoiceRepository _electricInvoiceRepository;
  PdfRedInvoiceUseCase(this._electricInvoiceRepository);

  @override
  Future<PdfRedInvoiceUseCaseOutput> buildUseCase(
    PdfRedInvoiceUseCaseInput input,
  ) async {
    final res = await _electricInvoiceRepository.pdfRedInvoice(
      orderId: input.orderId,
      publisher: input.publisher,
    );
    return PdfRedInvoiceUseCaseOutput(
      response: res,
    );
  }
}

class PdfRedInvoiceUseCaseInput extends BaseInput {
  final int orderId;
  final RedInvoicePublisher publisher;
  PdfRedInvoiceUseCaseInput({
    required this.orderId,
    required this.publisher,
  });
}

class PdfRedInvoiceUseCaseOutput extends BaseOutput {
  final BaseResponseModel<File> response;
  PdfRedInvoiceUseCaseOutput({
    required this.response,
  });
}
