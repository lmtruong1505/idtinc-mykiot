import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/product/data/mapper/unit_entity_mapper.dart';

import '../../../../../data/mapper/base/data_mapper.dart';
import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';
import 'variant_warehouse_entity_mapper.dart';

@injectable
class ProductEntityMapper extends BaseDataMapper<ProductModel, ProductEntity> {

  ProductEntityMapper(this._unitEntityMapper, this._variantWarehouseMapper);
  final UnitEnityMapper _unitEntityMapper;
  final VariantWarehouseEntityMapper _variantWarehouseMapper;

  @override
  ProductEntity mapToEntity(ProductModel? data) {
    return ProductEntity(
      id: data?.id,
      name: data?.name,
      code: data?.code,
      category: data?.category,
      type: data?.type,
      taDuoc: data?.taDuoc,
      nongDo: data?.nongDo,
      lieuDung: data?.lieuDung,
      chiDinh: data?.chiDinh,
      chongChiDinh: data?.chongChiDinh,
      congDung: data?.congDung,
      tacDungPhu: data?.tacDungPhu,
      thanTrong: data?.thanTrong,
      tuongTac: data?.tuongTac,
      baoQuan: data?.baoQuan,
      dongGoi: data?.dongGoi,
      moTa: data?.moTa,
      noiSx: data?.noiSx,
      congTySx: data?.congTySx,
      congTyDk: data?.congTyDk,
      image: data?.image,
      active: data?.active,
      quantity: data?.quantity,
      unit: _unitEntityMapper.mapToEntity(data?.unit),
      productWarehouse: _variantWarehouseMapper.mapToListEntity(data?.productWarehouse),
    );
  }
}
