class AuthWsEntity {
  final int? id;
  final int? workspace;
  final String? decryptedPassword;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;

  AuthWsEntity({
    this.id,
    this.workspace,
    this.decryptedPassword,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  AuthWsEntity copyWith({
    int? id,
    int? workspace,
    String? decryptedPassword,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
  }) =>
      AuthWsEntity(
        id: id ?? this.id,
        workspace: workspace ?? this.workspace,
        decryptedPassword: decryptedPassword ?? this.decryptedPassword,
        endDate: endDate ?? this.endDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'workspace': workspace,
        'decrypted_password': decryptedPassword,
        'end_date': endDate?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'status': status,
      };
}
