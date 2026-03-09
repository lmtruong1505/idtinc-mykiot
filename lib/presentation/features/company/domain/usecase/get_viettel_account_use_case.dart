import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';

import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../repositories/electric_invoice_repository.dart';

@injectable
class GetViettelAccountUseCase
    extends BaseFutureUseCase<GetViettelAccountInput, GetViettelAccountOutput> {
  final ElectricInvoiceRepository _electricInvoiceRepository;
  GetViettelAccountUseCase(this._electricInvoiceRepository);

  @override
  Future<GetViettelAccountOutput> buildUseCase(
    GetViettelAccountInput input,
  ) async {
    final res = await _electricInvoiceRepository.getViettelAccount(
      workspaceId: input.workspaceId,
    );
    return GetViettelAccountOutput(
      username: res?['username'],
      password: res?['password'],
    );
  }
}

class GetViettelAccountInput extends BaseInput {
  final int workspaceId;
  GetViettelAccountInput({
    required this.workspaceId,
  });
}

class GetViettelAccountOutput extends BaseOutput {
  final String? username;
  final String? password;
  GetViettelAccountOutput({
    this.password,
    this.username,
  });
}
