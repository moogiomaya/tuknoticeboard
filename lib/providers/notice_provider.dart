import 'package:flutter/material.dart';
import '../models/notice.dart';
import '../services/api_service.dart';
import '../services/local_storage.dart';

class NoticeProvider extends ChangeNotifier {
  List<Notice> _notices = [];
  bool _isLoading = false;
  String? _error;

  List<Notice> get notices => _notices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiService _api = ApiService();

  Future<void> fetchNotices({bool refresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.getNotices();
      final List<Notice> fetched = data.map((json) => Notice.fromJson(json)).toList();
      _notices = fetched;
      // Cache locally
      await LocalStorage.cacheNotices(fetched);
    } catch (e) {
      _error = e.toString();
      // Fallback to cache if network fails
      final cached = await LocalStorage.getCachedNotices();
      if (cached.isNotEmpty) {
        _notices = cached;
        _error = null; // Clear error, but maybe show a snackbar
      } else {
        _error = 'Failed to load notices, please check your internet connection.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // For pull-to-refresh
  Future<void> refreshNotices() => fetchNotices(refresh: true);
}