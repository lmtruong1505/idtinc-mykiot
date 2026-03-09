import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_entity.freezed.dart';

@freezed
class StaffEntity with _$StaffEntity{
  const StaffEntity._();

  const factory StaffEntity({
    int? id,
    String? username,
    String? fullName,
    String? email,
    String? verifyId,
    String? oaId,
    DateTime? passwordChangedAt,
    DateTime? createdAt,
  }) = _StaffEntity;
}