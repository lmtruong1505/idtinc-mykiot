import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:pharmago/presentation/features_v2/models/product/ingredient_v2_model.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../../../features/product/data/models/basic_model.dart';
import '../../../models/product/product_detail_v2_model.dart';
import '../../../models/product/product_v2_model.dart';
import '../../../models/product/unit_v2_model.dart';
import '../../../models/product/warehouse_v2_model.dart';

class ProdCreateParam {
  ProductParam? product;
  List<IngredientV2Model> ingredients = [];
  List<UnitV2Model> unitChanges = [];
  List<MapEntry<int, XFile>>? images;
  WarehouseParam? warehouse;

  ProdCreateParam({
    this.product,
    this.ingredients = const [],
    this.unitChanges = const [],
    this.warehouse,
  });

  ProdCreateParam.fromModel(ProductDetailV2Model model) {
    product =
        model.product != null ? ProductParam.fromModel(model.product!) : null;
    ingredients = model.ingredients;
    warehouse = model.warehouse.isNotEmpty
        ? WarehouseParam.fromModel(model.warehouse[0])
        : null;
    unitChanges = model.product?.unit ?? [];
  }

  ProdCreateParam.fromJson(Map<String, dynamic> json) {
    product =
        json['product'] != null ? ProductParam.fromJson(json['product']) : null;
    if (json['ingredients'] != null) {
      ingredients = <IngredientV2Model>[];
      json['ingredients'].forEach((v) {
        ingredients.add(IngredientV2Model.fromJson(v));
      });
    }
    if (json['unit_changes'] != null) {
      unitChanges = <UnitV2Model>[];
      json['unit_changes'].forEach((v) {
        unitChanges.add(UnitV2Model.fromJson(v));
      });
    }
    warehouse = json['warehouse'] != null
        ? WarehouseParam.fromJson(json['warehouse'])
        : null;
  }

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = jsonEncode(product!.toJson());
    }
    data['ingredients'] =
        jsonEncode(ingredients.map((v) => v.toJson()).toList());
    data['unit_changes'] =
        jsonEncode(unitChanges.map((v) => v.toJson()).toList());
    if (warehouse != null) {
      data['warehouse'] = jsonEncode(warehouse!.toJson());
    }
    data['image'] = images?.map(
      (e) {
        if (e.value.path.startsWith('http')) {
          return null;
        }
        return MultipartFile.fromFileSync(e.value.path);
      },
    ).toList();
    data.removeWhere((key, value) => value == null);
    return data;
  }

  void updateTonKho() {
    final baseUnit = unitChanges.indexWhere(
      (element) => element.sellUnit ?? false,
    );
    if (baseUnit == -1) {
      return;
    }
    int heso = 1;
    for (int i = baseUnit + 1; i < unitChanges.length; i++) {
      heso *= unitChanges[i].value ?? 1;
    }
    final sum = (product?.stockQuantity ?? 0) * heso;
    product?.stockQuantity = sum;
    product?.availableStock = sum;
  }
}

class ProductParam {
  String? name;
  int? categoryPrd;
  String? code;
  String? barcode;
  String? description;
  double? vat;
  String? kafaCode;
  bool? active;
  String? lieuDung;
  String? chiDinh;
  String? chongChiDinh;
  String? congDung;
  String? tacDungPhu;
  String? thanTrong;
  String? tuongTac;
  String? baoQuan;
  String? dongGoi;
  int? hinhThuc;
  BasicModel? congTySx;
  BasicModel? congTyDk;
  BasicModel? category;
  BasicModel? type;
  BasicModel? brand;
  int? company;
  int? warningLevel;
  int? warningUnit;
  bool? dangBan;
  String? decisionNumber;
  String? registerNumber;
  int? stockQuantity;
  int? availableStock;
  bool? canEditStock;
  num? point;
  num? exchangePoint;

  ProductParam({
    this.name,
    this.code,
    this.barcode,
    this.description,
    this.vat,
    this.kafaCode,
    this.active,
    this.lieuDung,
    this.chiDinh,
    this.chongChiDinh,
    this.congDung,
    this.tacDungPhu,
    this.thanTrong,
    this.tuongTac,
    this.baoQuan,
    this.dongGoi,
    this.hinhThuc,
    this.congTySx,
    this.congTyDk,
    this.category,
    this.type,
    this.brand,
    this.company,
    this.warningLevel,
    this.warningUnit,
    this.dangBan,
    this.decisionNumber,
    this.registerNumber,
    this.stockQuantity,
    this.availableStock,
    this.canEditStock,
    this.categoryPrd,
    this.point,
    this.exchangePoint,
  });

