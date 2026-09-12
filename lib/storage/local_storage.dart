import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String tokenKey = 'auth_token';
  static const String usernameKey = 'current_username';
  static const String userIdKey = 'current_user_id';
  static const String cartKeyPrefix = 'cart_';

  // ---------- Auth ----------
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // ---------- Username ----------
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(usernameKey, username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

  // ---------- User ID ----------
  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userIdKey, userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userIdKey);
  }

  // ---------- Per-user Cart ----------
  static Future<void> saveCart(String username, String cartJson) async {
    if (username.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$cartKeyPrefix$username', cartJson);
  }

  static Future<String?> getCart(String username) async {
    if (username.isEmpty) return null;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$cartKeyPrefix$username');
  }

  static Future<void> removeCart(String username) async {
    if (username.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$cartKeyPrefix$username');
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(usernameKey);
    await prefs.remove(userIdKey);
  }
}