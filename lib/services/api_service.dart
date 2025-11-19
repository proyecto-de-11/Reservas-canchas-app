import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/user_profile.dart';

// Modelo para la respuesta del login
class LoginResponse {
  final String token;
  final String userId;

  LoginResponse({required this.token, required this.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      userId: json['userId'].toString(), // o el campo que devuelva tu API
    );
  }
}

class ApiService {
  final String _baseUrl = 'https://apiautentificacion.onrender.com/api';

  // --- Inicio de Sesión ---
  Future<LoginResponse?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'), // Asumiendo este endpoint
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return LoginResponse.fromJson(json.decode(decodedBody));
      } else {
        print('Error en el login: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Excepción en el login: $e');
      return null;
    }
  }

  // --- Registro de Usuario ---
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/usuarios'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'nombre': name,
          'email': email,
          'password': password, // La API debe encargarse de hashear esto
          // Asumiendo que el rol se asigna por defecto en el backend
        }),
      );
      // Un código 201 (Created) indica éxito
      if (response.statusCode == 201) {
        return true;
      } else {
        print('Error en el registro: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Excepción en el registro: $e');
      return false;
    }
  }

  // --- Perfil de Usuario ---
  Future<UserProfile?> getUserProfile(String userId, {String? token}) async {
    try {
      final headers = {'Content-Type': 'application/json; charset=UTF-8'};
      if (token != null) {
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
        print('Error al obtener el perfil: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción al obtener el perfil: $e');
      return null;
    }
  }
}
