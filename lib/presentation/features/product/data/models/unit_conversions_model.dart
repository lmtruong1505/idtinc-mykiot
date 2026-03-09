// To parse this JSON data, do
//
//     final unitConversionModel = unitConversionModelFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_conversions_model.freezed.dart';
part 'unit_conversions_model.g.dart';

@freezed
class UnitConversionModel with _$UnitConversionModel {
  const UnitConversionModel._();

  const factory UnitConversionModel({
    int? id,
    double? priceSell,
    double? priceImport,
    String? title,
    dynamic weightConversion,
    int? times,
    int? unit,
  }) = _UnitConversionModel;

  factory UnitConversionModel.fromJson(Map<String, dynamic> json) => _$UnitConversionModelFromJson(json);
}

UnitConversionModel unitConversionModelFromJson(String str) => UnitConversionModel.fromJson(json.decode(str));

String unitConversionModelToJson(UnitConversionModel data) => json.encode(data.toJson());