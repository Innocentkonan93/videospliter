import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // static Future<bool> putBool(
  //     {required String key, required bool value}) async {
  //   return await sharedPreferences.setBool(key, value);
  // }

  static Future<String> getString({required String key}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? '';
  }

  static int getInteger({required String key}) {
    return sharedPreferences.getInt(key) ?? 0;
  }

  static Future<bool> getBool({required String key}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(key) ?? false;
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    print("data saved $key: $value");
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else if (value is List) {
      return await sharedPreferences.setStringList(key, [...value]);
    } else {
      return await sharedPreferences.setDouble(key, value);
    }
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  static Future<void> removeDataList({required List<String> keys}) async {
    for (String key in keys) {
      await sharedPreferences.remove(key);
    }
  }

  static Future<bool> cleanAllData({required String key}) async {
    return await sharedPreferences.clear();
  }
}
