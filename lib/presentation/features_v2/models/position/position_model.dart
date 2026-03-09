class PositionModel {
  int? id;
  String? code;
  String? title;
  String? type;

  PositionModel({this.id, this.code, this.title, this.type});

  PositionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    title = json['title'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['title'] = title;
    data['type'] = type;
    return data;
  }
}
