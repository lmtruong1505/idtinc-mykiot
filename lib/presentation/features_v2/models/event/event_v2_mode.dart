import 'package:pharmago/presentation/features_v2/models/customer/v2/customer_model.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';

import '../employee/user_data_model.dart';

class EventV2Model {
  int? id;
  String? uuid;
  String? code;
  int? customerId;
  int? orderInDay;
  DateTime? createdAt;
  DateTime? meetingAt;
  DateTime? updatedAt;
  String? status;
  CustomerV2Model? customer;
  int? userCreatedId;
  UserDataModel? userCreated;
  List<ServiceV2Model>? services;
  WorkspaceData? company;

  EventV2Model({
    this.id,
    this.uuid,
    this.code,
    this.customerId,
    this.orderInDay,
    this.createdAt,
    this.meetingAt,
    this.updatedAt,
    this.status,
    this.customer,
    this.userCreatedId,
    this.userCreated,
    this.services,
    this.company,
  });

  EventV2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    code = json['code'];
    customerId = json['customer_id'];
    orderInDay = json['order_in_day'];
    createdAt = DateTime.tryParse(json['created_at'] ?? '');
    meetingAt = DateTime.tryParse(json['meeting_at'] ?? '');
    updatedAt = DateTime.tryParse(json['updated_at'] ?? '');
    status = json['status'];
    customer = json['customer'] != null
        ? CustomerV2Model.fromJson(json['customer'])
        : null;
    userCreatedId = json['user_created_id'];
    userCreated = json['user_created'] != null
        ? UserDataModel.fromJson(json['user_created'])
        : null;

    if (json['workspace_data'] is Map) {
      company = WorkspaceData.fromJson(json['workspace_data']);
    }

    if (json['services'] is List) {
      services = <ServiceV2Model>[];
      json['services'].forEach((v) {
        services!.add(ServiceV2Model.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['code'] = code;
    data['customer_id'] = customerId;
    data['created_at'] = createdAt;
    data['meeting_at'] = meetingAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
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

class WorkspaceData {
  int? id;
  String? name;
  String? code;
  String? typeCode;
  WorkspaceData({
    this.id,
    this.name,
    this.code,
    this.typeCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'typeCode': typeCode,
    };
  }

  factory WorkspaceData.fromJson(Map<String, dynamic> map) {
    return WorkspaceData(
      id: map['id']?.toInt(),
      name: map['name'],
      code: map['code'],
      typeCode: map['typeCode'],
    );
  }
}
