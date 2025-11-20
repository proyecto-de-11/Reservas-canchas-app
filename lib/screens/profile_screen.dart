import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/user_profile.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:developer' as developer;

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.token != null) {
      final apiService = ApiService();
      _profileFuture = apiService.getUserProfile(widget.userId, token: authService.token);
    } else {
      developer.log('Token es nulo, no se puede cargar el perfil.', name: 'ProfileScreen');
      _profileFuture = Future.value(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: _buildFab(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      );
  }

  Widget _buildBody() {
    return FutureBuilder<UserProfile?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'Error al cargar el perfil. Intenta de nuevo.',
                style: GoogleFonts.poppins(),
              ),
            );
          }

          final userProfile = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(userProfile),
                const SizedBox(height: 24),
                _buildStatsCard(),
                const SizedBox(height: 24),
                _buildInfoCard(userProfile),
                const SizedBox(height: 100), // Espacio para el FAB
              ],
            ),
          );
        },
      );
  }

   Widget _buildHeader(UserProfile profile) {
    final profileImageUrl = profile.profilePictureUrl ?? 'https://via.placeholder.com/150';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, const Color(0xFF43cea2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 52,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.fullName,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email,
            style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.85), fontSize: 16),
          ),
          const SizedBox(height: 20),
          Text(
            profile.bio ?? 'Bio no disponible. Toca el botón de editar para añadir una.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(percent: 75, value: '22', label: 'Partidos', color: Colors.blueAccent),
              _buildStatItem(percent: 50, value: '12', label: 'Equipos', color: Colors.greenAccent),
              _buildStatItem(percent: 85, value: '8', label: 'Torneos', color: Colors.orangeAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({required double percent, required String value, required String label, required Color color}){
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 0,
              centerSpaceRadius: 25,
              sections: [
                PieChartSectionData(
                  value: percent,
                  color: color,
                  radius: 10,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: 100 - percent,
                  color: Colors.grey.shade200,
                  radius: 10,
                  showTitle: false,
                ),
              ]
            )
          ),
        ),
        const SizedBox(height: 8),
         Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.grey[600]),
        ),
      ],
    );
  }


  Widget _buildInfoCard(UserProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información Personal',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 24, thickness: 1),
              _buildInfoRow(Icons.cake_outlined, 'Fecha de Nacimiento', _formatDate(profile.birthDate)),
              _buildInfoRow(Icons.person_outline, 'Género', profile.gender ?? 'No disponible'),
              _buildInfoRow(Icons.phone_outlined, 'Teléfono', profile.phone ?? 'No disponible'),
              _buildInfoRow(Icons.location_on_outlined, 'Ubicación', '${profile.city ?? '-'}, ${profile.country ?? '-'}'),
              _buildInfoRow(Icons.badge_outlined, 'Documento', profile.documentId ?? 'No disponible'),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return 'No disponible';
    try {
      return DateFormat('dd MMMM, yyyy', 'es_ES').format(DateTime.parse(date));
    } catch (e) {
      developer.log('Error al formatear fecha: $e', name: 'ProfileScreen');
      return 'Fecha inválida';
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navegar a la pantalla de edición de perfil
           // context.go('/profile/${widget.userId}/edit');
        },
        label: Text('Editar Perfil', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.edit_rounded),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 8.0,
      );
  }
}
