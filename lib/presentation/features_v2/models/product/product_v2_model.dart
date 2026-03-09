import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/inventory_model_v2.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_detail_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/unit_v2_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/warehouse_v2_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../features/company/data/models/point_exchange_package_model.dart';
import '../../../features/warehouse/domain/entities/shipment_data_entity.dart';
import 'image_model.dart';

class ProductV2Model {
  int? id;
  String? name;
  String? code;
  String? barcode;
  String? description;
  double? vat;
  BasicModel? category;
  BasicModel? type;
  BasicModel? brand;
  String? lieuDung;
  String? chiDinh;
  String? chongChiDinh;
  String? congDung;
  String? tacDungPhu;
  String? thanTrong;
  String? tuongTac;
  String? baoQuan;
  String? dongGoi;
  String? congTySx;
  String? congTyDk;
  List<ImageModel>? images;
  bool? active;
  List<UnitV2Model> unit = <UnitV2Model>[];
  int? tonKho;
  String? kafaCode;
  String? baoChe;
  UnitV2Model? unitSell;
  UnitV2Model? unitData;
  UnitV2Model? unitStorage;
  WarehouseV2Model? warehouse;
  String? decisionNumber;
  String? registerNumber;
  int? stockQuantity;
  int? availableStock;
  int? quantity;
  double? chietKhau;
  String? ghiChu;
  bool isSelected = false;
  bool? canEditStock;
  int? totalSold;
  num? totalRevenue;
  num? point;
  num? exchangePoint;
  ShipmentDataEntity? shipment;
  PointExchangePackageModel? package;

  ProductV2Model({
    this.id,
    this.name,
    this.code,
    this.barcode,
    this.description,
    this.vat,
    this.category,
    this.type,
    this.brand,
    this.lieuDung,
    this.chiDinh,
    this.chongChiDinh,
    this.congDung,
    this.tacDungPhu,
    this.thanTrong,
    this.tuongTac,
    this.baoQuan,
    this.dongGoi,
    this.congTySx,
    this.congTyDk,
    this.images,
    this.active,
    this.unit = const <UnitV2Model>[],
    this.tonKho,
    this.kafaCode,
    this.baoChe,
    this.unitSell,
    this.unitData,
    this.unitStorage,
    this.warehouse,
    this.decisionNumber,
    this.registerNumber,
    this.stockQuantity,
    this.availableStock,
    this.quantity,
    this.chietKhau,
    this.isSelected = false,
    this.canEditStock,
    this.totalSold,
    this.totalRevenue,
    this.point,
    this.exchangePoint,
    this.shipment,
    this.package,
  });

