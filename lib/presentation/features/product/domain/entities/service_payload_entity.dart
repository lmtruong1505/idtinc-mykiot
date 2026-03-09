import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_payload_entity.freezed.dart';
part 'service_payload_entity.g.dart';

@freezed
class ServicePayloadEntity with _$ServicePayloadEntity{
  const ServicePayloadEntity._();

  const factory ServicePayloadEntity({
    @Default([]) List<String> image,
    final String? code,
    final String? title,
    final String? entity,
    final int? staff,
    final String? frequency,
    final String? unit,
    final double? price,
    final String? description,
    final int? company,
    final int? userCreated,
    final int? userUpdated,
    final String? createdAt,
    final String? updatedAt,
    final int? reminderTime,
    final int? congTyDk,
    final String? soQuyetDinh,
    final String? soDangKy,
    final int? brand,
    final int? type,
    final String? actionTime,
    final String? chiDinh,
    final String? chongChiDinh,
    final String? congDung,
    final String? tacDungPhu,
    final String? luuY,
    final String? hinhThuc,
    final String? message,
    final bool? active,
  }) = _ServicePayloadEntity;

  factory ServicePayloadEntity.fromJson(Map<String, dynamic> json) =>
      _$ServicePayloadEntityFromJson(json);
}