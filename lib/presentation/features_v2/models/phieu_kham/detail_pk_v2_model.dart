import 'package:pharmago/presentation/features/company/data/models/company_model.dart';
import 'package:pharmago/presentation/features_v2/models/customer/v2/customer_model.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../features/schedule/data/models/diagnosis_model.dart';


class DetailPkV2Model {
  MedicalBill? medicalBill;
  CompanyModel? workspace;
  CustomerV2Model? customer;
  EmployeeData? employee;
  ServiceV2Model? service;
  List<Pathologies>? pathologies;
  List<Prescriptions>? prescriptions;
  DiagnosisModel? diagnosis;

  DetailPkV2Model({
    this.medicalBill,
    this.workspace,
    this.customer,
    this.employee,
    this.service,
    this.pathologies,
    this.prescriptions,
    this.diagnosis,
  });

  DetailPkV2Model.fromJson(Map<String, dynamic> json) {
    medicalBill = json['medical_bill'] != null
        ? MedicalBill.fromJson(json['medical_bill'])
        : null;
    workspace = json['workspace'] != null
        ? CompanyModel.fromJson(json['workspace'])
        : null;
    customer = json['customer'] != null
        ? CustomerV2Model.fromJson(json['customer'])
        : null;
    employee = json['employee'] != null
        ? EmployeeData.fromJson(json['employee'])
        : null;
    service = json['service'] != null
        ? ServiceV2Model.fromJson(json['service'])
        : null;
    if (json['pathologies'] != null) {
      pathologies = <Pathologies>[];
      json['pathologies'].forEach((v) {
        pathologies!.add(Pathologies.fromJson(v));
      });
    }
    if (json['prescriptions'] != null) {
      prescriptions = <Prescriptions>[];
      json['prescriptions'].forEach((v) {
        prescriptions!.add(Prescriptions.fromJson(v));
      });
    }
  }
}

class EmployeeData {
  int? id;
  String? name;
  String? phone;
  EmployeeData({
    this.id,
    this.name,
    this.phone,
  });

  EmployeeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['full_name'];
    phone = json['phone_number'];
  }
}

class MedicalBill {
  int? id;
  String? uuid;
  String? code;
  String? conclusion;
  DateTime? createdAt;

  MedicalBill({
    this.id,
    this.uuid,
    this.code,
    this.conclusion,
    this.createdAt,
  });

  MedicalBill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    code = json['code'];
    conclusion = json['conclusion'];
    createdAt = DateTime.tryParse(json['created_at'].toString());
  }
}

class Pathologies {
  String? code;
  String? name;
  String? nameVn;
  int? id;

  Pathologies({this.code, this.name, this.nameVn, this.id});

  Pathologies.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    nameVn = json['name_vn'];
    id = json['id'];
  }
}

class Prescriptions {
  int? id;
  String? note;
  String? code;
  List<ItemsPrescriptions>? items;

  Prescriptions({this.id, this.note, this.code, this.items});

  Prescriptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    code = json['code'];
    if (json['items'] != null) {
      items = <ItemsPrescriptions>[];
      json['items'].forEach((v) {
        items!.add(ItemsPrescriptions.fromJson(v));
      });
    }
  }
}

class ItemsPrescriptions {
  int? productId;
  int? id;
  int? no;
  int? quantity;
  int? unitId;

  String? lieuDung;
  String? name;
  String? image;
  String? unit;
  double? price;

  ItemsPrescriptions({
    this.productId,
    this.id,
    this.no,
    this.quantity,
    this.unitId,
    this.price,
    this.lieuDung,
    this.name,
    this.unit,
    this.image,
  });

  ItemsPrescriptions.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    id = json['id'];
    no = json['no'];
    quantity = json['quantity'];
    unitId = json['unit_id'];
    lieuDung = json['lieu_dung'];
    if (json['unit_data'] != null) {
      price = json['unit_data']['sell_price'].toString().toDouble;
      unit = json['unit_data']['name'];
    }
    if (json['product_data'] != null) {
      name = json['product_data']['name'];
      if (json['images'] is List<String> && json['images'].isNotEmpty) {
        image = json['images'][0];
      }
    }
  }
}