  ProductV2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? json['product_name'];
    code = json['code'];
    barcode = json['barcode'];
    description = json['description'];
    vat = json['vat'].toString().toDouble;
    category =
        json['category'] != null ? BasicModel.fromJson(json['category']) : null;
    type = json['type'] != null ? BasicModel.fromJson(json['type']) : null;
    brand = json['brand'] != null ? BasicModel.fromJson(json['brand']) : null;
    lieuDung = json['lieu_dung'];
    chiDinh = json['chi_dinh'];
    chongChiDinh = json['chong_chi_dinh'];
    congDung = json['cong_dung'];
    tacDungPhu = json['tac_dung_phu'];
    thanTrong = json['than_trong'];
    tuongTac = json['tuong_tac'];
    baoQuan = json['bao_quan'];
    dongGoi = json['dong_goi'];
    congTySx = json['cong_ty_sx'];
    congTyDk = json['cong_ty_dk'];
    images = List<ImageModel>.from(
      json['images']?.map((x) => ImageModel.fromJson(x)) ?? <ImageModel>[],
    );
    active = json['active'] ?? json['dang_ban'];
    tonKho = json['ton_kho'];
    if (json['units'] != null) {
      unit = <UnitV2Model>[];
      if (json['units'] is List) {
        json['units'].forEach((v) {
          unit.add(UnitV2Model.fromJson(v));
        });
      }
      if (json['unit'] is Map) {
        unit.add(UnitV2Model.fromJson(json['unit']));
      }
    }
    unit.sort(
      (a, b) => (a.level ?? 0).compareTo(b.level ?? 0),
    );
    kafaCode = json['kafa_code'];
    baoChe = json['bao_che'];
    unitSell = json['unit_sell'] != null
        ? UnitV2Model.fromJson(json['unit_sell'])
        : null;
    unitData = json['unit_data'] is List
        ? UnitV2Model.fromJson(json['unit_data'].first)
        : null;
    unitStorage = json['unit_storage'] != null
        ? UnitV2Model.fromJson(json['unit_storage'])
        : null;
    warehouse = json['warehouse'] != null
        ? WarehouseV2Model.fromJson(json['warehouse'])
        : null;
    decisionNumber = json['decision_number'];
    registerNumber = json['register_number'];
    stockQuantity = json['stock_quantity'];
    availableStock = json['available_stock'];
    quantity = json['quantity'] ?? 1;
    chietKhau = json['chiet_khau'];
    canEditStock = json['can_edit_stock'];
    totalSold = json['total_sold'];
    totalRevenue = json['total_revenue'];
    point = json['point'];
    exchangePoint = json['exchange_point'];
    package = json['package'] != null
        ? PointExchangePackageModel.fromJson(json['package'])
        : null;
  }
  ProductV2Model copyWith({
    int? id,
    String? name,
    String? code,
    String? barcode,
    String? description,
    double? vat,
    BasicModel? category,
    BasicModel? type,
    BasicModel? brand,
    String? lieuDung,
    String? chiDinh,
    String? chongChiDinh,
    String? congDung,
    String? tacDungPhu,
    String? thanTrong,
    String? tuongTac,
    String? baoQuan,
    String? dongGoi,
    String? congTySx,
    String? congTyDk,
    List<ImageModel>? images,
    bool? active,
    List<UnitV2Model>? unit,
    int? tonKho,
    String? kafaCode,
    String? baoChe,
    UnitV2Model? unitSell,
    UnitV2Model? unitData,
    WarehouseV2Model? warehouse,
    String? decisionNumber,
    String? registerNumber,
    int? stockQuantity,
    int? availableStock,
    int? quantity,
    double? chietKhau,
    String? ghiChu,
    bool? isSelected,
    bool? canEditStock,
    int? totalSold,
    num? totalRevenue,
    num? point,
    num? exchangePoint,
    ShipmentDataEntity? shipment,
    PointExchangePackageModel? package,
  }) {
    return ProductV2Model(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      vat: vat ?? this.vat,
      category: category ?? this.category,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      lieuDung: lieuDung ?? this.lieuDung,
      chiDinh: chiDinh ?? this.chiDinh,
      chongChiDinh: chongChiDinh ?? this.chongChiDinh,
      congDung: congDung ?? this.congDung,
      tacDungPhu: tacDungPhu ?? this.tacDungPhu,
      thanTrong: thanTrong ?? this.thanTrong,
      tuongTac: tuongTac ?? this.tuongTac,
      baoQuan: baoQuan ?? this.baoQuan,
      dongGoi: dongGoi ?? this.dongGoi,
      congTySx: congTySx ?? this.congTySx,
      congTyDk: congTyDk ?? this.congTyDk,
      images: images ?? this.images,
      active: active ?? this.active,
      unit: unit ?? this.unit,
      tonKho: tonKho ?? this.tonKho,
      kafaCode: kafaCode ?? this.kafaCode,
      baoChe: baoChe ?? this.baoChe,
      unitSell: unitSell ?? this.unitSell,
      unitData: unitData ?? this.unitData,
      warehouse: warehouse ?? this.warehouse,
      decisionNumber: decisionNumber ?? this.decisionNumber,
      registerNumber: registerNumber ?? this.registerNumber,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      availableStock: availableStock ?? this.availableStock,
      quantity: quantity ?? this.quantity,
      chietKhau: chietKhau ?? this.chietKhau,
      isSelected: isSelected ?? this.isSelected,
      canEditStock: canEditStock ?? this.canEditStock,
      totalSold: totalSold ?? this.totalSold,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      point: point ?? this.point,
      exchangePoint: exchangePoint ?? this.exchangePoint,
      shipment: shipment ?? this.shipment,
      package: package ?? this.package,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['barcode'] = barcode;
    data['description'] = description;
    data['vat'] = vat;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (type != null) {
      data['type'] = type!.toJson();
    }
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    data['lieu_dung'] = lieuDung;
    data['chi_dinh'] = chiDinh;
    data['chong_chi_dinh'] = chongChiDinh;
    data['cong_dung'] = congDung;
    data['tac_dung_phu'] = tacDungPhu;
    data['than_trong'] = thanTrong;
    data['tuong_tac'] = tuongTac;
    data['bao_quan'] = baoQuan;
    data['dong_goi'] = dongGoi;
    data['cong_ty_sx'] = congTySx;
    data['cong_ty_dk'] = congTyDk;
    data['images'] = images?.map((x) => x.toJson()).toList();
    data['active'] = active;
    data['ton_kho'] = tonKho;
    data['units'] = unit.map((v) => v.toJson()).toList();
    data['kafa_code'] = kafaCode;
    data['bao_che'] = baoChe;
    if (unitSell != null) {
      data['unit_sell'] = unitSell!.toJson();
    }
    if (warehouse != null) {
      data['warehouse'] = warehouse!.toJson();
    }
    data['decision_number'] = decisionNumber;
    data['register_number'] = registerNumber;
    data['stock_quantity'] = stockQuantity;
    data['available_stock'] = availableStock;
    data['quantity'] = quantity;
    data['point'] = point;
    data['exchange_point'] = exchangePoint;
    data['chiet_khau'] = chietKhau;
    data['shipment'] = shipment?.toJson();
    data.removeWhere((key, value) => value == null);
    return data;
  }

  num getTonKho(UnitV2Model? unit) {
    final heso = getLevelUnit(unit);
    return (availableStock ?? 0) / heso;
  }

  int getLevelUnit(UnitV2Model? unit) {
    final idx = this.unit.indexWhere((element) => element.id == unit?.id);
    if (idx == -1) {
      return 0;
    }
    int heso = 1;
    for (int i = idx; i < this.unit.length; i++) {
      heso *= this.unit[i].value ?? 1;
    }
    return heso;
  }
}

