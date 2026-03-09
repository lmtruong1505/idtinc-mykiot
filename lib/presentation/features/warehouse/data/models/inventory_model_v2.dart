import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_model_v2.freezed.dart';
part 'inventory_model_v2.g.dart';

@freezed
class InventoryModelV2 with _$InventoryModelV2 {
  const factory InventoryModelV2({
    int? variant,
    num? inventory,
    @JsonKey(name: 'total_shipment') int? totalShipment,
    @JsonKey(name: 'quantity_near_date') num? quantityNearDate,
    @JsonKey(name: 'total_shipment_near_date') int? totalShipmentNearDate,
    @JsonKey(name: 'quantity_exp_date') num? quantityExpDate,
    Product? product,
  }) = _InventoryModelV2;

  factory InventoryModelV2.fromJson(Map<String, dynamic> json) =>
      _$InventoryModelV2FromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    int? id,
    @JsonKey(name: 'product_name') String? productName,
    String? code,
    String? barcode,
    List<ImageModelV3>? image,
    @JsonKey(name: 'unit_storage') UnitStorage? unitStorage,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
class UnitStorage with _$UnitStorage {
  const factory UnitStorage({
    int? id,
    String? name,
    int? level,
    int? value,
  }) = _UnitStorage;

  factory UnitStorage.fromJson(Map<String, dynamic> json) =>
      _$UnitStorageFromJson(json);
}

@freezed
class ImageModelV3 with _$ImageModelV3 {
  const factory ImageModelV3({
    final String? url,
    @JsonKey(name: 'is_main') final bool? isMain,
    @JsonKey(name: 'file_name') final String? fileName,
  }) = _ImageModelV3;

  factory ImageModelV3.fromJson(Map<String, dynamic> json) =>
      _$ImageModelV3FromJson(json);
}
