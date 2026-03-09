import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'data/config/hive.dart';
import 'initializer/app_initializer.dart';
import 'presentation/app/my_app.dart';
import 'presentation/config/app_config.dart';
import 'presentation/di/di.dart';
import 'shared/constants/storage/shared_preference.dart';
import 'shared/utils/log_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AppSharedPreference.instance.initSharedPreferences();
  await AppInitializer(AppConfig.getInstance()).init();
  await runZonedGuarded(_runMyApp, _reportError);
  await getIt.get<HiveHelper>().init();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _runMyApp() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

void _reportError(Object error, StackTrace stackTrace) {
  Log.e(error, stackTrace: stackTrace, name: 'Uncaught exception');

  // report by Firebase Crashlytics here
}
