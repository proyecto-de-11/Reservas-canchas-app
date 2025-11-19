import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/services/profile_service.dart';

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
    try {
      final profiles = await _profileService.getPublicProfiles();
      setState(() {
        _allProfiles = profiles;
        _filteredProfiles = profiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar perfiles: ${e.toString()}';
        _isLoading = false;
      });
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: _buildSearchBar(),
        iconTheme: IconThemeData(color: Colors.grey[800]),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Buscar personas...',
        hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: Colors.grey[600]),
                onPressed: () => _searchController.clear(),
              )
            : null,
      ),
      style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage, style: GoogleFonts.poppins(color: Colors.red)));
    }
    if (_filteredProfiles.isEmpty) {
      return Center(child: Text('No se encontraron usuarios.', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700])));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: _filteredProfiles.length,
      itemBuilder: (context, index) {
        final profile = _filteredProfiles[index];
        return UserCard(profile: profile);
      },
    );
  }
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> profile;

  const UserCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    // Usa una imagen de placeholder si la URL está vacía o es inválida
    final imageUrl = profile['fotoPerfil'] as String?;
    final bool hasValidImage = imageUrl != null && imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: hasValidImage ? NetworkImage(imageUrl) : null,
            backgroundColor: Colors.grey[300],
            child: !hasValidImage ? Icon(Icons.person, color: Colors.grey[600]) : null,
          ),
          title: Text(
            profile['nombreCompleto'] ?? 'Nombre no disponible',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          subtitle: Text(
            profile['biografia'] ?? 'Sin biografía.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 13),
          ),
          onTap: () {
            // Aquí se podría navegar al perfil detallado del usuario
            print('Viendo perfil de: ${profile['nombreCompleto']}');
          },
        ),
      ),
    );
  }
}
