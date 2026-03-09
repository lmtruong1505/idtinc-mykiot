import 'package:freezed_annotation/freezed_annotation.dart';
part 'account_create_model.freezed.dart';
part 'account_create_model.g.dart';

@freezed
class UserCreatedData with _$UserCreatedData {
  const factory UserCreatedData({
    @Default(null) int? id,
    @Default(null) String? fullName,
    @Default(null) String? keyAccount,
  }) = _UserCreatedData;

  factory UserCreatedData.fromJson(Map<String, dynamic> json) => _$UserCreatedDataFromJson(json);
}