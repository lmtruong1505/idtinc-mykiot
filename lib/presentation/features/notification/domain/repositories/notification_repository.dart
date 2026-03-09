
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/notification/data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<BaseResponseModel<List<NotificationModel>>> getList({
    required int company,
    String? search,
    String? type,
    int? page,
    int? limit,
  });

  Future<BaseResponseModel<NotificationModel>> getDetail({
    required int id,
  });
}
