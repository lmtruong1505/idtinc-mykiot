import 'dart:convert';

import 'package:pharmago/data/apis/hive_key.dart';
import 'package:pharmago/data/config/hive.dart';

import '../../../di/di.dart';

class CompanyHelper {
  static void setViettelInvoiceAccount({
    required String username,
    required String password,
    required int workspaceId,
  }) {
    final data = {
      'username': username,
      'password': password,
    };
    getIt.get<HiveHelper>().instance.put(
          '${HiveKey.viettelAccount}_$workspaceId',
          jsonEncode(data),
        );
  }

  static Map<String, dynamic>? viettelInvoiceAccount(int workspaceId) {
    final data = getIt
        .get<HiveHelper>()
        .instance
        .get('${HiveKey.viettelAccount}_$workspaceId');
    return data == null ? null : jsonDecode(data);
  }
}
