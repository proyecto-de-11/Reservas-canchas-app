import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _bioController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _profilePicController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedBirthDate;

  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _birthDateController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _profilePicController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1920, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authService = Provider.of<AuthService>(context, listen: false);
      final apiService = ApiService();

      if (authService.userId == null || authService.token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Usuario no autenticado.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final profileData = {
        'usuarioId': authService.userId!,
        'nombreCompleto': _fullNameController.text,
        'telefono': _phoneController.text,
        'documentoIdentidad': _idController.text,
        'fechaNacimiento': _birthDateController.text,
        'genero': _selectedGender,
        'fotoPerfil': _profilePicController.text,
        'biografia': _bioController.text,
        'ciudad': _cityController.text,
        'pais': _countryController.text,
      };

      final success = await apiService.createProfile(profileData, authService.token!);

      if (!mounted) return;

      if (success) {
        // ¡Paso clave! Cerrar la sesión actual antes de redirigir.
        await authService.logout();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Perfil creado! Por favor, inicia sesión de nuevo.')),
        );
        
        // Ahora, la redirección a /login funcionará como se espera.
        context.go('/login');
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear el perfil. Inténtalo de nuevo.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completar Perfil', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(_fullNameController, 'Nombre Completo'),
              _buildTextField(_phoneController, 'Teléfono'),
              _buildTextField(_idController, 'Documento de Identidad'),
              _buildDateField(),
              _buildGenderDropdown(),
              _buildTextField(_profilePicController, 'URL de Foto de Perfil (Opcional)', isOptional: true),
              _buildTextField(_bioController, 'Biografía (Opcional)', isOptional: true, maxLines: 3),
              _buildTextField(_cityController, 'Ciudad'),
              _buildTextField(_countryController, 'País'),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Guardar Perfil'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isOptional = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _birthDateController,
        decoration: InputDecoration(
          labelText: 'Fecha de Nacimiento',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
        validator: (value) => (value == null || value.isEmpty) ? 'Este campo es obligatorio' : null,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(labelText: 'Género', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        items: ['Masculino', 'Femenino', 'Otro']
            .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
            .toList(),
        onChanged: (value) => setState(() => _selectedGender = value),
        validator: (value) => (value == null) ? 'Selecciona un género' : null,
      ),
    );
  }
}
