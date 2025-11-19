import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class AuthService with ChangeNotifier {
  final String _baseUrl = 'https://apiautentificacion.onrender.com/api';
  String? _token;
  String? _userId;
  bool _isLoggedIn = false;

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  String? get token => _token;
  String? get userId => _userId;
  bool get isLoggedIn => _isLoggedIn;

  AuthService() {
    tryLoadSession();
  }

  Future<void> tryLoadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    _userId = prefs.getString(_userIdKey);

    if (_token != null && _userId != null) {
      _isLoggedIn = true;
      developer.log('Sesión cargada: userId $_userId', name: 'AuthService');
    } else {
      _isLoggedIn = false;
      developer.log('No se encontró sesión.', name: 'AuthService');
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final String url = '$_baseUrl/auth/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'password': password}), // REVERTIDO
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _userId = data['userId']?.toString(); // REVERTIDO

        if (_token == null || _userId == null) {
          return {'success': false, 'message': 'Respuesta inválida del servidor.'};
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, _token!);
        await prefs.setString(_userIdKey, _userId!); 

        _isLoggedIn = true;
        notifyListeners();
        developer.log('Login exitoso. userId: $_userId guardado.', name: 'AuthService');

        return {'success': true, 'role': data['rol']}; // REVERTIDO
      } else {
        final errorData = jsonDecode(response.body);
        developer.log('Error en el login: ${response.statusCode} - ${response.body}', name: 'AuthService.login');
        return {'success': false, 'message': errorData['message'] ?? 'Error desconocido.'}; // REVERTIDO
      }
    } catch (e, s) {
      developer.log('Excepción en el login', error: e, stackTrace: s, name: 'AuthService.login');
      return {'success': false, 'message': 'No se pudo conectar al servidor.'};
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);

    notifyListeners();
    developer.log('Sesión cerrada y datos limpiados.', name: 'AuthService');
  }

  Future<bool> register(String email, String password, int idRol, bool estaActivo) async {
    final String url = '$_baseUrl/auth/registrar'; // REVERTIDO
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'contrasena': password, // REVERTIDO
          'idRol': idRol,
          'estaActivo': estaActivo,
        }),
      );
      return response.statusCode == 201; // REVERTIDO
    } catch (e, s) {
      developer.log('Excepción en el registro: $e', stackTrace: s, name: 'AuthService.register');
      return false;
    }
  }
}
