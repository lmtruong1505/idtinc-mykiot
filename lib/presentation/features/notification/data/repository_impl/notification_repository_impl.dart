import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/notification/domain/repositories/notification_repository.dart';
import 'package:pharmago/presentation/features/notification/data/models/notification_model.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl extends NotificationRepository {
  NotificationRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<List<NotificationModel>>> getList({
    required int company,
    String? search,
    String? type,
    int? page,
    int? limit,
  }) async {
    try {
      final data = {
        'company': company,
        'search': search,
        'type': type,
        'page': page,
        'limit': limit,
      };
      final res = await _dio.get('${Api.notification}/manage', data: data);
      final List<NotificationModel> list = [];
      if (res.data['details'] is List) {
        list.addAll(
          (res.data['details'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList(),
        );
      }
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: list,
        extra: res.data['count_not_seen'] ?? 0,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<NotificationModel>> getDetail({
    required int id,
  }) async {
    try {
      final res = await _dio.get('${Api.notification}detail/$id');
      final data = NotificationModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
        extra: res.data['count_not_seen'],
      );
    } on DioException catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.message,
      );
    }
  }
}
