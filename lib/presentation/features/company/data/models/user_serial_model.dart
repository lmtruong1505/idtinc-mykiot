class UserSerialModel {
  int? id;
  String? name;
  String? pattern;
  String? serial;
  int? workspace;
  bool? defaultFlag;

  UserSerialModel({
    this.id,
    this.name,
    this.pattern,
    this.serial,
    this.workspace,
    this.defaultFlag,
  });

  UserSerialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pattern = json['pattern'];
    serial = json['serial'];
    workspace = json['workspace'];
    defaultFlag = json['default_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pattern'] = pattern;
    data['serial'] = serial;
    data['workspace'] = workspace;
    data['default_flag'] = defaultFlag;
    return data;
  }
}
