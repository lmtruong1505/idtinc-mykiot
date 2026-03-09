import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';

import '../../../features/product/domain/entities/unit_entity.dart';

class PrescriptionModel {
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
  List<ItemsPrescription>? items;
  int? userCreatedId;
  CustomerModel? userCreated;
  int? userUpdatedId;
  CustomerModel? userUpdated;
  String? createdAt;
  String? updatedAt;

  PrescriptionModel({
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
    this.items,
    this.userCreatedId,
    this.userCreated,
    this.userUpdatedId,
    this.userUpdated,
    this.createdAt,
    this.updatedAt,
  });

  PrescriptionModel.fromJson(Map<String, dynamic> json) {
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
    if (json['items'] != null) {
      items = <ItemsPrescription>[];
      json['items'].forEach((v) {
        items!.add(ItemsPrescription.fromJson(v));
      });
    }
    userCreatedId = json['user_created_id'];
    userCreated = json['user_created'] != null
        ? CustomerModel.fromJson(json['user_created'])
        : null;
    userUpdatedId = json['user_updated_id'];
    userUpdated = json['user_updated'] != null
        ? CustomerModel.fromJson(json['user_updated'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['code'] = code;
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
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['user_created_id'] = userCreatedId;
    if (userCreated != null) {
      data['user_created'] = userCreated!.toJson();
    }
    data['user_updated_id'] = userUpdatedId;
    if (userUpdated != null) {
      data['user_updated'] = userUpdated!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ItemsPrescription {
  int? id;
  int? variantId;
  Variant? variant;
  String? lieuDung;
  int? quantity;
  int? level;
  int? unit;
  List<UnitEntity>? units;

  ItemsPrescription({
    this.id,
    this.variantId,
    this.variant,
    this.lieuDung,
    this.quantity,
    this.level,
    this.unit,
  });

  ItemsPrescription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variantId = json['variant_id'];
    variant =
        json['variant'] != null ? Variant.fromJson(json['variant']) : null;
    lieuDung = json['lieu_dung'];
    quantity = json['quantity'];
    level = json['level'];
    unit = json['unit'];
    if (json['units'] != null) {
      units = <UnitEntity>[];
      json['units'].forEach((v) {
        units!.add(
          UnitEntity(
            id: v['id'],
            name: v['name'],
            sellPrice: v['sell_price'],
            level: v['level'],
            value: v['value'],
          ),
        );
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['variant_id'] = variantId;
    if (variant != null) {
      data['variant'] = variant!.toJson();
    }
    data['lieu_dung'] = lieuDung;
    data['quantity'] = quantity;
    data['level'] = level;
    data['unit'] = unit;
    return data;
  }
}

class Variant {
  String? name;

  Variant({this.name});

  Variant.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
