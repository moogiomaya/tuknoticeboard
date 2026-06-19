import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notice.dart';
import '../models/category.dart';

class LocalStorage {
  static const String _noticeBox = 'notices';
  static const String _categoryBox = 'categories';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  static Future<void> init() async {
    await Hive.initFlutter();
    // Register adapters if you use custom objects (but we'll store JSON strings)
  }

  // Token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // User data
  static Future<void> saveUser(Map<String, dynamic> userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userJson));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);
    if (userStr != null) {
      return jsonDecode(userStr);
    }
    return null;
  }

  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Notices – store as list of JSON strings
  static Future<void> cacheNotices(List<Notice> notices) async {
    final box = await Hive.openBox(_noticeBox);
    await box.clear();
    for (var notice in notices) {
      await box.add(jsonEncode(notice.toJson()));
    }
  }

  static Future<List<Notice>> getCachedNotices() async {
    final box = await Hive.openBox(_noticeBox);
    List<Notice> notices = [];
    for (var key in box.keys) {
      final jsonStr = box.get(key) as String;
      final map = jsonDecode(jsonStr);
      notices.add(Notice.fromJson(map));
    }
    return notices;
  }

  // Categories similarly
  static Future<void> cacheCategories(List<Category> categories) async {
    final box = await Hive.openBox(_categoryBox);
    await box.clear();
    for (var cat in categories) {
      await box.add(jsonEncode(cat.toJson()));
    }
  }

  static Future<List<Category>> getCachedCategories() async {
    final box = await Hive.openBox(_categoryBox);
    List<Category> categories = [];
    for (var key in box.keys) {
      final jsonStr = box.get(key) as String;
      final map = jsonDecode(jsonStr);
      categories.add(Category.fromJson(map));
    }
    return categories;
  }

  // Clear all local data (logout)
  static Future<void> clearAll() async {
    await removeToken();
    await removeUser();
    final noticeBox = await Hive.openBox(_noticeBox);
    await noticeBox.clear();
    final catBox = await Hive.openBox(_categoryBox);
    await catBox.clear();
  }
}