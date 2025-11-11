import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/owner_home_screen.dart';

class CourtDetailsScreen extends StatelessWidget {
  final Court court;

  const CourtDetailsScreen({super.key, required this.court});

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
                  _buildInfoRow(context, icon: Icons.location_on, title: 'Dirección', content: court.address),
                  const SizedBox(height: 24),
                  _buildInfoRow(context, icon: Icons.monetization_on, title: 'Precio por Hora', content: '\$${court.price.toStringAsFixed(2)}'),
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
          court.name,
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              court.imageUrl,
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
          'Disfruta de una experiencia de primer nivel en nuestra cancha. Perfectamente mantenida y con instalaciones de alta calidad, es el lugar ideal para tus partidos y entrenamientos. Contamos con iluminación profesional para juegos nocturnos y un entorno seguro y agradable para toda la familia.', // Placeholder
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
