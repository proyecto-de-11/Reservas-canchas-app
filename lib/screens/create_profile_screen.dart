import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/services/auth_service.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  // Controladores para cada campo del formulario
  final _nombreCompletoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _documentoIdentidadController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  final _fotoPerfilController = TextEditingController();
  final _biografiaController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _paisController = TextEditingController();
  String? _generoValue;
  DateTime? _selectedDate;

  bool _isLoading = false;

  @override
  void dispose() {
    _nombreCompletoController.dispose();
    _telefonoController.dispose();
    _documentoIdentidadController.dispose();
    _fechaNacimientoController.dispose();
    _fotoPerfilController.dispose();
    _biografiaController.dispose();
    _ciudadController.dispose();
    _paisController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authService = Provider.of<AuthService>(context, listen: false);
      final token = authService.token;
      final userIdString = authService.userId; 

      if (token == null || userIdString == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error de autenticación. Por favor, inicia sesión de nuevo.'),
          backgroundColor: Colors.red,
        ));
        setState(() => _isLoading = false);
        return;
      }

      final userIdInt = int.tryParse(userIdString);
      if (userIdInt == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error interno: El ID de usuario no es válido.'),
          backgroundColor: Colors.red,
        ));
        setState(() => _isLoading = false);
        return;
      }

      final profileData = {
        'usuarioId': userIdInt,
        'nombreCompleto': _nombreCompletoController.text,
        'telefono': _telefonoController.text,
        'documentoIdentidad': _documentoIdentidadController.text,
        'fechaNacimiento': _fechaNacimientoController.text,
        'genero': _generoValue,
        'fotoPerfil': _fotoPerfilController.text,
        'biografia': _biografiaController.text,
        'ciudad': _ciudadController.text,
        'pais': _paisController.text,
      };

      final success = await _apiService.createProfile(profileData, token);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('¡Perfil creado con éxito!'),
          backgroundColor: Colors.green,
        ));
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error al crear el perfil. Inténtalo de nuevo.'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _fechaNacimientoController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completa tu Perfil', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade100],
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextFormField(_nombreCompletoController, 'Nombre Completo', Icons.person_outline),
                _buildTextFormField(_telefonoController, 'Teléfono', Icons.phone_outlined),
                _buildTextFormField(_documentoIdentidadController, 'Documento de Identidad', Icons.badge_outlined),
                _buildDatePickerFormField(),
                _buildGenderDropdown(),
                _buildTextFormField(_fotoPerfilController, 'URL de Foto de Perfil', Icons.link_outlined),
                _buildTextFormField(_biografiaController, 'Biografía', Icons.edit_outlined, maxLines: 3),
                _buildTextFormField(_ciudadController, 'Ciudad', Icons.location_city_outlined),
                _buildTextFormField(_paisController, 'País', Icons.flag_outlined),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF007BFF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Guardar Perfil', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePickerFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _fechaNacimientoController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Fecha de Nacimiento',
          prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onTap: () => _selectDate(context),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        initialValue: _generoValue,
        decoration: InputDecoration(
          labelText: 'Género',
          prefixIcon: Icon(Icons.wc_outlined, color: Colors.grey[600]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: ['masculino', 'femenino', 'otro'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value[0].toUpperCase() + value.substring(1)), // Capitalize
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _generoValue = newValue;
          });
        },
        validator: (value) => value == null ? 'Este campo es obligatorio' : null,
      ),
    );
  }
}
