import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String tokenKey = 'auth_token';
  static const String cartKey = 'cart_items';

  // Authentication token

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

  // Cart

  static Future<void> saveCart(String cart) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(cartKey, cart);
  }

  static Future<String?> getCart() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(cartKey);
  }

  static Future<void> removeCart() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(cartKey);
  }
}
