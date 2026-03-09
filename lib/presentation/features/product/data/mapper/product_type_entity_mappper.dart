

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';

import '../../domain/entities/product_type_entity.dart';
import '../models/product_type_model.dart';

@injectable
class ProductTypeEntityMapper extends BaseDataMapper<ProductTypeModel, ProductTypeEntity> {
  @override
  ProductTypeEntity mapToEntity(ProductTypeModel? data) {
    return ProductTypeEntity(
      id: data?.id,
      name: data?.name,
      code: data?.code,
      company: data?.company,
    );
  }
}
