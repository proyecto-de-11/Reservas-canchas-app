import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/services/profile_service.dart';
import 'dart:async';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final ProfileService _profileService = ProfileService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allProfiles = [];
  List<Map<String, dynamic>> _filteredProfiles = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProfiles();
    _searchController.addListener(_filterProfiles);
  }

  Future<void> _loadProfiles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final profiles = await _profileService.getPublicProfiles();
      if (mounted) {
        setState(() {
          _allProfiles = profiles;
          _filteredProfiles = profiles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar perfiles: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  void _filterProfiles() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProfiles = _allProfiles.where((profile) {
        final name = profile['nombreCompleto']?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: _buildSearchBar(),
        // --- BOTÓN DE VOLVER CORREGIDO ---
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey[800]),
          onPressed: () => context.go('/home'), // ¡ACCIÓN CORREGIDA!
          tooltip: 'Volver al inicio',
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFF8F9FA), Colors.grey[200]!],
          ),
          image: const DecorationImage(
            image: NetworkImage('https://www.transparenttextures.com/patterns/noise-lines.png'),
            repeat: ImageRepeat.repeat,
            opacity: 0.03,
          ),
        ),
        child: SafeArea(child: _buildBody()),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Buscar personas...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(icon: Icon(Icons.clear, color: Colors.grey[600]), onPressed: () => _searchController.clear())
              : null,
        ),
        style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF185a9d)));
    }
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage, style: GoogleFonts.poppins(color: Colors.red)));
    }
    if (_filteredProfiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty ? 'Busca jugadores por su nombre' : 'No se encontraron resultados',
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[700], fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      itemCount: _filteredProfiles.length,
      itemBuilder: (context, index) {
        final profile = _filteredProfiles[index];
        return _AnimatedUserCard(profile: profile, index: index);
      },
    );
  }
}

class _AnimatedUserCard extends StatefulWidget {
  final Map<String, dynamic> profile;
  final int index;

  const _AnimatedUserCard({required this.profile, required this.index});

  @override
  State<_AnimatedUserCard> createState() => _AnimatedUserCardState();
}

class _AnimatedUserCardState extends State<_AnimatedUserCard> {
  bool _isHovered = false;
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) => setState(() => _scale = 0.96);
  void _onTapUp(TapUpDetails details) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (widget.index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Transform.scale(
            scale: value,
            child: Opacity(opacity: value, child: child),
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 150),
            child: UserCard(profile: widget.profile, isHovered: _isHovered),
          ),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  final bool isHovered;

  const UserCard({super.key, required this.profile, this.isHovered = false});

  @override
  Widget build(BuildContext context) {
    final imageUrl = profile['fotoPerfil'] as String?;
    final bool hasValidImage = imageUrl != null && imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isHovered ? const Color(0xFF185a9d).withAlpha(77) : Colors.black.withAlpha(26),
            blurRadius: isHovered ? 20 : 15,
            spreadRadius: isHovered ? -2 : 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {}, // Navegación al perfil
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: hasValidImage ? NetworkImage(imageUrl) : null,
                backgroundColor: Colors.grey[200],
                child: !hasValidImage ? Icon(Icons.person_outline, size: 32, color: Colors.grey[500]) : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  profile['nombreCompleto'] ?? 'Nombre no disponible',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 17, color: const Color(0xFF0A2540)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: () => print('Iniciar chat con: ${profile['nombreCompleto']}'),
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                style: IconButton.styleFrom(
                  foregroundColor: const Color(0xFF185a9d),
                  backgroundColor: const Color(0xFF185a9d).withAlpha(26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
