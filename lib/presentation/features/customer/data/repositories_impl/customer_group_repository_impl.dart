import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_group_model.dart';

import '../../../../../data/apis/end_point.dart';
import '../../domain/repositories/customer_group_repository.dart';

@LazySingleton(as: CustomerGroupRepository)
class CustomerGroupRepositoryImpl extends CustomerGroupRepository {
  CustomerGroupRepositoryImpl(this._dio);

  final BaseDio _dio;

  @override
  Future<BaseResponseModel> create(
      {required Map<String, dynamic> payload}) async {
    try {
      final res = await _dio.post(Api.customerGroupCreate, data: payload);
      final data = res.data['details'];
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
      );
    } on DioException catch (e) {
      return BaseResponseModel(
        code: e.response?.statusCode,
        message: e.response?.data['message'],
      );
    }
  }

  @override
  Future<BaseResponseModel> delete(int id) async {
    try{
      final res = await _dio.delete('${Api.customerGroupDetail}$id');
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
      );
    } on DioException catch (e) {
      return BaseResponseModel(
        code: e.response?.statusCode,
        message: e.response?.data['message'],
      );
    }
  }

  @override
  Future<BaseResponseModel<CustomerGroupModel>> getDetail({
    required int id,
  }) async {
    try{
      final res = await _dio.get('${Api.customerGroupDetail}/$id');
      final data = CustomerGroupModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
      );
    } on DioException catch (e) {
      return BaseResponseModel(
        code: e.response?.statusCode,
        message: e.response?.data['message'],
      );
    }
  }

  @override
  Future<BaseResponseModel<List<CustomerGroupModel>>> getList({
    required int? company,
    String? search,
    int? page,
    int? limit,
  }) async {
    try {
      final query = {
        'company': company,
        'page': page,
        'limit': limit,
        'search': search ?? '',
      };
      final res = await _dio.get(Api.customerGroupList, data: query);
      final data = (res.data['details'] as List?)
          ?.map(
            (e) => CustomerGroupModel.fromJson(e),
          )
          .toList();
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
      );
    } on DioException catch (e) {
      return BaseResponseModel(
        code: e.response?.statusCode,
        message: e.response?.data['message'],
      );
    }
  }

  @override
  Future<BaseResponseModel> update(int id, Map<String, dynamic> data) async {
    try{
      final res = await _dio.put('${Api.customerGroupDetail}$id', data: data);
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
      );
    } on DioException catch (e) {
      return BaseResponseModel(
        code: e.response?.statusCode,
        message: e.response?.data['message'],
      );
    }
  }
}
