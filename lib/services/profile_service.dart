import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/services/auth_service.dart';

class ProfileService {
  final String _baseUrl = 'https://apiautentificacion.onrender.com/api';

  Future<List<Map<String, dynamic>>> getPublicProfiles() async {
    var token = AuthService.token;

    // Si el token no está en memoria (p. ej. después de un hot reload), intenta cargarlo.
    if (token == null) {
      print('Token no encontrado en memoria, intentando recargar desde almacenamiento...');
      await AuthService.tryLoadToken();
      token = AuthService.token;
    }

    if (token == null) {
      print('Error: Token de autenticación no encontrado después de intentar recargar.');
      throw Exception('Usuario no autenticado.');
    }

    final String url = '$_baseUrl/perfiles/publicos';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> profilesJson = jsonDecode(utf8.decode(response.bodyBytes));
        return profilesJson.cast<Map<String, dynamic>>();
      } else {
        print('Error al obtener perfiles - Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('No se pudieron cargar los perfiles.');
      }
    } catch (e) {
      print('Excepción al obtener perfiles: $e');
      throw Exception('Ocurrió un error inesperado.');
    }
  }
}
