import 'package:freezed_annotation/freezed_annotation.dart';

import 'unit_entity.dart';
import 'variant_warehouse_entity.dart';

part 'product_entity.freezed.dart';

@freezed
class ProductEntity with _$ProductEntity {
  const ProductEntity._();

  const factory ProductEntity({
    int? id,
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
    String? moTa,
    String? dongGoi,
    String? noiSx,
    String? congTySx,
    String? congTyDk,
    String? phanLoai,
    String? tieuChuanSx,
    String? dangBaoChe,
    List<String>? image,
    bool? active,
    int? quantity,
    UnitEntity? unit,
    @Default([]) List<VariantWarehouseEntity> productWarehouse,
  }) = _ProductEntity;
}
