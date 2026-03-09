import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/data/models/service_model.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/service_repository.dart';

import '../../../../../data/apis/end_point.dart';
import '../models/count_model.dart';

@LazySingleton(as: ServiceRepository)
class ServiceRepositoryImpl extends ServiceRepository {
  ServiceRepositoryImpl(this._dio);

  final BaseDio _dio;

  @override
  Future<BaseResponseModel<List<ServiceModel>>> getServices({
    required String search,
    required int limit,
    required int page,
    required int? company,
    bool? active,
  }) async {
    try {
      final query = {
        'page': page,
        'limit': limit,
        'workspace': company,
        'search': search,
        'active': active,
      };
      query.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get('${Api.service}/list', data: query);
      final counts = (res.data['count'] as List)
          .map((e) => CountModel.fromJson(e))
          .toList();
      if(res.data['details'] == null){
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
          data: [],
          extra: counts,
        );
      }
      final data = (res.data['details'] as List)
          .map((e) => ServiceModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
        extra: counts,
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print('e');
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> createService({
    required Map<String, dynamic> service,
  }) async {
    try {
      final res = await _dio.post('${Api.service}/create', data: service);
      // ServiceModel? data;
      final dataRes = res.data['details'];
      if (dataRes != null) {
        //data = ServiceModel.fromJson(dataRes); response data is not a service
      }
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: dataRes,
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<ServiceModel>> getDetail({required int id}) async {
    try {
      final res = await _dio.get('${Api.service}/detail/$id');
      final data = ServiceModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> updateService(
      {required int id, required Map<String, dynamic> service,}) async {

    try {
      final res = await _dio.put('${Api.service}/detail/$id', data: service);
      // ServiceModel? data;
      final dataRes = res.data['details'];
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: dataRes,
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> deleteService({required int id}) async {
   try {
     final res = await _dio.delete('${Api.service}/detail/$id');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
   }
   catch(e){
      return BaseResponseModel(
        code: 400,
        message: 'Error',
      );
   }
  }
}
