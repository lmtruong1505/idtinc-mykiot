import '../../../features/customer/data/models/customer_model.dart';
import '../../../features/employee/employee/data/models/employee_model.dart';

class EventModel {
  int? id;
  String? uuid;
  String? code;
  int? customerId;
  CustomerModel? customer;
  int? company;
  int? doctorId;
  EmployeeModel? doctor;
  String? symptoms;
  String? diagnostic;
  String? qrCodeUrl;
  int? userCreatedId;
  CustomerModel? userCreated;
  CustomerModel? userUpdated;
  int? userUpdatedId;
  String? meetingAt;
  String? createdAt;
  String? updatedAt;
  String? prescription;
  String? appointmentCode;
  bool? isDone;
  bool? canceled;
  List<Service>? services;
  List<PaymentModel>? payments;

  EventModel({
    this.id,
    this.uuid,
    this.code,
    this.customerId,
    this.customer,
    this.company,
    this.doctorId,
    this.doctor,
    this.symptoms,
    this.diagnostic,
    this.qrCodeUrl,
    this.userCreatedId,
    this.userCreated,
    this.userUpdatedId,
    this.meetingAt,
    this.createdAt,
    this.updatedAt,
    this.services,
    this.userUpdated,
    this.isDone,
    this.prescription,
    this.payments,
    this.canceled,
    this.appointmentCode,
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    code = json['code'];
    customerId = json['customer_id'];
    customer = json['customer'] != null
        ? CustomerModel.fromJson(json['customer'])
        : null;
    company = json['company'];
    doctorId = json['doctor_id'];
    doctor =
        json['doctor'] != null ? EmployeeModel.fromJson(json['doctor']) : null;
    symptoms = json['symptoms'];
    diagnostic = json['diagnostic'];
    qrCodeUrl = json['qr_code_url'];
    userCreatedId = json['user_created_id'];
    userCreated = json['user_created'] != null
        ? CustomerModel.fromJson(json['user_created'])
        : null;
    userUpdated = json['user_updated'] != null
        ? CustomerModel.fromJson(json['user_updated'])
        : null;
    userUpdatedId = json['user_updated_id'];
    meetingAt = json['meeting_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDone = json['is_done'];
    canceled = json['canceled'];
    appointmentCode = json['appointment_code'];
    prescription = json['prescription'];
    if (json['services'] != null) {
      services = <Service>[];
      json['services'].forEach((v) {
        services!.add(Service.fromJson(v));
      });
    }
    if (json['payments'] != null) {
      payments = <PaymentModel>[];
      json['payments'].forEach((v) {
        payments!.add(PaymentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['code'] = code;
    data['prescription'] = prescription;
    data['is_done'] = isDone;
    data['customer_id'] = customerId;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['company'] = company;
    data['doctor_id'] = doctorId;
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    data['symptoms'] = symptoms;
    data['diagnostic'] = diagnostic;
    data['qr_code_url'] = qrCodeUrl;
    data['user_created_id'] = userCreatedId;
    if (userCreated != null) {
      data['user_created'] = userCreated!.toJson();
    }
    if (userUpdated != null) {
      data['user_updated'] = userUpdated!.toJson();
    }
    data['user_updated_id'] = userUpdatedId;

    data['meeting_at'] = meetingAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['canceled'] = canceled;
    data['appointment_code'] = appointmentCode;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  int? id;
  String? code;
  String? title;
  String? entity;
  String? frequency;
  String? unit;
  int? price;
  String? description;
  int? company;
  int? reminderTime;

  Service({
    this.id,
    this.code,
    this.title,
    this.entity,
    this.frequency,
    this.unit,
    this.price,
    this.description,
    this.company,
    this.reminderTime,
  });

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    title = json['title'];
    entity = json['entity'];
    frequency = json['frequency'];
    unit = json['unit'];
    price = json['price'];
    description = json['description'];
    company = json['company'];
    reminderTime = json['reminder_time'];
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
    data['description'] = description;
    data['company'] = company;
    data['reminder_time'] = reminderTime;
    return data;
  }
}

class PaymentModel {
  String? code;
  double? mustPaid;
  double? hadPaid;
  double? needPay;

  PaymentModel({this.code, this.mustPaid, this.hadPaid, this.needPay});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    mustPaid = json['must_paid'];
    hadPaid = json['had_paid'];
    needPay = json['need_pay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['must_paid'] = this.mustPaid;
    data['had_paid'] = this.hadPaid;
    data['need_pay'] = this.needPay;
    return data;
  }
}
