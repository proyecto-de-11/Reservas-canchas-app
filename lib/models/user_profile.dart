import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String? country;
  final String? city;
  final String? bio;
  final String? profilePictureUrl;

  const UserProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    this.country,
    this.city,
    this.bio,
    this.profilePictureUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // El endpoint /api/perfiles/usuario/{usuarioId} probablemente devuelve un objeto combinado
    // con datos del perfil y del usuario. Aquí asumimos una estructura plausible.
    return UserProfile(
      id: json['id'] as String,
      userId: json['usuario']?['id'] as String? ?? '', // Asumiendo que el objeto de usuario está anidado
      fullName: json['usuario']?['nombre'] as String? ?? 'Nombre no disponible',
      email: json['usuario']?['email'] as String? ?? 'Email no disponible',
      country: json['pais'] as String?,
      city: json['ciudad'] as String?,
      bio: json['bio'] as String?,
      profilePictureUrl: json['fotoPerfilUrl'] as String?,
    );
  }
}
