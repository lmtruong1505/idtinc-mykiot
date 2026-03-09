import 'package:injectable/injectable.dart';

import '../../../../../data/mapper/base/data_mapper.dart';
import '../../domain/entities/notification_entity.dart';
import '../models/notification_model.dart';

@injectable
class NotificationMapper
    extends BaseDataMapper<NotificationModel, NotificationEntity> {
  @override
  NotificationEntity mapToEntity(NotificationModel? data) {

    late TypeNoti type;

    switch (data?.type) {
      case 'ORDER_HUB':
        type = TypeNoti.order;
        break;
      case 'SERVICE':
        type = TypeNoti.service;
        break;
      case 'APPOINTMENT':
        type = TypeNoti.appointment;
        break;
      case 'SYSTEM':
        type = TypeNoti.system;
        break;
      default:
        type = TypeNoti.service;
    }

    return NotificationEntity(
      id: data?.id,
      type: type,
      topic: data?.topic,
      title: data?.title,
      content: data?.content,
      data: data?.data,
      company: data?.company,
      createdAt: data?.createdAt,
      isRead: data?.isRead ?? false,
      canAccess: data?.canAccess ?? false,
    );
  }
}
