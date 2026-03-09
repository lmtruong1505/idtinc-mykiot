import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';

import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl extends CategoryRepository {
  CategoryRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<List<CategoryModel>>> getList({
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
      final res = await _dio.get('${Api.category}', data: query);
      final data = (res.data['details'] as List?)
          ?.map((e) => CategoryModel.fromJson(e))
          .toList();
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

  @override
  Future<BaseResponseModel<int>> create({
    String? code,
    required String name,
    String? description,
    List<int>? products,
    required int company,
  }) async {
    try {
      final query = {
        'code': code,
        'name': name,
        'description': description,
        'products': products,
        'company': company,
      };
      query.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.post('${Api.category}/create', data: query);
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<BaseResponseModel<CategoryModel>> getDetail({required int id}) {
    // TODO: implement getDetail
    throw UnimplementedError();
  }

  @override
  Future<BaseResponseModel<int>> update(
      {String? code,
      required String name,
      String? description,
      List<int>? products,
      required int id}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
