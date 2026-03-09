import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmago/data/apis/hive_key.dart';

@singleton
class HiveHelper {
  Box? _instance;

  Box get instance {
    return _instance!;
  }

  Future<void> init() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    _instance = await Hive.openBox(HiveKey.mainBox);
  }

  Future<void> putData(String key, dynamic value) async {
    await instance.put(key, value);
  }

  dynamic getData(String key) {
    return instance.get(key);
  }

  Future<void> deleteData(String key) async {
    await instance.delete(key);
  }

  String getString(String key, String defaultValue) =>
      (getData(key) ?? defaultValue) as String;

  int getInt(String key, int defaultValue) =>
      (getData(key) ?? defaultValue) as int;

  bool getBool(String key, bool defaultValue) =>
      (getData(key) ?? defaultValue) as bool;

  double getDouble(String key, double defaultValue) =>
      (getData(key) ?? defaultValue) as double;
}
