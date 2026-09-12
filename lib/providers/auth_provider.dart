import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../storage/local_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  int? get currentUserId => _currentUser?.id;
  String? get currentUsername => _currentUser?.username;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(username, password);

      await LocalStorage.saveToken(user.accessToken);
      await LocalStorage.saveUsername(username);
      await LocalStorage.saveUserId(user.id); // new

      _currentUser = user;
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await LocalStorage.clearAuth();
    _currentUser = null;
    notifyListeners();
  }

  // Optional: restore session on app start
  Future<void> tryRestoreSession() async {
    final token = await LocalStorage.getToken();
    final username = await LocalStorage.getUsername();
    final userId = await LocalStorage.getUserId();

    if (token != null && username != null && userId != null) {
      _currentUser = UserModel(
        id: userId,
        username: username,
        email: '',
        firstName: '',
        lastName: '',
        image: '',
        accessToken: token,
      );
      notifyListeners();
    }
  }
}