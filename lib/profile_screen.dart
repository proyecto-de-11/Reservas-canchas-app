
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
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
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80), // Space for the FAB
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            _buildPersonalInfoCard(),
            const SizedBox(height: 20),
            _buildContactInfoCard(),
            const SizedBox(height: 20),
            _buildBiographyCard(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildLogoutButton(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to enter edit mode
        },
        backgroundColor: const Color(0xFF007BFF),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
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
              const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage('https://picsum.photos/200'), // Placeholder image
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.camera_alt, color: const Color(0xFF007BFF), size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Juan Pérez González', // Placeholder Name
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'juan.perez@email.com',
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

  Widget _buildPersonalInfoCard() {
    return _buildSectionCard(
      title: 'Información Personal',
      children: [
        _buildDetailRow(icon: Icons.person_outline, label: 'Nombre', value: 'Juan Pérez González'),
        _buildDetailRow(icon: Icons.badge_outlined, label: 'Documento', value: '12.345.678-9'),
        _buildDetailRow(icon: Icons.cake_outlined, label: 'Nacimiento', value: '01 de Enero, 1990'),
        _buildDetailRow(icon: Icons.wc_outlined, label: 'Género', value: 'Masculino'),
      ],
    );
  }

  Widget _buildContactInfoCard() {
    return _buildSectionCard(
      title: 'Información de Contacto',
      children: [
        _buildDetailRow(icon: Icons.phone_outlined, label: 'Teléfono', value: '+56 9 1234 5678'),
        _buildDetailRow(icon: Icons.location_city_outlined, label: 'Ciudad', value: 'Santiago'),
        _buildDetailRow(icon: Icons.public_outlined, label: 'País', value: 'Chile'),
      ],
    );
  }

  Widget _buildBiographyCard() {
    return _buildSectionCard(
      title: 'Biografía',
      children: [
        Text(
          'Apasionado por el fútbol y el desarrollo de software. Me encanta competir y mejorar mi juego cada día. Busco rivales para partidos amistosos los fines de semana.',
          style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.logout, color: Colors.white),
      label: Text(
        'Cerrar Sesión',
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: () => context.go('/'),
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