extension ProductV3ToV2Converter on ProductV2Model {
  ProductV3Model toProductV3() {
    return ProductV3Model(
      id: id,
      productName: name,
      name: name,
      code: code,
      images: images?.map((e) => ImageModelV3(url: e.url)).toList(),
      units: unit
          .map(
            (e) => UnitV3Model(
              id: e.id,
              name: e.name,
              sellPrice: e.sellPrice,
              stockChange: e.stockChange,
              sellUnit: e.sellUnit,
            ),
          )
          .toList(),
      unitSell: UnitV3Model(
        id: unitSell?.id,
        name: unitSell?.name,
        sellPrice: unitSell?.sellPrice,
        stockChange: unitSell?.stockChange,
        sellUnit: unitSell?.sellUnit,
      ),
    );
  }
}

extension ProductShipment on ProductV2Model {
  List<ShipmentItemEntity> get listShipmentItemByQuantity {
    if (!isShipmentQuantityEnough) {
      quantity = totalShipmentQuantity.toInt();
    }
    final num totalQuantityByUnit = quantity ?? 0;
    // Nếu số lượng khách chọn = 0 -> return []
    if (totalQuantityByUnit == 0) return [];
    // Nếu kho không đủ hàng -> return all lists shipment
    final num totalQuantityFromShipment = shipment?.data?.fold<num>(
          0,
          (total, e) {
            return total += e.selectedQuantity ~/ valueUnitChange;
          },
        ) ??
        0;
    // final List<ShipmentItemEntity> listShipmentItem = [];

    // Sắp xếp lại danh sách shipment theo thứ tự cận date (date gần lên đầu, date xe xuống sau)
    final listShipmentSort = shipment?.data?.sortedByCompare(
          (e) => e.endDate ?? DateTime.now(),
          (a, b) => a.compareTo(b),
        ) ??
        [];

    // chênh lệch giữa số lượng sản phẩm với số lượng đã chọn trong shipment
    var diffitenceQuantity = totalQuantityByUnit - totalQuantityFromShipment;
    for (var item in listShipmentSort) {
      // Tìm index của shipment item đang xử lý
      final index = listShipmentSort.indexWhere(
        (e) {
          return e.id == item.id;
        },
      );
      // quy đổi tồn kho thực tế của shipment -> đơn vị đang chọn -> làm tròn xuống
      final currentQuantityConvert =
          (item.currentQuantity ?? 0) ~/ valueUnitChange;
      // loại bỏ các trường hợp item.currentQuantity không đủ 1 đơn vị đang trọn
      if (currentQuantityConvert == 0) {
        item = item.copyWith(
          selectedQuantity: 0,
        );
        listShipmentSort[index] = item.copyWith(
          selectedQuantity: 0,
        );
        continue;
      }

      num valueChange = 0;
      if (currentQuantityConvert >= diffitenceQuantity) {
        valueChange = diffitenceQuantity;
      } else {
        valueChange = diffitenceQuantity - currentQuantityConvert;
      }
      if (item.selectedQuantity + valueChange.toInt() * valueUnitChange < 0) {
        continue;
      }
      if (item.selectedQuantity + valueChange.toInt() * valueUnitChange >
          (item.currentQuantity ?? 0)) {
        listShipmentSort[index] = item.copyWith(
          selectedQuantity: item.currentQuantity?.toInt() ?? 0,
        );
        valueChange = 0;
      } else {
        listShipmentSort[index] = item.copyWith(
          selectedQuantity:
              (item.selectedQuantity ~/ valueUnitChange) * valueUnitChange +
                  valueChange.toInt() * valueUnitChange,
        );
      }

      // totalQuantityFromShipment += item.selectedQuantity;
      diffitenceQuantity -= valueChange;
    }
    shipment = shipment?.copyWith(data: listShipmentSort);
    return listShipmentSort.where((e) => e.selectedQuantity > 0).toList();
  }

  bool get isShipmentQuantityEnough {
    return totalShipmentQuantity >= (quantity ?? 0);
  }

  num get totalShipmentQuantity {
    return shipment?.data?.fold<double>(
          0,
          (total, e) {
            return total +=
                (e.currentQuantity?.toInt() ?? 0) ~/ valueUnitChange;
          },
        ) ??
        0;
  }

  int get valueUnitChange {
    return unit.fold(
      1,
      (total, e) {
        if (e.level != null && unitSell?.level != null) {
          if (e.level! > unitSell!.level!) {
            total = total * (e.value ?? 1);
          }
        }
        return total;
      },
    );
  }

  num get totalShipmentQuantitySelected {
    return (shipment?.data ?? []).fold<num>(0, (total, e) {
      return total += e.selectedQuantity;
    },);
  }

  num get totalShipmentQuantitySelectedByUnit {
    return (shipment?.data ?? []).fold<num>(0, (total, e) {
      return total += e.selectedQuantity;
    },) ~/ valueUnitChange;
  }
}
