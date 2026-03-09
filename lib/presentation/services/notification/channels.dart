
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ChannelsDefault {
  static const AndroidNotificationChannel channel_1 =
      AndroidNotificationChannel(
    'com.idtinc.pharmago.urgent', 'High Importance Notifications',
    description:
        'This channel is used for important notifications.',
    importance: Importance.max,
  );
}