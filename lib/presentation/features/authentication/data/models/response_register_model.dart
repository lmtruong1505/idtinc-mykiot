
import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_register_model.freezed.dart';
part 'response_register_model.g.dart';

@freezed
class ResponseRegisterModel with _$ResponseRegisterModel {
  const ResponseRegisterModel._();

  const factory ResponseRegisterModel({
    String? username,
    @JsonKey(name: 'full_name') String? fullName,
    String? email,
    @JsonKey(name: 'verify_id') String? verifyId,
  }) = _ResponseRegisterModel;

  factory ResponseRegisterModel.fromJson(Map<String, dynamic> json) => _$ResponseRegisterModelFromJson(json);

}