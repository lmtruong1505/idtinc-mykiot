import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import '../../../shared/components/button/main_button.dart';
import '../../base/button.dart';
import 'channels.dart';

class LocalNotificationsPlugin {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
}

class NotiService {
  NotiService._internal();
  static final NotiService instance = NotiService._internal();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> firebaseMessagingBackroundHandler(
    RemoteMessage message,
  ) async {
    // await Firebase.initializeApp();
    // await showLocalNoti(
    //   localNotificationsPlugin.flutterLocalNotificationsPlugin,
    //   message,
    // );
  }

  void initLocalNotification(BuildContext context) async {
    const androidInitialize =
        AndroidInitializationSettings('mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: DarwinInitializationSettings(),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        print('================onDidReceiveNotificationResponse');

        if (payload.payload != null) {
          final res = jsonDecode(payload.payload!);
          print(res);
          context.router.push(const NotificationListRoute());
        }
      },
    );
  }

  void firebaseInit(BuildContext context) {
    // Ứng dụng chạy fogreground -> show local notification
    FirebaseMessaging.onMessage.listen((message) {
      print('===============onMessage.listen');
      print(message.data);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin: const EdgeInsets.all(12),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 10),
          content: Column(
            children: [
              Text(
                message.notification?.title ?? '',
                style: p5.copyWith(color: whiteColor),
              ),
              4.height,
              Text(
                message.notification?.body ?? '',
                style: p6.copyWith(color: greyColor),
              ),
              8.height,
              Row(
                children: [
                  Expanded(
                    child: SupportButton(
                      title: 'Từ chối',
                      event: () {},
                      largeButton: false,
                      icon: null,
                      backgroundColor: whiteColor,
                    ),
                  ),
                  8.width,
                  Expanded(
                    child: MainButton(
                      title: 'Nhận đơn',
                      largeButton: false,
                      radius: 8,
                      event: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      showNotification(message);
    });

    // Ứng dụng chạy background -> click noti sẽ thực hiện event này
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('===============onMessageOpenedApp');
      if (kDebugMode) {
        final res = message.data;
        final userId = res['user_id'];
        final workspace = res['workspace'];
        final oa = res['oa_id'];
        if (userId != null && workspace != null && oa != null) {
          // context.router.push(MessageRoute(id: int.parse(userId)));
        }
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    // final AndroidNotification? android = message.notification?.android;
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      ChannelsDefault.channel_1.id,
      ChannelsDefault.channel_1.name,
      importance: ChannelsDefault.channel_1.importance,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'ic_launcher',
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    await _flutterLocalNotificationsPlugin.show(
      0,
      notification?.title.toString(),
      notification?.body.toString(),
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }
}

class FirebaseMessageConfig {
  final notificationSettings = FirebaseMessaging.instance;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification(BuildContext context) async {
    try {
      notificationSettings.requestPermission();
      final deviceToken = await notificationSettings.getToken();
      if (deviceToken != null) {
        if (kDebugMode) {
          print('=====deviceToke=====$deviceToken');
        }
        initPushNotification(context);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    print('===============onMessageOpenedApp');
  }

  Future initPushNotification(BuildContext context) async {
    try {
      await notificationSettings.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (notificationSettings.isAutoInitEnabled) {
        print('User granted permission');
      } else {
        print('User declined or has not accepted permission');
      }
      initLocalNotifications(context);

      // notificationSettings.getInitialMessage().then(handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
      FirebaseMessaging.onMessage.listen((message) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            margin: const EdgeInsets.all(12),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 10),
            content: Column(
              children: [
                Text(
                  message.notification?.title ?? '',
                  style: p5.copyWith(color: whiteColor),
                ),
                4.height,
                Text(
                  message.notification?.body ?? '',
                  style: p6.copyWith(color: greyColor),
                ),
                8.height,
                Row(
                  children: [
                    Expanded(
                      child: SupportButton(
                        title: 'Từ chối',
                        event: () {},
                        largeButton: false,
                        icon: null,
                        backgroundColor: whiteColor,
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: MainButton(
                        title: 'Nhận đơn',
                        largeButton: false,
                        radius: 8,
                        event: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        final RemoteNotification? notification = message.notification;
        if (notification == null) {
          return;
        }
        _showNotification(message);
      });
    } catch (e) {
      print('=======FirebaseMessaging error');
    }
  }

  Future initLocalNotifications(BuildContext context) async {
    try {
      const iOS = DarwinInitializationSettings();
      const android = AndroidInitializationSettings('@drawable/ic_launcher');
      const settings = InitializationSettings(iOS: iOS, android: android);
      await flutterLocalNotificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (details) {
          if (details.payload != null) {
            print('================onDidReceiveNotificationResponse');

            if (details.payload != null) {
              final res = jsonDecode(details.payload!);
              print(res);
              context.router.push(const NotificationListRoute());
            }
          } else {
            debugPrint('notification payload');
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('==========initLocalNotifications Error');
      }
    }
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    _showNotification(message);
  }

  void _showNotification(RemoteMessage message) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        ongoing: true,
      );

      const platformDetails = NotificationDetails(android: androidDetails);
      print('===============ShowhandleBackgroundMessage');
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformDetails,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      print('===============ShowError Noti Error');
    }
  }
}
