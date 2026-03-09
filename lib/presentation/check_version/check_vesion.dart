import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:upgrader/upgrader.dart';

import 'update_app_dialog.dart';

class CheckVersion {
  static checkAndPush(BuildContext context) {
    check(
      ios: 'com.idtinc.pharmagoStore',
      android: 'com.idtinc.pharmago',
    ).then(
      (value) {
        if (value.isUpdate) {
          Future.delayed(100.milliseconds).then(
            (val) {
              context.dialog(
                UpdateAppDialog(
                  version: value,
                ),
                barrierDismissible: false,
              );
            },
          );
        }
      },
    );
  }

  static Future<ModelVersion> check({
    required String ios,
    required String android,
  }) async {
    final versionData = ModelVersion(
      isUpdate: false,
    );
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final notes = await getIt<BaseDio>().checkVersion();
      versionData.notes = notes;

      final String localVersion = packageInfo.version;
      //const String localVersion = '1.0.0';
      final String buildNumber = packageInfo.buildNumber;

      versionData.buildNumber = buildNumber;
      versionData.localVersion = localVersion;

      final List<String> numbers = localVersion.split('.');

      if (Platform.isAndroid) {
        final ModelVersion? modelVersion =
            await _getAndroidStoreVersion(android);

        final storeVersion = modelVersion?.version ?? '1.0.0';
        final List<String> storeNumbers = storeVersion.split('.');

        final bool isStore = _checkList(
          list1: storeNumbers,
          list2: numbers,
        );

        versionData.isUpdate = isStore;
        versionData.url = modelVersion?.url;
        versionData.version = storeVersion;

        return versionData;
      }
      if (Platform.isIOS) {
        final ModelVersion? ios1 = await _getIosStoreVersion(ios);
        final ModelVersion? ios2 = await _getIosStoreVersion2(ios);

        final String iosVer1 = ios1?.version ?? '1.0.0';
        final String iosVer2 = ios2?.version ?? '1.0.0';

        final List<String> storeNumbers1 = iosVer1.split('.');
        final List<String> storeNumbers2 = iosVer2.split('.');

        final bool isStore1 = _checkList(
          list1: storeNumbers1,
          list2: storeNumbers2,
        );
        if (isStore1) {
          final bool isStore = _checkList(
            list1: storeNumbers1,
            list2: numbers,
          );
          versionData.isUpdate = isStore;
          versionData.url = ios1?.url;
          versionData.version = iosVer1;

          return versionData;
        } else {
          final bool isStore = _checkList(
            list1: storeNumbers2,
            list2: numbers,
          );
          versionData.isUpdate = isStore;
          versionData.url = ios2?.url;
          versionData.version = iosVer2;

          return versionData;
        }
      }

      return versionData;
    } catch (e) {
      print('Check version error: $e');
      versionData.isUpdate = false;
      return versionData;
    }
  }

  static bool _checkList({
    required List<String> list1,
    required List<String> list2,
  }) {
    // kiểm tra xem version nào code hơn từ các số
    final bool isList1Length = list1.length > list2.length;

    final int length = isList1Length ? list1.length : list2.length;

    for (int i = 0; i < length; i++) {
      if (isList1Length && i == list2.length && int.parse(list1[i]) > 0) {
        return true;
      } else if (!isList1Length && i == list1.length) {
        return false;
      }

      if (int.parse(list1[i]) > int.parse(list2[i])) {
        return true;
      }
    }
    return false;
  }

  static Future<ModelVersion?> _getAndroidStoreVersion(String id) async {
    final url = 'https://play.google.com/store/apps/details?id=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return null;
    }
    final String? version =
        RegExp(r',\[\[\["([0-9,\.]*)"]],').firstMatch(response.body)!.group(1);
    return ModelVersion(url: url, version: version ?? '1.0.0');
  }

  static Future<ModelVersion?> _getIosStoreVersion(String id) async {
    final url = 'http://itunes.apple.com/vn/lookup?bundleId=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return null;
    }
    final jsonObj = json.decode(response.body);
    return ModelVersion(
      url: jsonObj['results'][0]['trackViewUrl'],
      version: jsonObj['results'][0]['version'],
    );
  }

  static Future<ModelVersion?> _getIosStoreVersion2(String id) async {
    final url = 'https://itunes.apple.com/vn/lookup?bundleId=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return null;
    }
    final jsonObj = json.decode(response.body);
    return ModelVersion(
      url: jsonObj['results'][0]['trackViewUrl'],
      version: jsonObj['results'][0]['version'],
    );
  }
}

class ModelVersion {
  String? url;
  String? version;
  String? localVersion;
  String? buildNumber;
  List<String>? notes;
  bool isUpdate;
  ModelVersion({
    this.url,
    this.version,
    this.localVersion,
    this.buildNumber,
    this.isUpdate = false,
    this.notes,
  });
}

class MyUpgraderMessages extends UpgraderMessages {
  @override
  String get languageCode => 'vi';

  @override
  String message(UpgraderMessage messageKey) {
    switch (messageKey) {
      case UpgraderMessage.body:
        return 'Có một phiên bản mới của ứng dụng này. Vui lòng cập nhật!';
      case UpgraderMessage.buttonTitleUpdate:
        return 'Cập nhật';
      case UpgraderMessage.prompt:
        return 'Bạn có muốn cập nhật ngay bây giờ không?';
      case UpgraderMessage.title:
        return 'Cập nhật ứng dụng';
      case UpgraderMessage.releaseNotes:
        return 'Ghi chú phiên bản';
      default:
        return super.message(messageKey)!;
    }
  }
}

class UpdateWidget extends StatelessWidget {
  const UpdateWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        // canDismissDialog: false,
        // showIgnore: false,
        // showLater: false,
        debugLogging: false,
        languageCode: 'vi',
        debugDisplayAlways: false,
        // showReleaseNotes: false,
        // messages: MyUpgraderMessages(),
      ),
      child: child,
    );
  }
}
