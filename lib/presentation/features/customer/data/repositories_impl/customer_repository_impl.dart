import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features/customer/domain/repositories/customer_repository.dart';
import 'package:pharmago/presentation/features_v2/models/customer/file_model.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

@LazySingleton(as: CustomerRepository)
class CustomerRepositoryImpl extends CustomerRepository {
  CustomerRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<List<CustomerModel>>> getList(
    int company,
    String search,
    int page,
  ) async {
    try {
      final query = {
        'company': company,
        'page': page + 1,
        'limit': 10,
        'search': search,
      };
      final res = await _dio.get(Api.customerList, data: query);

      final data = (res.data['details'] as List?)
          ?.map((e) => CustomerModel.fromJson(e))
          .toList();

      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
        extra: res.data['count'],
      );
    } catch (e) {
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
  Future<BaseResponseModel<CustomerModel>> getDetail(int id) async {
    try {
      final res = await _dio.get('${Api.customerDetail}$id');
      final dataRes = CustomerModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: dataRes,
      );
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<CustomerModel>> create(
      Map<String, dynamic> data) async {
    try {
      final res = await _dio.post(Api.customerCreate, data: data);
      final dataModel = CustomerModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: dataModel,
      );
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel> update(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await _dio.put('${Api.customerDetail}$id', data: data);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel> delete(int id) async {
    try {
      final res = await _dio.delete('${Api.customerDetail}$id');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel> uploadFile({
    required int customerId,
    required XFile file,
    required String type,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final String base64Image = base64Encode(bytes);
      final res = await _dio.post(
        Api.customerUploadFile,
        data: {
          'type': type,
          'customer': customerId,
          'files': [
            {
              'name': file.name,
              'file': base64Image,
            }
          ],
        },
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<List<FileModel>>> getFile({
    required int customerId,
    required String type,
    String? appointmentSchedule,
  }) async {
    try {
      final List<FileModel> list = [];
      final res = await _dio.get(
        Api.customerUploadFile,
        data: {
          'customer': customerId,
          'company': getCompany,
          if (appointmentSchedule != null)
            'appointmentSchedule': appointmentSchedule,
          'type': type,
        },
      );

      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(FileModel.fromJson(json));
        }
      }

      return BaseResponseModel<List<FileModel>>(
        code: res.data['code'],
        data: list,
        message: res.data['message'],
      );
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }
}
