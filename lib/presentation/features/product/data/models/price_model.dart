import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_model.freezed.dart';
part 'price_model.g.dart';

@freezed
class PriceModel with _$PriceModel {
  const PriceModel._();

  const factory PriceModel({
    int? id,
    @JsonKey(name: 'variant_code') String? code,
    @JsonKey(name: 'variant_name') String? name,
    @JsonKey(name: 'price_import') int? priceImport,
    @JsonKey(name: 'price_sell') int? priceSell,
    int? unit,
    @JsonKey(name: 'unit_name') String? unitName,
    String? image,
  }) = _PriceModel;

  factory PriceModel.fromJson(Map<String, dynamic> json) =>
      _$PriceModelFromJson(json);
}
