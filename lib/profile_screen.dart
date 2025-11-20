import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/user_profile.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/services/auth_service.dart';
import 'dart:developer' as developer;

class ProfileScreen extends StatefulWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  Future<UserProfile?>? _userProfileFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userProfileFuture == null) {
      _loadProfile();
    }
  }

  void _loadProfile() {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    // **CORRECCIÓN: Aseguramos que profileIdToLoad es de tipo String?**
    String? profileIdToLoad = widget.userId ?? authService.userId;

    if (profileIdToLoad != null) {
      setState(() {
        // **CORRECCIÓN: Pasamos un String, como espera el método**
        _userProfileFuture = _apiService.getUserProfile(profileIdToLoad);
      });
    } else {
      developer.log("Error: No se pudo determinar un ID de perfil para cargar.", name: 'ProfileScreen', level: 1000);
       setState(() {
        _userProfileFuture = Future.value(null);
       });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    // **CORRECCIÓN: Comparación segura entre Strings**
    final isMyProfile = widget.userId == null || widget.userId == authService.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text(isMyProfile ? 'Mi Perfil' : 'Perfil de Usuario', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: const Color(0xFF0056B3),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<UserProfile?>(
          future: _userProfileFuture,
          builder: (context, snapshot) {
            if (_userProfileFuture == null) {
               return const Center(child: Text("Iniciando perfil..."));
            }
            
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text(
                  'No se pudo cargar el perfil del usuario.',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }

            final userProfile = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: [
                _buildProfileHeader(context, userProfile),
                const SizedBox(height: 20),
                _buildPersonalInfoCard(userProfile),
                const SizedBox(height: 20),
                _buildContactInfoCard(userProfile),
                const SizedBox(height: 20),
                if (userProfile.bio != null && userProfile.bio!.isNotEmpty)
                  _buildBiographyCard(userProfile.bio!),
                const SizedBox(height: 20),
                if(isMyProfile)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildLogoutButton(context, authService),
                  ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
      floatingActionButton: isMyProfile ? FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF007BFF),
        child: const Icon(Icons.edit, color: Colors.white),
      ) : null,
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfile profile) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFF0056B3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 52,
                  backgroundImage: (profile.profilePictureUrl != null && profile.profilePictureUrl!.isNotEmpty)
                      ? NetworkImage(profile.profilePictureUrl!)
                      : const NetworkImage('https://picsum.photos/200'),
                ),
              ),
              const Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.camera_alt, color: Color(0xFF007BFF), size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            profile.fullName,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            profile.email,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0056B3)),
              ),
              const Divider(height: 20, thickness: 1),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 16),
          Text('$label:', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: GoogleFonts.poppins(), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(UserProfile profile) {
    return _buildSectionCard(
      title: 'Información Personal',
      children: [
        _buildDetailRow(icon: Icons.person_outline, label: 'Nombre', value: profile.fullName),
        _buildDetailRow(icon: Icons.badge_outlined, label: 'Documento', value: 'No disponible'),
        _buildDetailRow(icon: Icons.cake_outlined, label: 'Nacimiento', value: 'No disponible'),
        _buildDetailRow(icon: Icons.wc_outlined, label: 'Género', value: 'No disponible'),
      ],
    );
  }

  Widget _buildContactInfoCard(UserProfile profile) {
    return _buildSectionCard(
      title: 'Información de Contacto',
      children: [
        _buildDetailRow(icon: Icons.phone_outlined, label: 'Teléfono', value: 'No disponible'),
        _buildDetailRow(icon: Icons.location_city_outlined, label: 'Ciudad', value: profile.city ?? 'No especificada'),
        _buildDetailRow(icon: Icons.public_outlined, label: 'País', value: profile.country ?? 'No especificado'),
      ],
    );
  }

  Widget _buildBiographyCard(String bio) {
    return _buildSectionCard(
      title: 'Biografía',
      children: [
        Text(
          bio,
          style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthService authService) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.logout, color: Colors.white),
      label: Text(
        'Cerrar Sesión',
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        authService.logout();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        elevation: 5,
      ),
    );
  }
}
