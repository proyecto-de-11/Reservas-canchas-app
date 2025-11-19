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

  // CORRECCIÓN FINAL: Mapeo de la estructura de datos plana de la API.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      // Asumimos que el ID principal del perfil es 'id' y el del usuario es 'usuarioId'.
      id: json['id']?.toString() ?? json['usuarioId']?.toString() ?? '',
      userId: json['usuarioId']?.toString() ?? '',
      fullName: json['nombreCompleto'] as String? ?? 'Nombre no disponible',
      email: json['email'] as String? ?? 'Email no disponible',
      country: json['pais'] as String?,
      city: json['ciudad'] as String?,
      bio: json['biografia'] as String?,
      profilePictureUrl: json['fotoPerfil'] as String?,
    );
  }
}
