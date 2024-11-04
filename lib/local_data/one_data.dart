import 'package:shared_preferences/shared_preferences.dart';
final SharedPreferencesAsync mySharedPrefs = SharedPreferencesAsync();
class MySharedPreferences {
   static saveID(String action) async {
    await mySharedPrefs.setString('action', action);
  }

  static Future<String> readID() async  {
    final String? action = await mySharedPrefs.getString('action');
    return action ?? '';
  }
}
