import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/data/models/brand_model.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/brand_repository.dart';

@LazySingleton(as: BrandRepository)
class BrandRepositoryImpl extends BrandRepository {
  BrandRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<List<BrandModel>>> getList({
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
      final res = await _dio.get('${Api.brand}', data: query);
      final data = (res.data['details'] as List?)
          ?.map((e) => BrandModel.fromJson(e))
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
  Future<BaseResponseModel<BrandModel>> getDetail({required int id}) async {
    try {
      final res = await _dio.get('${Api.brand}/detail/$id');
      final data = BrandModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: 200,
        message: 'success',
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
      final payload = {
        'code': code,
        'name': name,
        'description': description,
        'products': products,
        'company': company,
      };
      payload.removeWhere((key, value) => value == '' || value == null);
      final res = await _dio.post('${Api.brand}/create', data: payload);
      return BaseResponseModel(
        code: 200,
        message: 'success',
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
  Future<BaseResponseModel> delete(int id) async {
    try {
      final res = await _dio.delete('${Api.brand}/detail/$id');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> update({
    String? code,
    required String name,
    String? description,
    List<int>? products,
    required int id,
  }) async {
    try {
      final payload = {
        'code': code,
        'name': name,
        'description': description,
        'products': products,
      };
      payload.removeWhere((key, value) => value == '' || value == null);
      final res = await _dio.put('${Api.brand}/detail/$id', data: payload);
      return BaseResponseModel(
        code: 200,
        message: 'success',
        data: res.data['details'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
