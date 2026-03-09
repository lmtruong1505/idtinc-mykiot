import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/inventory_model_v2.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';

import '../../../../features_v2/models/product/image_model.dart';
import '../../domain/entities/shipment_data_entity.dart';
part 'receipt_import_detail_model.freezed.dart';
part 'receipt_import_detail_model.g.dart';

@freezed
class ReceiptImportDetailModel with _$ReceiptImportDetailModel {
  const factory ReceiptImportDetailModel({
    final int? id,
    final String? code,
    @JsonKey(name: 'input_unit') final num? inputUnit,
    @JsonKey(name: 'input_quantity') final num? inputQuantity,
    @JsonKey(name: 'storage_quantity') final num? storageQuantity,
    @JsonKey(name: 'current_quantity') final num? currentQuantity,
    @JsonKey(name: 'import_price') final num? importPrice,
    @JsonKey(name: 'total_import_price') final num? totalImportPrice,
    final num? variant,
    @JsonKey(name: 'start_date') final DateTime? startDate,
    @JsonKey(name: 'end_date') final DateTime? endDate,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(name: 'slot_data') final dynamic slotData,
    @JsonKey(name: 'input_unit_data') final String? inputUnitData,
    @JsonKey(name: 'product_data') final ProductV3Model? productData,
    @Default(true) bool isExpand,
    @Default(0) int quantityPrint,
    @Default(false) bool selected,
    num? vat,
    num? discount,
  }) = _ReceiptImportDetailModel;

  factory ReceiptImportDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ReceiptImportDetailModelFromJson(json);
}

extension ReceiptImportDetailModelConvert on ReceiptImportDetailModel {
  ShipmentItemEntity get shipmentItemEntity {
    return ShipmentItemEntity(
      id: id,
      code: code,
      startDate: startDate,
      endDate: endDate,
      productData: ProductV2Model(
        id: productData?.id,
        name: productData?.name ?? productData?.productName,
        images: productData?.images?.map((e) {
          return ImageModel(
            fileName: e.fileName,
            isMain: e.isMain,
            url: e.url,
          );
        }).toList(),
        code: productData?.name,

      ),
      selectedQuantity: inputQuantity?.toInt() ?? 0,
      inputUnit: inputUnit?.toInt(),
      inputUnitData: inputUnitData,
      inputQuantity: inputQuantity?.toInt() ?? 0,
      importPrice: importPrice,
      vat: vat,
      discount: discount,
    );
  }
}

@freezed
class ProductV3Model with _$ProductV3Model {
  const factory ProductV3Model({
    @JsonKey(name: 'product_name') final String? productName,
    final int? id,
    final String? name,
    final String? code,
    final dynamic category,
    final dynamic type,
    @JsonKey(name: 'lieu_dung') final dynamic lieuDung,
    @JsonKey(name: 'chi_dinh') final dynamic chiDinh,
    @JsonKey(name: 'chong_chi_dinh') final dynamic chongChiDinh,
    @JsonKey(name: 'cong_dung') final String? congDung,
    @JsonKey(name: 'tac_dung_phu') final String? tacDungPhu,
    @JsonKey(name: 'than_trong') final String? thanTrong,
    @JsonKey(name: 'tuong_tac') final String? tuongTac,
    @JsonKey(name: 'bao_quan') final String? baoQuan,
    @JsonKey(name: 'dong_goi') final String? dongGoi,
    final num? vat,
    @JsonKey(name: 'cong_ty_sx') final String? congTySx,
    @JsonKey(name: 'cong_ty_dk') final String? congTyDk,
    final List<ImageModelV3>? images,
    final bool? active,
    final List<UnitV3Model>? units,
    @JsonKey(name: 'unit_sell') final UnitV3Model? unitSell,
    @JsonKey(name: 'stock_quantity') final num? stockQuantity,
    @JsonKey(name: 'available_stock') final num? availableStock,
    @JsonKey(name: 'total_sold') final num? totalSold,
    @JsonKey(name: 'total_revenue') final num? totalRevenue,
    @Default(0) final num? inputQuantity,
    @Default(0) final num? inputPrice,
    @Default(0) final num? shipmentPrice,
    // @JsonKey(name: 'so_lo') final String? soLo,
    // @JsonKey(name: 'han_su_dung') final String? hanSuDung,

    @JsonKey(name: 'quantity_extract') final num? quantityExtract,
    @JsonKey(name: 'unit_price_extract') final num? unitPriceExtract,
    @JsonKey(name: 'total_amount_extract') final num? totalAmountExtract,
  }) = _ProductV3Model;

  factory ProductV3Model.fromJson(Map<String, dynamic> json) =>
      _$ProductV3ModelFromJson(json);
}

@freezed
class UnitV3Model with _$UnitV3Model {
  const factory UnitV3Model({
    final int? id,
    final String? name,
    final num? level,
    final num? value,
    @JsonKey(name: 'sell_unit') final bool? sellUnit,
    @JsonKey(name: 'sell_price') final num? sellPrice,
    final dynamic weight,
    @JsonKey(name: 'weight_unit') final dynamic weightUnit,
    @JsonKey(name: 'stock_change') final num? stockChange,
  }) = _UnitV3Model;

  factory UnitV3Model.fromJson(Map<String, dynamic> json) =>
      _$UnitV3ModelFromJson(json);
}
