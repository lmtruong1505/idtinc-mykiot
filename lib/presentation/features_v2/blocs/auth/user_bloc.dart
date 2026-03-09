import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/repositories/auth/auth_repository.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../features/authentication/domain/entities/account_entity.dart';

// class UserModel

class UserBloc extends Cubit<AccountEntity> {
  UserBloc() : super(const AccountEntity());
  final _localDB = AppSharedPreference.instance;

  void getData() async {
    final fullName = _localDB.getString(PrefKeys.userFullName);
    final userCode = _localDB.getString(PrefKeys.userCode);
    final avatar = _localDB.getString(PrefKeys.avatar);
    final userName = _localDB.getString(PrefKeys.username);
    emit(
      state.copyWith(
        fullName: fullName,
        code: userCode,
        avatar: avatar,
        phone: userName,
      ),
    );
  }
}
