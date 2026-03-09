class CreateRoleParam {
  String? code;
  String? title;
  String? note;
  int? company;
  int? position;
  List<RoleItems>? items;

  CreateRoleParam({this.code, this.title, this.note, this.company, this.items});

  CreateRoleParam.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
    note = json['note'];
    company = json['company'];
    position = json['position'];
    if (json['items'] != null) {
      items = <RoleItems>[];
      json['items'].forEach((v) {
        items!.add(RoleItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['title'] = title;
    data['note'] = note;
    data['company'] = company;
    data['position'] = position;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoleItems {
  String? appCode;
  bool? checked;

  RoleItems({this.appCode, this.checked});

  RoleItems.fromJson(Map<String, dynamic> json) {
    appCode = json['appCode'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appCode'] = appCode;
    data['checked'] = checked;
    return data;
  }
}
