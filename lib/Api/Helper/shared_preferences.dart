// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferenceHelper {
//   // Keys
//   static const String keyUserName = "user_name";
//   static const String keyUserId = "user_id";
//   static const String keyIsLoggedIn = "is_logged_in";

//   // Setters
//   static Future<void> setUserName(String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(keyUserName, value);
//   }

//   static Future<void> setUserId(int value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(keyUserId, value);
//   }

//   static Future<void> setLoggedIn(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(keyIsLoggedIn, value);
//   }

//   // Getters
//   static Future<String?> getUserName() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(keyUserName);
//   }

//   static Future<int?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt(keyUserId);
//   }

//   static Future<bool> isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(keyIsLoggedIn) ?? false;
//   }

//   // Clear all preferences
//   static Future<void> clearAll() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }

//   // Remove specific key
//   static Future<void> removeKey(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(key);
//   }
// }
