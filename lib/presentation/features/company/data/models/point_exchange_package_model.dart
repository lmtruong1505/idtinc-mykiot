import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';

import '../../../../features_v2/models/product/unit_v2_model.dart';

class PointExchangePackageModel {
  final int? id;
  final String? name;
  final int? point;
  final int? workspace;
  final bool? status;
  final String? note;
  final List<PointExchangePackageItemModel>? items;

  PointExchangePackageModel({
    this.id,
    this.name,
    this.point,
    this.workspace,
    this.status,
    this.note,
    this.items,
  });

  PointExchangePackageModel copyWith({
    int? id,
    String? name,
    int? point,
    int? workspace,
    bool? status,
    String? note,
    List<PointExchangePackageItemModel>? items,
  }) =>
      PointExchangePackageModel(
        id: id ?? this.id,
        name: name ?? this.name,
        point: point ?? this.point,
        workspace: workspace ?? this.workspace,
        status: status ?? this.status,
        note: note ?? this.note,
        items: items ?? this.items,
      );

  factory PointExchangePackageModel.fromJson(Map<String, dynamic> json) =>
      PointExchangePackageModel(
        id: json['id'],
        name: json['name'],
        point: json['point'],
        workspace: json['workspace'],
        status: json['status'],
        note: json['note'],
        items: json['items'] == null
            ? []
            : List<PointExchangePackageItemModel>.from(json['items']!.map((x) => PointExchangePackageItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {};
}

class PointExchangePackageItemModel {
  final ProductV2Model? product;
  final UnitV2Model? unit;
  final int? unitId;
  final int? quantity;

  PointExchangePackageItemModel({
    this.product,
    this.unit,
    this.unitId,
    this.quantity,
  });

  PointExchangePackageItemModel copyWith({
    ProductV2Model? product,
    UnitV2Model? unit,
    int? unitId,
    int? quantity,
  }) =>
      PointExchangePackageItemModel(
        product: product ?? this.product,
        unit: unit ?? this.unit,
        unitId: unitId ?? this.unitId,
        quantity: quantity ?? this.quantity,
      );

  factory PointExchangePackageItemModel.fromJson(Map<String, dynamic> json) => PointExchangePackageItemModel(
        product: json['product'] == null
            ? null
            : ProductV2Model.fromJson(json['product']['product']),
        unit: json['unit'] == null
            ? null
            : UnitV2Model.fromJson(json['unit']),
        unitId: json['unit_id'],
        quantity: json['quantity'],
      );
}
