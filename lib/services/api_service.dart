import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/user_profile.dart';
import 'dart:developer' as developer;

// Modelo para la respuesta del login
class LoginResponse {
  final String token;
  final String userId;

  LoginResponse({required this.token, required this.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      userId: json['userId'].toString(),
    );
  }
}

class ApiService {
  final String _baseUrl = 'https://apiautentificacion.onrender.com/api';

  // --- Inicio de Sesión ---
  Future<LoginResponse?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return LoginResponse.fromJson(json.decode(decodedBody));
      } else {
        developer.log('Error en el login: ${response.statusCode} - ${response.body}', name: 'ApiService.login');
        return null;
      }
    } catch (e, s) {
      developer.log('Excepción en el login', error: e, stackTrace: s, name: 'ApiService.login');
      return null;
    }
  }

  // --- Registro de Usuario ---
  Future<bool> register(String email, String password, int idRol, bool estaActivo) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/usuarios'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'idRol': idRol,
          'estaActivo': estaActivo,
        }),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        developer.log('Error en el registro: ${response.statusCode} - ${response.body}', name: 'ApiService.register');
        return false;
      }
    } catch (e, s) {
      developer.log('Excepción en el registro', error: e, stackTrace: s, name: 'ApiService.register');
      return false;
    }
  }

  // --- Perfil de Usuario (CORREGIDO) ---
  Future<UserProfile?> getUserProfile(String userId, {String? token}) async {
    try {
      final headers = {'Content-Type': 'application/json; charset=UTF-8'};
      if (token != null) {
        // CORRECCIÓN: Usar el encabezado de autorización Bearer
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/perfiles/usuario/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(decodedBody) as Map<String, dynamic>;
        return UserProfile.fromJson(jsonData);
      } else {
        developer.log('Error al obtener el perfil: ${response.statusCode} - ${response.body}', name: 'ApiService.getUserProfile');
        return null;
      }
    } catch (e, s) {
      developer.log('Excepción al obtener el perfil', error: e, stackTrace: s, name: 'ApiService.getUserProfile');
      return null;
    }
  }
  
  // --- OBTENER PERFILES PÚBLICOS (CORREGIDO) ---
  Future<List<Map<String, dynamic>>> getPublicProfiles({String? token}) async {
    final url = Uri.parse('$_baseUrl/perfiles/publicos');
    try {
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        // CORRECCIÓN: Usar el encabezado de autorización Bearer
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> userList = json.decode(decodedBody);
        return userList.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Falla de la API al cargar perfiles: [${response.statusCode}] ${response.body}');
      }
    } catch (e, s) {
      developer.log('Excepción al obtener perfiles públicos', error: e, stackTrace: s, name: 'ApiService.getPublicProfiles');
      throw Exception('Error de conexión o de formato de respuesta del servidor.');
    }
  }
}
