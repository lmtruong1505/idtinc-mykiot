import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/customer/data/models/medical_record_customer_model.dart';
import 'package:pharmago/presentation/features/customer/data/models/medical_record_model.dart';

import '../../../../../data/apis/end_point.dart';
import '../../domain/repositories/medical_record_repository.dart';

@LazySingleton(as: MedicalRecordRepository)
class MedicalRecordRepositoryImpl extends MedicalRecordRepository {
  MedicalRecordRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<int>> create(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('${Api.medicalRecord}/create', data: payload);
      return BaseResponseModel(
        code: res.data['code'],
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
  Future<BaseResponseModel<MedicalRecordModel>> getDetail(int id) async {
    try {
      final res = await _dio.get('${Api.medicalRecord}/detail/$id');
      final data = MedicalRecordModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.data['code'],
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
  Future<BaseResponseModel<List<MedicalRecordModel>>> getList({
    required int customer,
    String? search,
    int? page,
    int? limit,
  }) async {
    try {
      final query = {
        'customer': customer,
        'search': search,
        'page': page,
        'limit': limit,
      };
      final res = await _dio.get('${Api.medicalRecord}/list', data: query);
      final data = (res.data['details'] as List)
          .map((e) => MedicalRecordModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
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
  Future<BaseResponseModel<List<MedicalRecordCustomerModel>>>
      medicalRecordsCustomer(
    int idCustomer,
    String search,
  ) async {
    try {
      final query = {
        'customer': idCustomer,
        'search': search,
      };
      final res = await _dio.get(Api.medicalRecordsCustomer, data: query);
      final data = (res.data['data'] as List)
          .map((e) => MedicalRecordCustomerModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      log('e: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
