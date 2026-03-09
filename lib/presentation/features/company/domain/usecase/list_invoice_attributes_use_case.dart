import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';

import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../entities/invoice_attributes_entity.dart';
import '../repositories/electric_invoice_repository.dart';

@injectable
class ListInvoiceAttributesUseCase extends BaseFutureUseCase<
    ListInvoiceAttributesUseCaseInput, ListInvoiceAttributesUseCaseOutput> {
  final ElectricInvoiceRepository _electricInvoiceRepository;
  ListInvoiceAttributesUseCase(this._electricInvoiceRepository);

  @override
  Future<ListInvoiceAttributesUseCaseOutput> buildUseCase(
    ListInvoiceAttributesUseCaseInput input,
  ) async {
    final res = await _electricInvoiceRepository.listInvoiceAttributes(
      workspace: input.workspace,
    );
    return ListInvoiceAttributesUseCaseOutput(
      response: res,
    );
  }
}

class ListInvoiceAttributesUseCaseInput extends BaseInput {
  final int workspace;
  ListInvoiceAttributesUseCaseInput({
    required this.workspace,
  });
}

class ListInvoiceAttributesUseCaseOutput extends BaseOutput {
  final BaseResponseModel<List<InvoiceAttributesEntity>> response;
  ListInvoiceAttributesUseCaseOutput({
    required this.response,
  });
}
