import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../storage/local_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(username, password);

      await LocalStorage.saveToken(user.accessToken);

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
