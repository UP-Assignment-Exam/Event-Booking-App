import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _emailKey = 'saved_email';
  static const String _passwordKey = 'saved_password';
  
  late SharedPreferences _prefs;
  
  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Token management
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }
  
  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }
  
  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }
  
  // User data management
  Future<void> saveUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }
  
  Future<UserModel?> getUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      final userMap = json.decode(userJson);
      return UserModel.fromJson(userMap);
    }
    return null;
  }
  
  Future<void> removeUser() async {
    await _prefs.remove(_userKey);
  }
  
  // Remember me credentials
  Future<void> saveCredentials(String email, String password) async {
    await _prefs.setString(_emailKey, email);
    await _prefs.setString(_passwordKey, password);
  }
  
  Future<Map<String, String>?> getSavedCredentials() async {
    final email = _prefs.getString(_emailKey);
    final password = _prefs.getString(_passwordKey);
    
    if (email != null && password != null) {
      return {
        'email': email,
        'password': password,
      };
    }
    return null;
  }
  
  Future<void> removeCredentials() async {
    await _prefs.remove(_emailKey);
    await _prefs.remove(_passwordKey);
  }
  
  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}