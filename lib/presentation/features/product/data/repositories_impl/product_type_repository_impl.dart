import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/data/models/product_type_model.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/product_type_repository.dart';

@LazySingleton(as: ProductTypeRepository)
class ProductTypeRepositoryImpl extends ProductTypeRepository {
  ProductTypeRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<List<ProductTypeModel>>> getList({
    required String? search,
    required int? limit,
    required int? page,
    required int? company,
  }) async {
    try {
      final query = {
        'page': page,
        'limit': limit,
        'search': search,
        'company': company,
      };
      query.removeWhere((key, value) => value == null || value == '');
      final res =
          await _dio.get('${Api.productType}', data: query);
      final data = (res.data['details'] as List?)?.map((e) => ProductTypeModel.fromJson(e)).toList();
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
