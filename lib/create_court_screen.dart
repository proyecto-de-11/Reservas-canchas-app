import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateCourtScreen extends StatefulWidget {
  const CreateCourtScreen({super.key});

  @override
  State<CreateCourtScreen> createState() => _CreateCourtScreenState();
}

class _CreateCourtScreenState extends State<CreateCourtScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isRoofCovered = false;
  bool _isActive = true;
  String? _selectedStatus;

  final List<String> _statusOptions = ['Disponible', 'En Mantenimiento', 'Cerrada Temporalmente'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nueva Cancha', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: const Color(0xFF0056B3),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Información Principal'),
              const SizedBox(height: 16),
              _buildTextField(label: 'Nombre de la Cancha', hint: 'Ej: Cancha Principal'),
              const SizedBox(height: 16),
              _buildTextField(label: 'Tipo de Superficie', hint: 'Ej: Césped Sintético'),
              const SizedBox(height: 16),
              _buildTextField(label: 'Capacidad', hint: 'Ej: Fútbol 7, Tenis individual'),
              const SizedBox(height: 16),
              _buildTextField(label: 'Ubicación / Dirección', hint: 'Ej: Av. Siempreviva 742'),
              const SizedBox(height: 24),
              _buildSectionTitle('Detalles y Precio'),
              const SizedBox(height: 16),
               _buildPriceField(label: 'Precio por Hora', hint: 'Ej: 50.00'),
              const SizedBox(height: 16),
              _buildImagePicker(),
              const SizedBox(height: 24),
              _buildSectionTitle('Configuración y Estado'),
              const SizedBox(height: 16),
              _buildSwitch(title: '¿Es techada?', value: _isRoofCovered, onChanged: (val) => setState(() => _isRoofCovered = val)),
              const SizedBox(height: 12),
               _buildStatusDropdown(),
              const SizedBox(height: 12),
              _buildSwitch(title: 'Cancha Activa', subtitle: 'Desactívala si no está disponible para reservas', value: _isActive, onChanged: (val) => setState(() => _isActive = val)),
              const SizedBox(height: 40),
              _buildSubmitButton(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0056B3)),
    );
  }

  Widget _buildTextField({required String label, required String hint, TextInputType? keyboardType}) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
    );
  }
  
  Widget _buildPriceField({required String label, required String hint}) {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.attach_money),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
    );
  }

  Widget _buildImagePicker() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.upload_file_rounded),
      label: const Text('Subir Imagen de la Cancha'),
      onPressed: () { /* Lógica para subir imagen */ },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSwitch({required String title, String? subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: GoogleFonts.poppins()) : null,
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF007BFF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Estado de la Cancha',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      value: _selectedStatus,
      hint: const Text('Selecciona un estado'),
      onChanged: (String? newValue) {
        setState(() {
          _selectedStatus = newValue;
        });
      },
      items: _statusOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: GoogleFonts.poppins()),
        );
      }).toList(),
      validator: (value) => value == null ? 'Selecciona un estado' : null,
    );
  }

  Widget _buildSubmitButton(BuildContext context, ThemeData theme) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.save_alt_rounded, color: Colors.white),
      label: Text('Guardar Cancha', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardando datos...'), backgroundColor: Colors.green),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0056B3),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    );
  }
}
