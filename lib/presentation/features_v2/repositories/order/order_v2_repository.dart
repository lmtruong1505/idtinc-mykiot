import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/order/data/models/order_model.dart';
import 'package:pharmago/presentation/features_v2/models/order/order_detail_v2_model.dart';

import '../../../di/di.dart';
import '../../models/order/order_preview_model.dart';


class OrderRepositoryV2Impl {
  OrderRepositoryV2Impl();

  final _dio = getIt.get<BaseDio>();

  Future<BaseResponseModel<int>> createOrder({
    required Map<String, dynamic> order,
    required List<Map<String, dynamic>> orderItem,
    required Map<String, dynamic> orderPayment,
    required List<Map<String, dynamic>> orderPaymentItem,
    required List<Map<String, dynamic>> orderServiceItem,
    required int warehouse,
    String? mbUuid,
  }) async {
    try {
      final payload = {
        'order': order,
        'order_items': orderItem,
        'payment': orderPayment,
        'payment_items': orderPaymentItem,
        'warehouse': warehouse,
        'service_items': orderServiceItem,
        'mb_uuid': mbUuid,
      };
      payload.removeWhere(
        (key, value) => value == null,
      );
      final res = await _dio.post('${Api.order}/create', data: payload);
      final data = BaseResponseModel<int>.fromJson(res.data);
      return data;
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<OrderPreviewV2Model>>> getList({
    required int company,
    int? warehouse,
    String? search,
    String? medicalBill,
    String? type,
    int? page,
    int? limit,
    int? customerId,
    String? orderBy,
    DateTime? createdFrom,
    DateTime? createdTo,
    DateTime? updatedFrom,
    DateTime? updatedTo,
  }) async {
    try {
      final payload = {
        'workspace': company,
        'warehouse': warehouse,
        'search': search,
        'type': type,
        'page': page,
        'limit': limit,
        'customer': customerId,
        'medical_bill': medicalBill,
        'created_start': createdFrom != null
            ? DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(createdFrom)
            : null,
        'created_end': createdTo != null
            ? DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(createdTo)
            : null,
        'updated_start': updatedFrom != null
            ? DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(updatedFrom)
            : null,
        'updated_end': updatedTo != null
            ? DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(updatedTo)
            : null,
        'order_by': orderBy,
      };
      payload.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get('${Api.order}/list', data: payload);
      final data = (res.data['details'] as List)
          .map((e) => OrderPreviewV2Model.fromJson(e))
          .toList();
      // OrderCountModel? extra;
      // if (res.data['count'] != null) {
      //   extra = OrderCountModel.fromJson(res.data['count']);
      // }
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
        // extra: extra,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<OrderDetailV2Model>> getDetail({
    required int id,
  }) async {
    try {
      final res = await _dio.get('${Api.order}/detail/$id');
      final data = OrderDetailV2Model.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
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

  Future<BaseResponseModel> updateStatus({
    required int id,
    required String code,
  }) async {
    try {
      final payload = {
        'code': code,
      };
      final res = await _dio.put('${Api.order}/order/$id', data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
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

  Future<BaseResponseModel> update({
    required int id,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final res = await _dio.put('${Api.order}/detail/$id', data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
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

  Future<BaseResponseModel<OrderModel>> scan({required String code}) async {
    try {
      final res = await _dio.post('${Api.order}/scan', data: {'code': code});
      final data = OrderModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
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

  Future<BaseResponseModel<int>> createOrderV2({
    required Map<String, dynamic> order,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final payload = {
        'order': order,
        'items': items,
      };
      final res = await _dio.post('${Api.order}/create', data: payload);
      final data = BaseResponseModel<int>.fromJson(res.data);
      return data;
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> paidOrder({
    required int id,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final res = await _dio.post('${Api.order}/detail/$id/payment', data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
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

  Future<BaseResponseModel> sendZalo({required int id}) async{
    try {
      final res = await _dio.post('${Api.order}/send-order-zalo/$id');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    }
    catch(e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> delete({required int id}) async {
    try {
      final res = await _dio.delete('${Api.order}/detail/$id');
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

  Future<BaseResponseModel> updatePrescription({
    required int id,
    required String prescriptionCode,
    List<Map<String, dynamic>> prescriptionImages = const [],
    List<File> prescriptionImagesAdd = const [],
  }) async {
    try {
      final Map<String, dynamic> payload = {
        'prescription_code': prescriptionCode,
        'prescription_images': jsonEncode(prescriptionImages),
      };
      if (prescriptionImagesAdd.isNotEmpty) {
        payload['prescription_images_add'] = await Future.wait(
          prescriptionImagesAdd.map(
            (e) => MultipartFile.fromFile(e.path),
          ),
        );
      }
      final res = await _dio.put(
        '${Api.order}/detail/$id/prescription',
        data: FormData.fromMap(payload),
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
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

}
