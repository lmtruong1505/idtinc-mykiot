

import '../../../../../data/models/base/response.dart';
import '../../data/models/product_type_model.dart';

abstract class ProductTypeRepository {
  Future<BaseResponseModel<List<ProductTypeModel>>> getList({
    required String? search,
    required int? limit,
    required int? page,
    required int? company,
  });
}