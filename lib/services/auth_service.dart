import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/services/api_service.dart';
import 'dart:developer' as developer;

class LoginResult {
  final bool success;
  final String? redirectPath;

  LoginResult({required this.success, this.redirectPath});
}

class AuthService with ChangeNotifier {
  final ApiService _apiService = ApiService();

  String? _token;
  String? _userId;
  bool _isLoggedIn = false;
  bool? _profileExists;

  String? get token => _token;
  String? get userId => _userId;
  bool get isLoggedIn => _isLoggedIn;
  bool? get profileExists => _profileExists;

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  AuthService() {
    tryLoadSession();
  }

  Future<void> tryLoadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    _userId = prefs.getString(_userIdKey);

    if (_token != null && _userId != null) {
      _isLoggedIn = true;
      notifyListeners();
      await checkUserProfile();
    } else {
      _isLoggedIn = false;
    }
  }

  Future<void> checkUserProfile() async {
    if (!_isLoggedIn || _userId == null) {
      _profileExists = false;
      notifyListeners();
      return;
    }

    _profileExists = null;
    notifyListeners();

    try {
      final profiles = await _apiService.getPublicProfiles(token: _token);
      final profile = profiles.firstWhere((p) => p['usuarioId'].toString() == _userId, orElse: () => {});
      _profileExists = profile.isNotEmpty;
    } catch (e) {
      _profileExists = false;
    }
    notifyListeners();
  }

  Future<LoginResult> registerAndLogin(String email, String password) async {
    try {
      final registrationResponse = await _apiService.register(email, password);
      if (registrationResponse == null) {
        developer.log('El registro en la API falló.', name: 'AuthService');
        return LoginResult(success: false);
      }
      
      developer.log('Registro exitoso. Procediendo a login automático.', name: 'AuthService');
      return await login(email, password);

    } catch (e) {
      developer.log('Excepción durante el proceso de registro y login.', error: e, name: 'AuthService');
      return LoginResult(success: false);
    }
  }

  Future<LoginResult> login(String email, String password) async {
    try {
      final loginResponse = await _apiService.login(email, password);

      if (loginResponse == null) {
        return LoginResult(success: false);
      }

      _token = loginResponse.token;
      _userId = loginResponse.userId.toString();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, _token!);
      await prefs.setString(_userIdKey, _userId!); 

      _isLoggedIn = true;
      notifyListeners();
      
      await checkUserProfile();

      return LoginResult(success: true, redirectPath: '/home');

    } catch (e) {
      return LoginResult(success: false);
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _isLoggedIn = false;
    _profileExists = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);

    notifyListeners();
  }
}
