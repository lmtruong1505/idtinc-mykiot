import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/account/domain/repositories/account_repository.dart';
import 'package:pharmago/presentation/features/authentication/data/mapper/account_entity_mapper.dart';
import 'package:pharmago/presentation/features/authentication/domain/entities/account_entity.dart';

@injectable
class AccountUseCase {
  final AccountRepository _repository;
  final AccountEntityMapper _mapper;
  AccountUseCase(this._repository, this._mapper);

  Future<AccountEntity> getDetail() async {
    final data = await _repository.getDetail();
    return _mapper.mapToEntity(data);
  }

  Future<BaseResponseModel> update(AccountEntity account) async {
    return await _repository.update({});
  }

  Future<BaseResponseModel> inactive() async {
    return await _repository.inactive();
  }
}
