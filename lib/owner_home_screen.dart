import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/court_model.dart';

// --- Screen ---
class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  late List<Court> _courts;
  String? _selectedCourtId;

  @override
  void initState() {
    super.initState();
    _courts = [
      Court(
        id: '1',
        name: 'Cancha Central (Fútbol 7)',
        location: 'Av. Siempreviva 742, Springfield',
        description: 'Descripción de la cancha de fútbol 7'
      ),
      Court(
        id: '2',
        name: 'Pista de Tenis B',
        location: 'Calle Falsa 123, Shelbyville',
        description: 'Descripción de la pista de tenis B'
      ),
      Court(
        id: '3',
        name: 'Pabellón Multiusos Interior',
        location: 'Blvd. de los Sueños Rotos 45',
        description: 'Descripción del pabellón multiusos'
      ),
    ];
  }

  void _deleteCourt(Court court) {
    setState(() {
      _courts.removeWhere((c) => c.id == court.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cancha eliminada con éxito.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(Court court) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que quieres eliminar la cancha "${court.name}"?'),
                const Text('\nEsta acción no se puede deshacer.', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCourt(court);
              },
            ),
          ],
        );
      },
    );
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    extendBodyBehindAppBar: true, // Extiende el cuerpo detrás del AppBar
    appBar: AppBar(
      title: const Text('Mis Canchas', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      backgroundColor: Colors.transparent, // Fondo transparente
      elevation: 0, // Sin sombra
      foregroundColor: Colors.white, // Color de íconos (como el del drawer)
      centerTitle: true,
    ),
    drawer: _buildOwnerDrawer(context),
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          itemCount: _courts.length,
          itemBuilder: (context, index) {
            final court = _courts[index];
            return _buildCourtCard(context, court);
          },
        ),
      ),
    ),
  );
}

  Widget _buildCourtCard(BuildContext context, Court court) {
    final textTheme = Theme.of(context).textTheme;
    final isSelected = _selectedCourtId == court.id;

    // Las tarjetas ahora son semi-transparentes para integrarse con el fondo
    return Card(
      elevation: isSelected ? 12 : 6,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      color: Colors.white.withOpacity(0.9), // Ligera transparencia
      shadowColor: Colors.black.withOpacity(0.5),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCourtId = isSelected ? null : court.id;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  'https://picsum.photos/seed/futbol/800/600',
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.error, size: 50)),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withAlpha(153), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 0.7],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        court.name,
                        style: GoogleFonts.poppins(
                          fontSize: 24, 
                          color: Colors.white, 
                          fontWeight: FontWeight.bold, 
                          shadows: [const Shadow(blurRadius: 3, color: Colors.black87)]
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.grey[800], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      court.location,
                      style: textTheme.bodyLarge?.copyWith(color: Colors.grey[900]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            _buildActionsPanel(context, court, isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsPanel(BuildContext context, Court court, bool isSelected) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      crossFadeState: isSelected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: Container(),
      secondChild: Container(
        color: Colors.black.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionButton(context, icon: Icons.visibility, label: 'Detalles', onTap: () => context.go('/owner-home/court-details', extra: court)),
              _actionButton(context, icon: Icons.edit, label: 'Editar', onTap: () => context.go('/owner-home/manage-court', extra: court)),
              _actionButton(context, icon: Icons.delete, label: 'Eliminar', color: Colors.red.shade400, onTap: () => _showDeleteConfirmationDialog(court)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, {required IconData icon, required String label, Color? color, required VoidCallback onTap}) {
    final buttonColor = color ?? const Color(0xFF185a9d); // Color principal de acento
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20, color: buttonColor),
      label: Text(label, style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Drawer _buildOwnerDrawer(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context, textTheme),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.stadium_outlined,
                  text: 'Mis Canchas',
                  isSelected: true,
                  onTap: () => context.pop(),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.add_location_alt_outlined,
                  text: 'Crear Cancha',
                  onTap: () => context.go('/owner-home/create-court'),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.calendar_today_outlined,
                  text: 'Calendario de Reservas',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
              context,
              icon: Icons.logout,
              text: 'Cerrar Sesión',
              onTap: () => context.go('/'),
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Icon(Icons.business_center, size: 40, color: Color(0xFF185a9d)),
          ),
          const SizedBox(height: 12),
          Text(
            'Nombre del Propietario',
            style: textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          Text(
            'propietario@email.com',
            style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap, bool isSelected = false, Color? color}) {
    final effectiveColor = color ?? (isSelected ? const Color(0xFF185a9d) : Colors.black87);
    final iconColor = color ?? (isSelected ? const Color(0xFF185a9d) : Colors.grey[700]);

    return Material(
      color: isSelected && color == null ? const Color(0xFF185a9d).withAlpha(25) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: (color ?? const Color(0xFF185a9d)).withAlpha(51),
        highlightColor: (color ?? const Color(0xFF185a9d)).withAlpha(25),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: <Widget>[
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 20),
              Expanded(
                child: Text(text, style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: effectiveColor,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
