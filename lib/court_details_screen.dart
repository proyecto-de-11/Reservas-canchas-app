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
  // Estado inicial de ejemplo: Lunes a Viernes disponibles, fin de semana no.
  final Set<String> _selectedDays = {'L', 'M', 'X', 'J', 'V'};

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
                  _buildActionButtons(context),
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
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  stops: const [0.5, 1.0],
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
            return _buildDayChip(day, _selectedDays.contains(day));
          }).toList(),
        ),
      ],
    );
  }

  // Widget de botón de día personalizado
  Widget _buildDayChip(String day, bool isSelected) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedDays.contains(day)) {
            _selectedDays.remove(day);
          } else {
            _selectedDays.add(day);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42, 
        height: 42,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.5),
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
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            label: const Text('Reservar Ahora'),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.share, size: 28),
          color: Theme.of(context).primaryColor,
          onPressed: () {},
        ),
      ],
    );
  }
}
