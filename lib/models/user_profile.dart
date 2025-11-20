import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String id;              // ID del perfil
  final String userId;          // ID del usuario
  final String email;
  final String fullName;
  final String? country;
  final String? city;
  final String? bio;
  final String? profilePictureUrl;
  final String? birthDate;
  final String? gender;
  final String? phone;
  final String? documentId;

  const UserProfile({
    required this.id,
    required this.userId,
    required this.email,
    required this.fullName,
    this.country,
    this.city,
    this.bio,
    this.profilePictureUrl,
    this.birthDate,
    this.gender,
    this.phone,
    this.documentId,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Extrae el objeto anidado 'usuario' o usa un mapa vacío si no existe.
    final userMap = json['usuario'] as Map<String, dynamic>? ?? {};

    return UserProfile(
      id: json['id']?.toString() ?? '',
      // Obtiene el ID del usuario del objeto anidado, con un fallback al campo de nivel superior.
      userId: userMap['id']?.toString() ?? json['usuarioId']?.toString() ?? '',
      // Obtiene el email del objeto anidado.
      email: userMap['email'] as String? ?? 'Email no disponible',
      fullName: json['nombreCompleto'] as String? ?? 'Nombre no disponible',
      country: json['pais'] as String?,
      city: json['ciudad'] as String?,
      bio: json['biografia'] as String?,
      profilePictureUrl: json['fotoPerfil'] as String?,
      birthDate: json['fechaNacimiento'] as String?,
      gender: json['genero'] as String?,
      phone: json['telefono'] as String?,
      documentId: json['documentoIdentidad'] as String?,
    );
  }
}
