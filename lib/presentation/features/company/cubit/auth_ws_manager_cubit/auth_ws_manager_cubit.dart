import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/auth_ws_entity.dart';
import '../../domain/usecase/auth_ws_create_use_case.dart';
import '../../domain/usecase/auth_ws_get_use_case.dart';
import '../../domain/usecase/auth_ws_update_use_case.dart';
import '../../domain/usecase/auth_ws_verify_use_case.dart';
import 'auth_ws_manager_state.dart';

@singleton
class AuthWsManagerCubit extends Cubit<AuthWsManagerState> {
  AuthWsManagerCubit(
    this._authWsUpdateUseCase,
    this._authWsCreateUseCase,
    this._authWsGetUseCase,
    this._authWsVerifyUseCase,
  ) : super(const AuthWsManagerState()) {
    emit(
      state.copyWith(
        endDate: DateTime.now().add(const Duration(days: 365)),
      ),
    );
  }

  final AuthWsUpdateUseCase _authWsUpdateUseCase;
  final AuthWsCreateUseCase _authWsCreateUseCase;
  final AuthWsGetUseCase _authWsGetUseCase;
  final AuthWsVerifyUseCase _authWsVerifyUseCase;

  void stateChange({
    bool? isAuth,
  }) {
    emit(
      state.copyWith(
        isAuthen: isAuth ?? state.isAuthen,
      ),
    );
  }

  Future<void> getAuthWs(int id) async {
    final input = AuthWsGetInput(id);
    final res = await _authWsGetUseCase.execute(input);
    emit(state.copyWith(authWs: res.response.data));
  }

  Future<AuthWsEntity?> createAuthWs(int id, String password) async {
    final input = AuthWsCreateInput(
      wsId: id,
      password: password,
      endDate: state.endDate,
    );
    final res = await _authWsCreateUseCase.execute(input);
    emit(state.copyWith(authWs: res.response.data));
    return res.response.data;
  }

  Future<AuthWsEntity?> updateAuthWs(int id, String password) async {
    final input = AuthWsUpdateInput(
      wsId: id,
      password: password,
    );
    final res = await _authWsUpdateUseCase.execute(input);
    emit(state.copyWith(authWs: res.response.data));
    return res.response.data;
  }

  Future<bool> verifyCode(int id, String password) async {
    final response = await _authWsVerifyUseCase.execute(
      AuthWsVerifyInput(
        wsId: id,
        password: password,
      ),
    );
    emit(state.copyWith(isAuthen: response.response.code == 200));
    return response.response.code == 200;
  }
}
