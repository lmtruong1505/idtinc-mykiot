import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/data/models/variant_model.dart';

part 'inventory_model.freezed.dart';
part 'inventory_model.g.dart';

@freezed
class InventoryModel with _$InventoryModel {
  const InventoryModel._();

  const factory InventoryModel({
    int? id,
    String? code,
    String? media,
    int? inventory,
    int? quantity,
    VariantModel? variant,
  }) = _InventoryModel;

  factory InventoryModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryModelFromJson(json);
}
