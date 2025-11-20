import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SportsPreferencesScreen extends StatefulWidget {
  const SportsPreferencesScreen({super.key});

  @override
  State<SportsPreferencesScreen> createState() => _SportsPreferencesScreenState();
}

class _SportsPreferencesScreenState extends State<SportsPreferencesScreen> {
  // Estado para el diseño, sin lógica funcional
  int? _selectedGenderIndex; // 0 para Hombre, 1 para Mujer
  int? _selectedSportIndex; // 0: Fútbol, 1: Baloncesto, 2: Tenis

  // Controladores para animaciones de los campos de texto
  final _footballPositionController = TextEditingController();
  final _basketballPositionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Preferencias Deportivas', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Tu Género'),
            const SizedBox(height: 16),
            _buildGenderSelector(),
            const SizedBox(height: 32),
            _buildSectionTitle('Tu Deporte Favorito'),
            const SizedBox(height: 16),
            _buildSportSelector(),
            const SizedBox(height: 32),
            // --- Campos de Posición Condicionales ---
            _buildConditionalPositionFields(),
            const SizedBox(height: 40),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
    );
  }

  Widget _buildGenderSelector() {
    return Center(
      child: ToggleButtons(
        isSelected: [_selectedGenderIndex == 0, _selectedGenderIndex == 1],
        onPressed: (index) {
          setState(() {
            _selectedGenderIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        selectedColor: Colors.white,
        fillColor: const Color(0xFF007BFF),
        borderColor: Colors.grey[300],
        selectedBorderColor: const Color(0xFF007BFF),
        children: [
          _buildGenderOption(Icons.male, 'Hombre'),
          _buildGenderOption(Icons.female, 'Mujer'),
        ],
      ),
    );
  }

  Widget _buildGenderOption(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSportSelector() {
    return Column(
      children: [
        _buildSportCard(
          icon: Icons.sports_soccer,
          title: 'Fútbol',
          index: 0,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        _buildSportCard(
          icon: Icons.sports_basketball,
          title: 'Baloncesto',
          index: 1,
          color: Colors.orange,
        ),
        const SizedBox(height: 16),
        _buildSportCard(
          icon: Icons.sports_tennis,
          title: 'Tenis',
          index: 2,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildSportCard({required IconData icon, required String title, required int index, required Color color}) {
    final isSelected = _selectedSportIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSportIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withAlpha(76),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionalPositionFields() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedSportIndex == 0) ...[
            _buildSectionTitle('¿Cuál es tu posición?'),
            const SizedBox(height: 16),
            _buildPositionTextField(
              controller: _footballPositionController,
              hint: 'Ej: Delantero, Defensa, etc.',
            ),
          ] else if (_selectedSportIndex == 1) ...[
            _buildSectionTitle('¿Cuál es tu posición?'),
            const SizedBox(height: 16),
            _buildPositionTextField(
              controller: _basketballPositionController,
              hint: 'Ej: Base, Pívot, etc.',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPositionTextField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        // No hay lógica, solo diseño
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Preferencias guardadas! (simulación)'),
            backgroundColor: Color(0xFF007BFF),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      child: Center(
        child: Text(
          'Guardar Preferencias',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
