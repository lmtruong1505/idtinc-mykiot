import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../models/calendar/event_model.dart';

class EventRepository {
  final _dio = getIt<BaseDio>();
  Future<BaseResponseModel> create(Map<String, dynamic> req) async {
    try {
      final res = await _dio.post(
        Api.createEvent,
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

  Future<BaseResponseModel<List<EventModel>>> getList({
    required int company,
    String? search,
    int? customer,
    int? doctor,
    String? timeStart,
    String? timeEnd,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final payload = {
        'company': company,
        'customer': customer,
        'doctor': doctor,
        'time_start': timeStart,
        'time_end': timeEnd,
        'search': search,
        'page': page,
        'limit': limit,
      };
      payload.removeWhere(
        (key, value) => value == null || value == '',
      );
      final res = await _dio.get(
        Api.listEvent,
        data: payload,
      );
      final List<EventModel> list = [];
      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(EventModel.fromJson(json));
        }
      }

      return BaseResponseModel<List<EventModel>>(
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
        '${Api.detailEvent}$id?company=$getCompany',
      );

      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'] ?? res.data['message_trans'],
        data: EventModel.fromJson(res.data['details'] ?? {}),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }Future<BaseResponseModel> delete(int id) async {
    try {
      final res = await _dio.delete(
        '${Api.detailEvent}$id?company=$getCompany',
      );

      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'] ?? res.data['message_trans'],
        data: EventModel.fromJson(res.data['details'] ?? {}),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> uploadFile({
    required int customerId,
    required List<XFile> files,
    required String type,
    String? appointmentSchedule,
    String? medicalBill,
  }) async {
    try {
      //final List<Map<String, String>> filesUpload = [];

      // for (final file in files) {
      //   final bytes = await file.readAsBytes();
      //   final String base64Image = base64Encode(bytes);
      //   filesUpload.add({
      //     'name': file.name,
      //     'file': base64Image,
      //   });
      // }
      final payload = {
        'type': type,
        'customer': customerId,
        'appointmentSchedule': appointmentSchedule,
        'medical_bill': medicalBill,
        'files': files.map(
          (e) => MultipartFile.fromFileSync(e.path),
        ).toList(),
      };
      payload.removeWhere(
        (key, value) => value == null,
      );

      final res = await _dio.post(
        Api.customerUploadFile,
        data: FormData.fromMap(payload),
      );

      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'] ?? res.data['message_trans'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
