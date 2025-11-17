import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/owner_home_screen.dart';

class CourtDetailsScreen extends StatefulWidget {
  final Court court;

  const CourtDetailsScreen({super.key, required this.court});

  @override
  State<CourtDetailsScreen> createState() => _CourtDetailsScreenState();
}

class _CourtDetailsScreenState extends State<CourtDetailsScreen> {
  // Los días disponibles ahora son fijos para esta pantalla de solo lectura.
  final Set<String> _availableDays = {'L', 'M', 'X', 'J', 'V'};

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverAppBar(context, textTheme),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(context, icon: Icons.location_on, title: 'Dirección', content: widget.court.address),
                  const SizedBox(height: 24),
                  _buildInfoRow(context, icon: Icons.monetization_on, title: 'Precio por Hora', content: '\$${widget.court.price.toStringAsFixed(2)}'),
                  const SizedBox(height: 24),
                  _buildInfoRow(context, icon: Icons.schedule, title: 'Horario', content: 'Lunes a Domingo\n9:00 AM - 10:00 PM'),
                  const SizedBox(height: 24),
                  _buildAvailabilitySection(context),
                  const SizedBox(height: 24),
                  _buildDescriptionSection(context),
                  const SizedBox(height: 32),
                  _buildActionButtons(context), // <-- SECCIÓN DE ACCIONES ACTUALIZADA
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, TextTheme textTheme) {
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      elevation: 4,
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.court.name,
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.court.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.error, color: Colors.white, size: 50)),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color.fromRGBO(0, 0, 0, 0.7)],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
        titlePadding: const EdgeInsets.only(left: 48, bottom: 16, right: 48),
        centerTitle: true,
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String title, required String content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.black54, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection(BuildContext context) {
    final List<String> days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Días Disponibles',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days.map((day) {
            return _buildDayChip(day, _availableDays.contains(day));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDayChip(String day, bool isAvailable) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          gradient: isAvailable
              ? LinearGradient(
                  colors: [theme.primaryColor, Color.fromRGBO(theme.primaryColor.red, theme.primaryColor.green, theme.primaryColor.blue, 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isAvailable ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isAvailable
              ? [
                  BoxShadow(
                    color: Color.fromRGBO(theme.primaryColor.red, theme.primaryColor.green, theme.primaryColor.blue, 0.5),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            day,
            style: GoogleFonts.poppins(
              color: isAvailable ? Colors.white : Colors.grey[600],
              fontWeight: isAvailable ? FontWeight.bold : FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acerca de la Cancha',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Text(
          'Disfruta de una experiencia de primer nivel en nuestra cancha. Perfectamente mantenida y con instalaciones de alta calidad, es el lugar ideal para tus partidos y entrenamientos. Contamos con iluminación profesional para juegos nocturnos y un entorno seguro y agradable para toda la familia.',
          style: GoogleFonts.poppins(fontSize: 15, color: Colors.black54, height: 1.6),
        ),
      ],
    );
  }

  // --- CORRECCIÓN: Widget de acciones del propietario ---
  Widget _buildActionButtons(BuildContext context) {
    return Center(
      child: FilledButton.icon(
        icon: const Icon(Icons.share_rounded),
        label: const Text('Compartir Cancha'),
        onPressed: () {
          // Lógica para compartir: por ejemplo, usando el paquete `share_plus`
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Función de compartir no implementada.')),
          );
        },
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
