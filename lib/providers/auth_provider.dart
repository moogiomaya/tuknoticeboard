import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/local_storage.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  final ApiService _api = ApiService();

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.login(email, password);
      // Assume response contains: { token, user: { ... } }
      final token = response['token'] ?? '';
      final userData = response['user'] ?? {};

      if (token.isNotEmpty) {
        await _api.setToken(token);
        await LocalStorage.saveToken(token);
        _user = User.fromJson(userData);
        await LocalStorage.saveUser(userData);
      } else {
        _error = 'Invalid credentials';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _api.clearToken();
    await LocalStorage.clearAll();
    _user = null;
    notifyListeners();
  }

  Future<void> loadUserFromStorage() async {
    final token = await LocalStorage.getToken();
    if (token == null) return;

    final userData = await LocalStorage.getUser();
    if (userData != null) {
      _user = User.fromJson(userData);
      // Optionally, refresh user data from API
    }
    notifyListeners();
  }
}