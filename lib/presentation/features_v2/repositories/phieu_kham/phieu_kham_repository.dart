import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/order/data/models/order_preview_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/calendar/event_model.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../models/prescription/prescription_model.dart';

class PhieuKhamRepository {
  final _dio = getIt<BaseDio>();
  Future<BaseResponseModel> create(Map<String, dynamic> req) async {
    try {
      req.removeWhere(
        (key, value) => value == null,
      );
      final res = await _dio.post(
        Api.createPhieuKham,
        data: req,
      );
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: res.data['data'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<EventModel>>> getList(
    Map<String, dynamic> req,
  ) async {
    try {
      req.removeWhere(
        (key, value) => value == null,
      );
      final List<EventModel> list = [];
      final res = await _dio.get(
        Api.listPhieuKham,
        data: req,
      );
      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(EventModel.fromJson(json));
        }
      }

      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<EventModel>> detail(int id) async {
    try {
      final res = await _dio.get(
        '${Api.detailPhieuKham}$id?company=$getCompany',
      );
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: EventModel.fromJson(res.data['details'] ?? {}),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> update({
    required int id,
    required Map<String, dynamic> req,
  }) async {
    try {
      req.removeWhere(
        (key, value) => value == null,
      );
      final res = await _dio.put(
        '${Api.detailPhieuKham}$id?company=$getCompany',
        data: req,
      );
      return BaseResponseModel(
        code: res.data['code'] ?? res.statusCode,
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> createPrescription({
    required Map<String, dynamic> req,
  }) async {
    try {
      req.removeWhere(
        (key, value) => value == null,
      );
      final res = await _dio.post(
        Api.createPrescription,
        data: req,
      );
      return BaseResponseModel(
        code: res.data['code'] ?? res.statusCode,
        data: res.data?['details'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<PrescriptionModel>> detailPrescription({
    required String uuid,
  }) async {
    try {
      final res = await _dio.get(
        Api.detailPrescription + uuid,
      );

      return BaseResponseModel(
        code: res.data['code'] ?? res.statusCode,
        message: res.data['message'],
        data: res.data['details'] == null
            ? null
            : PrescriptionModel.fromJson(res.data['details']),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> updatePrescription({
    required String uuid,
    required Map<String, dynamic> req,
  }) async {
    try {
      final res = await _dio.put(Api.detailPrescription + uuid, data: req);

      return BaseResponseModel(
        code: res.data['code'] ?? res.statusCode,
        message: res.data['message'],
        data: uuid,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<OrderPreviewModel>>> order({
    required String uuid,
    int page = 1,
    int limit = 20,
    TypeOrderEnum? type,
  }) async {
    try {
      final req = {'page': page, 'limit': limit, 'type': type?.code};
      req.removeWhere(
        (key, value) => value == null,
      );
      final res = await _dio.get(
        Api.orderPhieuKham + uuid,
        data: req,
      );
      final List<OrderPreviewModel> list = [];
      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(OrderPreviewModel.fromJson(json));
        }
      }

      return BaseResponseModel(
        code: res.data['code'] ?? res.statusCode,
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
