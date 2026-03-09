import 'package:json_annotation/json_annotation.dart';

part 'product_shipments_model.g.dart';

@JsonSerializable()
class ProductShipmentsModel {
  ProductShipmentsModel({
    this.id,
    this.storageQuantity,
    this.endDate,
    this.status,
    this.statusLabel,
    this.quantity,
    this.importPrice,
    this.storageUnitData,
    this.inputUnitData,
    this.createdAt,
  });

  final int? id;

  @JsonKey(name: 'storage_quantity')
  final num? storageQuantity;
  @JsonKey(name: 'current_quantity')
  final num? quantity;
  @JsonKey(name: 'import_price')
  final num? importPrice;
  @JsonKey(name: 'storage_unit_data')
  final String? storageUnitData;
  @JsonKey(name: 'input_unit_data')
  final String? inputUnitData;
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  final num? status;

  @JsonKey(name: 'status_label')
  final String? statusLabel;

  factory ProductShipmentsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductShipmentsModelFromJson(json);
}
