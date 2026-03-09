import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/authentication/domain/entities/account_entity.dart';

part 'account_state.freezed.dart';

@freezed
class AccountState with _$AccountState {
  factory AccountState({
    AccountEntity? account,
  }) = _AccountState;
}
