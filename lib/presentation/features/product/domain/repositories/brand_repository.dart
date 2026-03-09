
import '../../../../../data/models/base/response.dart';
import '../../data/models/brand_model.dart';

abstract class BrandRepository {
  Future<BaseResponseModel<List<BrandModel>>> getList({
    required String? search,
    required int? limit,
    required int? page,
    required int? company,
  });
  
  Future<BaseResponseModel<BrandModel>> getDetail({
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