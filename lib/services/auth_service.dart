import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'https://apiautentificacion.onrender.com/api';

  Future<bool> register(String email, String password, int idRol, bool estaActivo) async {
    final String url = '$_baseUrl/auth/registrar';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'contrasena': password, // El backend espera 'contrasena'
          'idRol': idRol,
          'estaActivo': estaActivo,
        }),
      );
      
      if (response.statusCode == 201) {
        return true;
      } else {
        print('Error en el registro - Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
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
        final String? roleString = data['rol'];

        if (roleString != null) {
            int roleId;
            switch (roleString.toLowerCase()) { // lo pongo en minúsculas para evitar errores de mayus/minusc
                case 'propietario':
                    roleId = 1;
                    break;
                case 'usuario':
                    roleId = 2;
                    break;
                case 'admin':
                    roleId = 3;
                    break;
                default:
                    return {'success': false, 'message': 'Rol desconocido: $roleString'};
            }
            return {'success': true, 'role': roleId, 'userId': data['userId'].toString()};
        } else {
            return {'success': false, 'message': 'Respuesta de API inválida, no se encontró el rol.'};
        }
    } else {
        try {
            final errorData = jsonDecode(response.body);
            return {'success': false, 'message': errorData['message'] ?? 'Error desconocido.'};
        } catch (e) {
            return {'success': false, 'message': 'Credenciales incorrectas o error del servidor.'};
        }
    }
} catch (e) {
      print('Excepción en el login: $e');
      return {'success': false, 'message': 'No se pudo conectar al servidor. Revisa tu conexión a internet.'};
    }
  }
}
