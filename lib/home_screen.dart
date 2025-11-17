import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 0; // Índice para la BottomNavigationBar

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Ya estamos en home, no hacer nada
        break;
      case 1:
        context.go('/home/chats');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Inicio', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(context),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20), // Espacio para que el AppBar no se solape
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildMainContentCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 40, color: Color(0xFF185a9d)),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido de nuevo,',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: const Color.fromRGBO(255, 255, 255, 0.8),
              ),
            ),
            Text(
              'Usuario!',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                children: [
                  _buildDrawerItem(context, icon: Icons.sports_soccer_outlined, text: 'Reservar Cancha', color: const Color(0xFF185a9d), onTap: () => context.go('/create-reservation')),
                  _buildDrawerItem(context, icon: Icons.bar_chart_outlined, text: 'Estadísticas del Equipo', color: const Color(0xFF185a9d), onTap: () => context.go('/home/team-stats')),
                  _buildDrawerItem(context, icon: Icons.calendar_today_outlined, text: 'Mis Reservas', color: const Color(0xFF185a9d), onTap: () {}),
                  _buildDrawerItem(context, icon: Icons.history_outlined, text: 'Historial', color: const Color(0xFF185a9d), onTap: () {}),
                  _buildDrawerItem(context, icon: Icons.favorite_border_outlined, text: 'Preferencias', color: const Color(0xFF185a9d), onTap: () => context.go('/profile/preferences')),
                  const Divider(thickness: 1, indent: 16, endIndent: 16, height: 32),
                  _buildDrawerItem(context, icon: Icons.settings_outlined, text: 'Configuración', color: Colors.grey, onTap: () {}),
                ],
              ),
            ),
            const Divider(thickness: 1),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildDrawerItem(context, icon: Icons.logout, text: 'Cerrar Sesión', color: Colors.redAccent, onTap: () => context.go('/')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
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
            child: Icon(Icons.person, size: 40, color: Color(0xFF185a9d)),
          ),
          const SizedBox(height: 12),
          Text(
            'Nombre de Usuario',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'usuario@email.com',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String text, required Color color, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: color.withAlpha(51),
        highlightColor: color.withAlpha(25),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: <Widget>[
              Icon(icon, color: color, size: 26),
              const SizedBox(width: 20),
              Text(text, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContentCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: const Color.fromRGBO(255, 255, 255, 0.9),
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.5),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.event_note_outlined, size: 60, color: Color(0xFF185a9d)),
            const SizedBox(height: 16),
            Text(
              'No tienes próximas reservas',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '¿Listo para jugar? Organiza tu próximo partido ahora mismo.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/create-reservation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF185a9d),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                elevation: 5,
                shadowColor: const Color(0xFF185a9d).withAlpha(128),
              ),
              child: Text(
                'Reservar una Cancha',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Perfil',
        ),
      ],
      backgroundColor: Colors.white, // Fondo blanco para la barra
      selectedItemColor: const Color(0xFF185a9d),
      unselectedItemColor: Colors.grey[600],
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8, // Sombra para la barra
    );
  }
}
