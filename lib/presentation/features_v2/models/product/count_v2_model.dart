class CountV2Model {
  String? title;
  String? code;
  int? value;

  CountV2Model({this.title, this.code, this.value});

  CountV2Model.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    code = json['code'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['code'] = code;
    data['value'] = value;
    return data;
  }
}
