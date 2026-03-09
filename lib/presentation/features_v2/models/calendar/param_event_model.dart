class ParamEventModel {
  int? customerId;
  int? company;
  int? doctorId;
  int? appointment;
  String? meetingAt;
  List<int>? services;

  ParamEventModel({
    this.customerId,
    this.company,
    this.doctorId,
    this.meetingAt,
    this.services,
    this.appointment,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['company'] = company;
    data['doctorId'] = doctorId;
    data['meetingAt'] = meetingAt;
    data['appointment'] = appointment;
    if (services != null) {
      data['services'] = services!.map((v) => {'serviceId': v}).toList();
    }
    return data;
  }
}