  ProductParam.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    categoryPrd = json['product_category'];
    code = json['code'];
    barcode = json['barcode'];
    description = json['description'];
    vat = json['vat'];
    kafaCode = json['kafa_code'];
    active = json['active'];
    lieuDung = json['lieu_dung'];
    chiDinh = json['chi_dinh'];
    chongChiDinh = json['chong_chi_dinh'];
    congDung = json['cong_dung'];
    tacDungPhu = json['tac_dung_phu'];
    thanTrong = json['than_trong'];
    tuongTac = json['tuong_tac'];
    baoQuan = json['bao_quan'];
    dongGoi = json['dong_goi'];
    hinhThuc = json['hinh_thuc'];
    congTySx = json['cong_ty_sx'];
    congTyDk = json['cong_ty_dk'];
    category = json['category'];
    type = json['type'];
    brand = json['brand'];
    company = json['company'];
    warningLevel = json['warning_level'];
    warningUnit = json['warning_unit'];
    dangBan = json['dang_ban'];
    decisionNumber = json['decision_number'];
    registerNumber = json['register_number'];
    stockQuantity = json['stock_quantity'];
    availableStock = json['available_stock'];
    point = json['point'];
    exchangePoint = json['exchange_point'];
  }

  ProductParam.fromModel(ProductV2Model model) {
    name = model.name;
    code = model.code;
    barcode = model.barcode;
    description = model.description;
    kafaCode = model.kafaCode;
    active = model.active;
    lieuDung = model.lieuDung;
    chiDinh = model.chiDinh;
    chongChiDinh = model.chongChiDinh;
    congDung = model.congDung;
    tacDungPhu = model.tacDungPhu;
    thanTrong = model.thanTrong;
    tuongTac = model.tuongTac;
    baoQuan = model.baoQuan;
    dongGoi = model.dongGoi;
    category = model.category;
    type = model.type;
    brand = model.brand;
    company = getCompany;
    dangBan = model.active;
    decisionNumber = model.decisionNumber;
    registerNumber = model.registerNumber;
    stockQuantity = model.stockQuantity;
    availableStock = model.availableStock;
    vat = model.vat;
    canEditStock = model.canEditStock;
    point = model.point;
    exchangePoint = model.exchangePoint;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['product_category'] = categoryPrd;
    data['code'] = code;
    data['barcode'] = barcode;
    data['description'] = description;
    data['vat'] = vat;
    data['kafa_code'] = kafaCode;
    data['active'] = active;
    data['lieu_dung'] = lieuDung;
    data['chi_dinh'] = chiDinh;
    data['chong_chi_dinh'] = chongChiDinh;
    data['cong_dung'] = congDung;
    data['tac_dung_phu'] = tacDungPhu;
    data['than_trong'] = thanTrong;
    data['tuong_tac'] = tuongTac;
    data['bao_quan'] = baoQuan;
    data['dong_goi'] = dongGoi;
    data['hinh_thuc'] = hinhThuc;
    data['cong_ty_sx'] = congTySx?.id;
    data['cong_ty_dk'] = congTyDk?.id;
    data['category'] = category?.id;
    data['type'] = type?.id;
    data['brand'] = brand?.id;
    data['company'] = company;
    data['warning_level'] = warningLevel;
    data['warning_unit'] = warningUnit;
    data['dang_ban'] = dangBan;
    data['decision_number'] = decisionNumber;
    data['register_number'] = registerNumber;
    data['stock_quantity'] = stockQuantity;
    data['available_stock'] = availableStock;
    data['point'] = point;
    data['exchange_point'] = exchangePoint;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class WarehouseParam {
  int? initialStock;
  String? batchCode;
  double? importPrice;
  DateTime? manufacturingDate;

  WarehouseParam({
    this.initialStock,
    this.batchCode,
    this.importPrice,
    this.manufacturingDate,
  });

  WarehouseParam.fromModel(WarehouseV2Model model) {
    initialStock = model.initialStock;
    batchCode = model.batchCode;
    importPrice = model.importPrice;
    manufacturingDate = DateTime.tryParse(model.manufacturingDate ?? '');
  }

  WarehouseParam.fromJson(Map<String, dynamic> json) {
    initialStock = json['initial_stock'];
    batchCode = json['batch_code'];
    importPrice = json['import_price'];
    manufacturingDate = json['manufacturing_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['initial_stock'] = initialStock;
    data['batch_code'] = batchCode;
    data['import_price'] = importPrice;
    data['manufacturing_date'] = manufacturingDate;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
