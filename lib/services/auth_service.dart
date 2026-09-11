import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<UserModel> login(String username, String password) async {
    final response = await _apiService.post(
      '/auth/login',
      body: {'username': username, 'password': password},
    );

    return UserModel.fromJson(response);
  }
}
