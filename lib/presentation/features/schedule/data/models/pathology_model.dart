class PathologyModel {
  final int? id;
  final String? code;
  final dynamic name;
  final String? nameVn;

  PathologyModel({
    this.id,
    this.code,
    this.name,
    this.nameVn,
  });

  PathologyModel copyWith({
    int? id,
    String? code,
    dynamic name,
    String? nameVn,
  }) =>
      PathologyModel(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        nameVn: nameVn ?? this.nameVn,
      );

  factory PathologyModel.fromJson(Map<String, dynamic> json) => PathologyModel(
        id: json['id'],
        code: json['code'],
        name: json['name'],
        nameVn: json['name_vn'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'name_vn': nameVn,
      };
}
