import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/supplier/domain/repositories/supplier_repository.dart';

@LazySingleton(as: SupplierRepository)
class SupplierRepositoryImpl extends SupplierRepository {
  SupplierRepositoryImpl(this._dio);

  final BaseDio _dio;

  @override
  Future<dynamic> getList(int company, String search, int page) async {
    try {
      final query = {
        'page': page + 1,
        'limit': 10,
        'company': company,
        'search': search,
      };
      final res = await _dio.get(Api.supplierList, data: query);
      final dataRes = res.data['details'];
      if (dataRes != null) return dataRes;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  @override
  Future<dynamic> getDetail(int id) async {
    try {
      final res = await _dio.get("${Api.supplierDetail}$id");
      final dataRes = res.data['details'];
      if (dataRes != null) return dataRes;
    } catch (e) {
      if (kDebugMode) print(e);
    }
    return null;
  }

  @override
  Future<BaseResponseModel> create(Map<String, Object> data) async {
    try {
      final res = await _dio.post(Api.supplierCreate, data: data);
      return BaseResponseModel(
          code: res.data['code'], message: res.data['message']);
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel> update(int id, Map<String, Object> data) async {
    try {
      final res = await _dio.put('${Api.supplierDetail}$id', data: data);
      return BaseResponseModel(
          code: res.data['code'], message: res.data['message']);
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel> delete(int id) async {
    try {
      final res = await _dio.delete("${Api.supplierDetail}$id");
      return BaseResponseModel(
          code: res.data['code'], message: res.data['message']);
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }
}
