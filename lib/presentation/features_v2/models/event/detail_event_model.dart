import 'package:pharmago/presentation/features/company/data/models/company_model.dart';
import 'package:pharmago/presentation/features_v2/models/customer/v2/customer_model.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';

import 'reminder_event_model.dart';

class DetailEventV2Model {
  int? id;
  String? uuid;
  CompanyModel? workspace;
  String? code;
  int? customerId;
  DateTime? createdAt;
  DateTime? meetingAt;
  DateTime? updatedAt;
  CustomerV2Model? customer;
  String? status;
  int? userCreatedId;
  CustomerV2Model? userCreated;
  List<ServicesEvent>? services;
  List<ReminderEventModel>? reminders;

  DetailEventV2Model({
    this.id,
    this.uuid,
    this.workspace,
    this.code,
    this.customerId,
    this.createdAt,
    this.meetingAt,
    this.updatedAt,
    this.customer,
    this.status,
    this.userCreatedId,
    this.userCreated,
    this.services,
    this.reminders,
  });

  DetailEventV2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    workspace = json['workspace'] != null
        ? CompanyModel.fromJson(json['workspace'])
        : null;
    code = json['code'];
    customerId = json['customer_id'];
    createdAt = DateTime.tryParse(json['createdAt'] ?? '');
    meetingAt = DateTime.tryParse(json['meeting_at'] ?? '');
    updatedAt = DateTime.tryParse(json['updatedAt'] ?? '');
    customer = json['customer'] != null
        ? CustomerV2Model.fromJson(json['customer'])
        : null;
    status = json['status'];
    userCreatedId = json['user_created_id'];
    userCreated = json['user_created'] != null
        ? CustomerV2Model.fromJson(json['user_created'])
        : null;
    if (json['services'] != null) {
      services = <ServicesEvent>[];
      json['services'].forEach((v) {
        services!.add(ServicesEvent.fromJson(v));
      });
    }
    if (json['reminders'] != null) {
      reminders = <ReminderEventModel>[];
      json['reminders'].forEach((v) {
        reminders!.add(ReminderEventModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    if (workspace != null) {
      data['workspace'] = workspace!.toJson();
    }
    data['code'] = code;
    data['customer_id'] = customerId;
    data['created_at'] = createdAt;
    data['meeting_at'] = meetingAt;
    data['updated_at'] = updatedAt;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['status'] = status;
    data['user_created_id'] = userCreatedId;
    if (userCreated != null) {
      data['user_created'] = userCreated!.toJson();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServicesEvent {
  int? id;
  int? no;
  PriceService? price;
  ServiceV2Model? serviceData;
  CustomerV2Model? employeeData;

  ServicesEvent({
    this.id,
    this.no,
    this.serviceData,
    this.employeeData,
    this.price,
  });

  ServicesEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    no = json['no'];
    serviceData = json['service_data'] != null
        ? ServiceV2Model.fromJson(json['service_data'])
        : null;
    price = json['price_data'] != null
        ? PriceService.fromJson(json['price_data'])
        : null;
    employeeData = json['employee_data'] != null
        ? CustomerV2Model.fromJson(json['employee_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['no'] = no;
    if (serviceData != null) {
      data['service_data'] = serviceData!.toJson();
    }
    if (price != null) {
      data['price_data'] = price!.toJson();
    }
    if (employeeData != null) {
      data['employee_data'] = employeeData!.toJson();
    }
    return data;
  }
}
