import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static Future<void> setFcmToken(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcmToken', token);
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  static Future<String?> getFcmToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('fcmToken');
    } catch (e) {
      print('Error retrieving FCM token: $e');
      return null;
    }
  }
}
