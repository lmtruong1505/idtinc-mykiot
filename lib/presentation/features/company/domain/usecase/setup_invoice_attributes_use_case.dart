import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';

import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../entities/invoice_attributes_entity.dart';
import '../repositories/electric_invoice_repository.dart';

@injectable
class SetupInvoiceAttributesUseCase extends BaseFutureUseCase<
    SetupInvoiceAttributesUseCaseInput, SetupInvoiceAttributesUseCaseOutput> {
  final ElectricInvoiceRepository _electricInvoiceRepository;
  SetupInvoiceAttributesUseCase(this._electricInvoiceRepository);

  @override
  Future<SetupInvoiceAttributesUseCaseOutput> buildUseCase(
    SetupInvoiceAttributesUseCaseInput input,
  ) async {
    final res = await _electricInvoiceRepository.createInvoiceAttributes(
      name: input.name,
      pattern: input.pattern,
      serial: input.serial,
      workspace: input.workspace,
      defaultFlag: input.defaultFlag,
    );
    return SetupInvoiceAttributesUseCaseOutput(
      response: res,
    );
  }
}

class SetupInvoiceAttributesUseCaseInput extends BaseInput {
  final String name;
  final String pattern;
  final String serial;
  final int workspace;
  final bool defaultFlag;
  SetupInvoiceAttributesUseCaseInput({
    required this.name,
    required this.pattern,
    required this.serial,
    required this.workspace,
    required this.defaultFlag,
  });
}

class SetupInvoiceAttributesUseCaseOutput extends BaseOutput {
  final BaseResponseModel<InvoiceAttributesEntity> response;
  SetupInvoiceAttributesUseCaseOutput({
    required this.response,
  });
}
