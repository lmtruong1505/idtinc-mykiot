

import '../../../../../data/models/base/response.dart';
import '../../data/models/category_model.dart';

abstract class CategoryRepository {
  Future<BaseResponseModel<List<CategoryModel>>> getList({
    required String? search,
    required int? limit,
    required int? page,
    required int? company,
  });

  Future<BaseResponseModel<CategoryModel>> getDetail({
    required int id,
  });
  
  Future<BaseResponseModel<int>> create({
    String? code,
    required String name,
    String? description,
    List<int>? products,
    required int company,
  });

  Future<BaseResponseModel<int>> update({
    String? code,
    required String name,
    String? description,
    List<int>? products,
    required int id,
  });

  Future<BaseResponseModel> delete(int id);
}