// To parse this JSON data, do
//
//     final variantWarehouseModel = variantWarehouseModelFromJson(jsonString);

import 'dart:convert';

import 'package:pharmago/presentation/features/product/data/models/variant_model.dart';

VariantWarehouseModel variantWarehouseModelFromJson(String str) =>
    VariantWarehouseModel.fromJson(json.decode(str));

String variantWarehouseModelToJson(VariantWarehouseModel data) =>
    json.encode(data.toJson());

class VariantWarehouseModel {
  final int? id;
  final double? priceImport;
  final int? variant;
  final VariantModel? variantData;
  final int? warehouse;
  final int? amountData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VariantWarehouseModel({
    this.id,
    this.priceImport,
    this.variant,
    this.variantData,
    this.warehouse,
    this.amountData,
    this.createdAt,
    this.updatedAt,
  });

  VariantWarehouseModel copyWith({
    int? id,
    double? priceImport,
    int? variant,
    VariantModel? variantData,
    int? warehouse,
    int? amountData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      VariantWarehouseModel(
        id: id ?? this.id,
        priceImport: priceImport ?? this.priceImport,
        variant: variant ?? this.variant,
        variantData: variantData ?? this.variantData,
        warehouse: warehouse ?? this.warehouse,
        amountData: amountData ?? this.amountData,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory VariantWarehouseModel.fromJson(Map<String, dynamic> json) =>
      VariantWarehouseModel(
        id: json["id"],
        priceImport: json["price_import"]?.toDouble(),
        variant: json["variant"],
        variantData: json["variant_data"] == null
            ? null
            : VariantModel.fromJson(json["variant_data"]),
        warehouse: json["warehouse"],
        amountData: json["number_in_stock"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price_import": priceImport,
        "variant": variant,
        "variant_data": variantData?.toJson(),
        "warehouse": warehouse,
        "amount_data": amountData,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
