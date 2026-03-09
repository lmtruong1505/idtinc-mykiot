
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/data/models/unit_model.dart';

part 'variant_model.freezed.dart';
part 'variant_model.g.dart';

@freezed
class VariantModel with _$VariantModel {
  const VariantModel._();

  const factory VariantModel({
    @Required() int? id,
    @Required() String? code,
    String? name,
    String? barcode,
    @JsonKey(name: 'decision_number')
    String? decisionNumber,
    @JsonKey(name: 'register_number')
    String? registerNumber,
    String? longevity,
    double? vat,
    int? product,
    //@JsonKey(name: 'image')
    String? media,
    @JsonKey(name: 'quantity_in_stock')
    @Default(0) int quantityInStock,
    List<UnitModel>? units,
    @JsonKey(name: 'price_sell')
    @Default(0) double priceSell,
    @JsonKey(name: 'price_import')
    @Default(0) double priceImport,
    @Default(0) double revenue,
    @JsonKey(name: 'initial_inventory')
    int? initialInventory,
    @JsonKey(name: 'real_inventory')
    int? realInventory,
    int? level,
  }) = _VariantModel;

  factory VariantModel.fromJson(Map<String, dynamic> json) => _$VariantModelFromJson(json);
}