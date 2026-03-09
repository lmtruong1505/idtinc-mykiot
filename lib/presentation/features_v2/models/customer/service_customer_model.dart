class ServiceCustomerModel {
  int? id;
  String? code;
  String? title;
  String? entity;
  String? frequency;
  String? unit;
  double? price;
  int? used;
  String? description;
  String? staff;
  int? company;
  int? reminderTime;

  ServiceCustomerModel({
    this.id,
    this.code,
    this.title,
    this.entity,
    this.frequency,
    this.unit,
    this.price,
    this.used,
    this.description,
    this.company,
    this.reminderTime,
    this.staff,
  });

  ServiceCustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    title = json['title'];
    entity = json['entity'];
    frequency = json['frequency'];
    unit = json['unit'];
    price = double.tryParse(json['price'].toString());
    used = json['used'];
    description = json['description'];
    company = json['company'];
    reminderTime = json['reminder_time'];
    staff = json['staff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['title'] = title;
    data['entity'] = entity;
    data['frequency'] = frequency;
    data['unit'] = unit;
    data['price'] = price;
    data['used'] = used;
    data['description'] = description;
    data['company'] = company;
    data['reminder_time'] = reminderTime;
    data['staff'] = staff;
    return data;
  }
}
