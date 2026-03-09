import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_ws_entity.dart';

part 'auth_ws_manager_state.freezed.dart';

@freezed
abstract class AuthWsManagerState with _$AuthWsManagerState {
  const factory AuthWsManagerState({
    @Default('') String password,
    AuthWsEntity? authWs,
    DateTime? endDate,
    @Default(false) bool isAuthen,
  }) = _AuthWsManagerState;
}

extension GetAuthWsManagerState on AuthWsManagerState {
  String? get typeCodeWarehouse {
    return switch (isAuthen) {
      true => null,
      false => 'KGD',
    };
  }
}
