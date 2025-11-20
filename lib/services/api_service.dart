import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/user_profile.dart';
import 'dart:developer' as developer;

class LoginResponse {
  final String token;
  final int userId;

  LoginResponse({required this.token, required this.userId});

  // **FÁBRICA CORREGIDA PARA COINCIDIR CON LA API REAL**
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Verificamos que la respuesta contenga las claves correctas: 'token' y 'userId'.
    if (json.containsKey('token') && json.containsKey('userId')) {
      return LoginResponse(
        token: json['token'] as String,
        // Leemos el 'userId' directamente del JSON.
        userId: json['userId'] as int,
      );
    } else {
      // Si las claves no existen, el formato sigue siendo incorrecto.
      throw FormatException('La respuesta JSON no contiene "token" o "userId". Respuesta recibida: $json');
    }
  }
}

class ApiService {
  final String _baseUrl = 'https://apiautentificacion.onrender.com/api';

  Future<LoginResponse?> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    final body = jsonEncode({'email': email, 'password': password});

    developer.log('--- INICIANDO PETICIÓN DE LOGIN ---', name: 'ApiService.login');
    developer.log('URL Destino: $url', name: 'ApiService.login');
    developer.log('Cuerpo (Body) Enviado: $body', name: 'ApiService.login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body,
      );
      
      final decodedBody = utf8.decode(response.bodyBytes);
      developer.log('Respuesta del Servidor (Status: ${response.statusCode}): $decodedBody', name: 'ApiService.login');

      if (response.statusCode == 200) {
        final jsonData = json.decode(decodedBody);
        // Ahora, esta llamada funcionará correctamente con la respuesta de la API.
        return LoginResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e, s) {
      developer.log('!!! EXCEPCIÓN en el login !!!', error: e, stackTrace: s, name: 'ApiService.login');
      return null;
    }
  }

  // --- Registro de Usuario ---
  Future<Map<String, dynamic>?> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/usuarios'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'idRol': 2, 
          'estaActivo': true,
        }),
      );
      if (response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return json.decode(decodedBody) as Map<String, dynamic>;
      } else {
        developer.log('Error en el registro: ${response.statusCode} - ${response.body}', name: 'ApiService.register');
        return null;
      }
    } catch (e, s) {
      developer.log('Excepción en el registro', error: e, stackTrace: s, name: 'ApiService.register');
      return null;
    }
  }

  // --- Crear Perfil de Usuario ---
  Future<bool> createProfile(Map<String, dynamic> profileData, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/perfiles'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profileData),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        developer.log('Error al crear el perfil: ${response.statusCode} - ${response.body}', name: 'ApiService.createProfile');
        return false;
      }
    } catch (e, s) {
      developer.log('Excepción al crear el perfil', error: e, stackTrace: s, name: 'ApiService.createProfile');
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
        developer.log('Error al obtener el perfil: ${response.statusCode} - ${response.body}', name: 'ApiService.getUserProfile');
        return null;
      }
    } catch (e, s) {
      developer.log('Excepción al obtener el perfil', error: e, stackTrace: s, name: 'ApiService.getUserProfile');
      return null;
    }
  }
  
  // --- Obtener Perfiles Públicos ---
  Future<List<Map<String, dynamic>>> getPublicProfiles({String? token}) async {
    final url = Uri.parse('$_baseUrl/perfiles/publicos');
    try {
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
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
