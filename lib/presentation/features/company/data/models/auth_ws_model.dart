import '../../domain/entities/auth_ws_entity.dart';

class AuthWsModel extends AuthWsEntity {
  AuthWsModel({
    super.createdAt,
    super.decryptedPassword,
    super.endDate,
    super.id,
    super.status,
    super.updatedAt,
    super.workspace,
  });

  factory AuthWsModel.fromJson(Map<String, dynamic> json) => AuthWsModel(
        id: json['id'],
        workspace: json['workspace'],
        decryptedPassword: json['decrypted_password'],
        endDate:
            json['end_date'] == null ? null : DateTime.parse(json['end_date']),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        status: json['status'],
      );
}
