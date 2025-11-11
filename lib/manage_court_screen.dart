import 'package:flutter/material.dart';
import 'owner_home_screen.dart'; // Importamos el modelo Court

class ManageCourtScreen extends StatefulWidget {
  final Court? court; // El parámetro para saber si editamos o añadimos

  const ManageCourtScreen({super.key, this.court});

  @override
  State<ManageCourtScreen> createState() => _ManageCourtScreenState();
}

class _ManageCourtScreenState extends State<ManageCourtScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;

  bool get _isEditing => widget.court != null;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los datos existentes si estamos editando
    _nameController = TextEditingController(text: widget.court?.name ?? '');
    _addressController = TextEditingController(text: widget.court?.address ?? '');
    _priceController = TextEditingController(text: widget.court?.price.toString() ?? '');
    _imageUrlController = TextEditingController(text: widget.court?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveCourt() {
    if (_formKey.currentState!.validate()) {
      // Lógica de guardado (simulada)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // FIX: Usar interpolación de strings
          content: Text('Cancha ${_isEditing ? 'actualizada' : 'creada'} con éxito (simulación).'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Cancha' : 'Añadir Nueva Cancha'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePreview(),
              const SizedBox(height: 24),

              _buildTextFormField(
                controller: _nameController,
                labelText: 'Nombre de la cancha',
                icon: Icons.sports_soccer_outlined,
                validator: (value) => (value == null || value.isEmpty) ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _addressController,
                labelText: 'Dirección',
                icon: Icons.location_on_outlined,
                validator: (value) => (value == null || value.isEmpty) ? 'La dirección es obligatoria' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _priceController,
                labelText: 'Precio por hora',
                icon: Icons.monetization_on_outlined,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'El precio es obligatorio';
                  if (double.tryParse(value) == null) return 'Introduce un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _imageUrlController,
                labelText: 'URL de la imagen',
                icon: Icons.image_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'La URL es obligatoria';
                  // FIX: Validar la URL de forma segura para evitar errores de nulidad
                  if (Uri.tryParse(value)?.isAbsolute != true) {
                    return 'Introduce una URL válida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: _saveCourt,
                icon: const Icon(Icons.save_alt_rounded),
                label: Text(_isEditing ? 'Guardar Cambios' : 'Crear Cancha'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            _imageUrlController.text,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('URL de imagen inválida o vacía', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
      onChanged: (value) {
        if (labelText == 'URL de la imagen') {
          setState(() {});
        }
      },
    );
  }
}
