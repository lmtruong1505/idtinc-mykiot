import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';

import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../repositories/electric_invoice_repository.dart';

@injectable
class CreateViettelAccountUseCase extends BaseFutureUseCase<
    CreateViettelAccountInput, CreateViettelAccountOutput> {
  final ElectricInvoiceRepository _electricInvoiceRepository;
  CreateViettelAccountUseCase(this._electricInvoiceRepository);

  @override
  Future<CreateViettelAccountOutput> buildUseCase(
    CreateViettelAccountInput input,
  ) async {
    final res = await _electricInvoiceRepository.createViettelAccount(
      username: input.username,
      password: input.password,
      workspaceId: input.workspaceId,
    );
    return CreateViettelAccountOutput(response: res);
  }
}

class CreateViettelAccountInput extends BaseInput {
  final String username;
  final String password;
  final int workspaceId;
  CreateViettelAccountInput({
    required this.password,
    required this.username,
    required this.workspaceId,
  });
}

class CreateViettelAccountOutput extends BaseOutput {
  final BaseResponseModel response;
  CreateViettelAccountOutput({
    required this.response,
  });
}
