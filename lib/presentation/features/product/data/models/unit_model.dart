

import 'package:freezed_annotation/freezed_annotation.dart';

import 'unit_conversions_model.dart';

part 'unit_model.freezed.dart';
part 'unit_model.g.dart';

@freezed
class UnitModel with _$UnitModel {
  const UnitModel._();

  const factory UnitModel({
    int? id,
    @JsonKey(name: 'price_sell')
    double? priceSell,
    @JsonKey(name: 'price_import')
    double? priceImport,
    int? value,
    String? name,
    @JsonKey(name: 'default')
    bool? isDefault,
    List<UnitConversionModel>? conversions,
    @JsonKey(name: 'sell_price')
    double? sellPrice,
    @JsonKey(name: 'import_price')
    double? importPrice,
    double? weight,
    @JsonKey(name: 'weight_unit')
    String? weightUnit,
    int? level,
  }) = _UnitModel;

  factory UnitModel.fromJson(Map<String, dynamic> json) => _$UnitModelFromJson(json);
}
