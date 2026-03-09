import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features_v2/models/event/create_event_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../data/apis/end_point.dart';
import '../../../../data/config/dio.dart';
import '../../../../data/models/base/response.dart';
import '../../../../shared/components/widgets/calendar_custom.dart';
import '../../../di/di.dart';
import '../../../features/schedule/data/models/appointment_schedule_model.dart';
import '../../models/event/detail_event_model.dart';
import '../../models/event/event_v2_mode.dart';
import '../../models/event/filter_event_model.dart';

@injectable
class EventV2Repository {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel<int>> create(
    CreateEventV2Model param,
  ) async {
    try {
      final res = param.id != null
          ? await _dio.put(
              '${Api.detailEvent}${param.id}',
              data: param.toJson(),
            )
          : await _dio.post(
              Api.createEvent,
              data: param.toJson(),
            );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: int.tryParse((res.data['details'] ?? {})['id'].toString()),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<EventV2Model>>> list(
    FilterEventModel param,
  ) async {
    final payload = param.toJson();
    payload.removeWhere(
      (key, value) => value.toString().isEmptyOrNull,
    );
    try {
      final res = await _dio.get(
        Api.listEvent,
        data: payload,
      );
      final List<EventV2Model> list = [];
      if (res.data['details'] is List) {
        for (final json in res.data['details'] ?? []) {
          list.add(EventV2Model.fromJson(json));
        }
      }

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<CalendarEventCount>>> calendar({
    required int month,
    required int year,
    int? companyId,
  }) async {
    try {
      final res = await _dio.get(
        '${Api.calendarEvent}?month=$month&year=$year&workspace=$companyId',
      );
      final List<CalendarEventCount> list = [];
      for (final json in res.data['details'] ?? []) {
        final date = DateTime.tryParse(json['day']);
        if (date != null) {
          list.add(
            CalendarEventCount(
              date: date,
              count: int.tryParse(json['count'].toString()) ?? 0,
            ),
          );
        }
      }

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<DetailEventV2Model>> detail(int id) async {
    try {
      final res = await _dio.get(
        '${Api.detailEvent}$id',
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: res.data['details'] != null
            ? DetailEventV2Model.fromJson(res.data['details'])
            : null,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<AppointmentScheduleModel>> detailV2(int id) async {
    try {
      final res = await _dio.get(
        '${Api.detailEventV2}$id',
      );
      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: res.data['data'] != null
            ? AppointmentScheduleModel.fromJson(res.data['data'][0])
            : null,
      );
    } catch (e) {
      log('--- detailV2: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> remove(int id) async {
    try {
      final res = await _dio.delete(
        '${Api.detailEvent}$id',
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> cancel(int id, String reason) async {
    try {
      final res = await _dio.post(
        '${Api.cancelEvent}$id',
        data: {'reason': reason},
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> updateStatus(int id, String status) async {
    try {
      final res = await _dio.put(
        '${Api.updateStatus}$id',
        data: {'status': status},
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> reminderZalo(int id) async {
    try {
      final res = await _dio.post(
        '${Api.reminderZalo}$id',
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> reSendEventZalo(int id) async {
    try {
      final res = await _dio.post(
        '${Api.reSendEventZalo}$id',
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
