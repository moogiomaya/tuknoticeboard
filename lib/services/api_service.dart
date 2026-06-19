import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _token;

  Future<void> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api', // Change to your Laravel API URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Load token from shared_preferences
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_token';
    }

    // Interceptor to handle token expiration (optional)
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired – clear storage and force logout
          await clearToken();
          // You can emit a logout event here using a provider
        }
        return handler.next(error);
      },
    ));
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  // Store token after login
  Future<void> setToken(String token) async {
    _token = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Clear token on logout
  Future<void> clearToken() async {
    _token = null;
    _dio.options.headers.remove('Authorization');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Get all published notices (for students/staff)
  Future<List<dynamic>> getNotices() async {
    try {
      final response = await _dio.get('/notices');
      return response.data['data'] ?? [];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load notices');
    }
  }

  // Get a single notice by ID
  Future<Map<String, dynamic>> getNotice(int id) async {
    try {
      final response = await _dio.get('/notices/$id');
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load notice');
    }
  }

  // Optional: mark notice as read (you could have an endpoint)
  // Future<void> markAsRead(int noticeId) async { ... }

  // Get user profile (optional)
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/user');
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load profile');
    }
  }
}