class CreateEventV2Model {
  int? id;
  int? customerId;
  int? company;
  bool? send_zns;
  String? meetingAt;
  String? customerPhone;
  String? customerName;
  List<ServicesEventModel>? services;
  List<Reminders>? reminders;

  CreateEventV2Model({
    this.id,
    this.customerId,
    this.company,
    this.meetingAt,
    this.services,
    this.reminders,
    this.customerPhone,
    this.customerName,
    this.send_zns,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['send_zns'] = send_zns;
    data['id'] = id;
    data['company'] = company;
    data['meetingAt'] = meetingAt;
    data['customer_phone'] = customerPhone;
    data['customer_name'] = customerName;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (reminders != null) {
      data['reminders'] = reminders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServicesEventModel {
  int? serviceId;
  int? employeeId;
  int? priceId;
  int? id;

  ServicesEventModel({
    this.serviceId,
    this.employeeId,
    this.id,
    this.priceId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceId'] = serviceId;
    data['employeeId'] = employeeId;
    data['id'] = id;
    data['priceId'] = priceId;
    return data;
  }
}

class Reminders {
  String? message;
  int? quantity;
  String? unit;
  int? id;

  Reminders({this.message, this.quantity, this.unit});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['id'] = id;
    return data;
  }
}
