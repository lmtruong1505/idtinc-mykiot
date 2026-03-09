class InvoiceAttributesEntity {
  final int? id;
  final String? name;
  final String? pattern;
  final String? serial;
  final int? workspace;
  final bool? defaultFlag;

  InvoiceAttributesEntity({
    this.id,
    this.name,
    this.pattern,
    this.serial,
    this.workspace,
    this.defaultFlag,
  });

  InvoiceAttributesEntity copyWith({
    int? id,
    String? name,
    String? pattern,
    String? serial,
    int? workspace,
    bool? defaultFlag,
  }) =>
      InvoiceAttributesEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        pattern: pattern ?? this.pattern,
        serial: serial ?? this.serial,
        workspace: workspace ?? this.workspace,
        defaultFlag: defaultFlag ?? this.defaultFlag,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'pattern': pattern,
        'serial': serial,
        'workspace': workspace,
        'default_flag': defaultFlag,
      };
}
