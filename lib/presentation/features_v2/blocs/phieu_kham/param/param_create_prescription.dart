import '../../../../features/product/domain/entities/unit_entity.dart';

class ParamCreatePrescription {
  int? customerId;
  int? company;
  int? doctorId;
  String? symptoms;
  String? diagnostic;
  String? code;
  String? mbUuid;
  List<ItemsPrdData>? items;

  ParamCreatePrescription({
    this.customerId,
    this.company,
    this.doctorId,
    this.symptoms,
    this.diagnostic,
    this.mbUuid,
    this.code,
    this.items,
  });

  ParamCreatePrescription.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    company = json['company'];
    code = json['code'];
    doctorId = json['doctorId'];
    symptoms = json['symptoms'];
    diagnostic = json['diagnostic'];
    mbUuid = json['mb_uuid'];
    if (json['items'] != null) {
      items = <ItemsPrdData>[];
      json['items'].forEach((v) {
        items!.add(ItemsPrdData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['company'] = company;
    data['code'] = code;
    data['doctorId'] = doctorId;
    data['symptoms'] = symptoms;
    data['diagnostic'] = diagnostic;
    data['mb_uuid'] = mbUuid;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemsPrdData {
  int? variantId;
  String? lieuDung;
  String? variantName;
  int? quantity;
  int? unit;
  int? level;
   List<UnitEntity>? units;

  ItemsPrdData({
    this.variantId,
    this.lieuDung,
    this.quantity,
    this.variantName,
    this.unit,
    this.level,
    this.units,
  });

  ItemsPrdData.fromJson(Map<String, dynamic> json) {
    variantId = json['variantId'];
    lieuDung = json['lieuDung'];
    quantity = json['quantity'];
    unit = json['unit'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variantId'] = variantId;
    data['lieuDung'] = lieuDung;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['level'] = level;
    return data;
  }
}
