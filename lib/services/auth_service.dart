import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'https://fictional-capybara-r4wq95jwj95xh59xv-8080.app.github.dev/api';

  // Función para REGISTRAR un nuevo usuario
  Future<bool> register(String email, String password, int idRol, bool estaActivo) async {
    final String url = '$_baseUrl/auth/registrar'; // <-- CORREGIDO: Endpoint de registro

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'contrasena': password,
          'idRol': idRol,
          'estaActivo': estaActivo,
        }),
      );

      if (response.statusCode == 201) {
        print('Registro exitoso: ${response.body}');
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

  // Función para INICIAR SESIÓN
  Future<bool> login(String email, String password) async {
    final String url = '$_baseUrl/auth/login'; // <-- NUEVO: Endpoint de login

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'contrasena': password, // Solo los campos necesarios para login
        }),
      );

      if (response.statusCode == 200) {
        print('Login exitoso: ${response.body}');
        // Aquí deberías guardar el token de sesión que devuelva la API
        return true;
      } else {
        print('Error en el login: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Excepción en el login: $e');
      return false;
    }
  }
}
