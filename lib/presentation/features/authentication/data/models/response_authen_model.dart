import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_model.dart';

part 'response_authen_model.freezed.dart';
part 'response_authen_model.g.dart';

@freezed
class ResponseAuthModel with _$ResponseAuthModel {
  const ResponseAuthModel._();

  const factory ResponseAuthModel({
    AccountModel? account,
    @JsonKey(name: 'access_token') String? accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
  }) = _ResponseAuthModel;

  factory ResponseAuthModel.fromJson(Map<String, dynamic> json) => _$ResponseAuthModelFromJson(json);
}