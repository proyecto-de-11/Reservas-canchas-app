import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'https://fictional-capybara-r4wq95jwj95xh59xv-8080.app.github.dev/api';

  Future<bool> register(String email, String password, int idRol, bool estaActivo) async {
    final String url = '$_baseUrl/auth/registrar';
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
      return response.statusCode == 201;
    } catch (e) {
      print('Excepción en el registro: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final String url = '$_baseUrl/auth/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Extraer el rol como una cadena de texto, según la imagen de la API
        final String? roleString = data['rol'];

        if (roleString != null) {
          int roleId;
          // Mapear el string del rol a un ID numérico
          switch (roleString) {
            case 'Propietario':
              roleId = 1;
              break;
            case 'Usuario':
              roleId = 2;
              break;
            case 'Admin':
              roleId = 3;
              break;
            default:
              return {'success': false, 'message': 'Rol desconocido recibido de la API.'};
          }
          return {'success': true, 'role': roleId};
        } else {
          return {'success': false, 'message': 'Respuesta de API inválida, no se encontró el rol.'};
        }
      } else {
        final errorData = jsonDecode(response.body);
        return {'success': false, 'message': errorData['message'] ?? 'Credenciales incorrectas.'};
      }
    } catch (e) {
      print('Excepción en el login: $e');
      return {'success': false, 'message': 'No se pudo conectar al servidor.'};
    }
  }
}
