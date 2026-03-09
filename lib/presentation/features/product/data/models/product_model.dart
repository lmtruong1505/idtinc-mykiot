
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/data/models/unit_model.dart';

import 'variant_warehouse_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    int? id,
    @JsonKey(name: 'product_name')
    String? name,
    String? code,
    int? category,
    int? type,
    String? taDuoc,
    String? nongDo,
    String? lieuDung,
    String? chiDinh,
    String? chongChiDinh,
    String? congDung,
    String? tacDungPhu,
    String? thanTrong,
    String? tuongTac,
    String? baoQuan,
    String? dongGoi,
    String? noiSx,
    String? moTa,
    String? congTySx,
    @JsonKey(name: 'conTyDk')
    String? congTyDk,
    String? phanLoai,
    String? tieuChuanSx,
    String? dangBaoChe,
    List<String>? image,
    bool? active,
    int? quantity,
    UnitModel? unit,
    @JsonKey(name: 'product_warehouse')
    @Default([]) List<VariantWarehouseModel> productWarehouse,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);  
}