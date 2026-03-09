import 'package:freezed_annotation/freezed_annotation.dart';

part 'variant_warehouse_model.freezed.dart';
part 'variant_warehouse_model.g.dart';

@freezed
class VariantWarehouseModel with _$VariantWarehouseModel {
  const VariantWarehouseModel._();

  const factory VariantWarehouseModel({
    int? id,
    String? code,
    String? name,
    String? media,
    @JsonKey(name: 'quantity_in_stock') int? amount,
    @JsonKey(name: 'price_import') int? priceImport,
  }) = _VariantWarehouseModel;

  factory VariantWarehouseModel.fromJson(Map<String, dynamic> json) =>
      _$VariantWarehouseModelFromJson(json);
}
