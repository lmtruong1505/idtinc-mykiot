import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/presentation/features/company/data/mapper/bank_mapper.dart';
import 'package:pharmago/presentation/features/company/domain/entities/bank_entity.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../repositories/bank_repository.dart';

@injectable
class ListBankUseCase extends BaseFutureUseCase<ListBankInput, ListBankOutput> {
  ListBankUseCase(this._repo, this._mapper);

  final BankRepository _repo;
  final BankMapper _mapper;

  @override
  Future<ListBankOutput> buildUseCase(ListBankInput input) async {
    final res = await _repo.getBanks();
    final dataEntity = _mapper.mapToListEntity(res.data);
    final output = ListBankOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class ListBankInput extends BaseInput {
  ListBankInput();
}

class ListBankOutput extends BaseOutput {
  final BaseResponseModel<List<BankEntity>> response;

  ListBankOutput({
    required this.response,
  });
}
