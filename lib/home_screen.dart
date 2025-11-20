import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/user_profile.dart';

// --- DATA MOCKS V12 ---
final List<Map<String, dynamic>> tournaments = [
   {
    "name": "Copa de Verano 2024",
    "sport": "Fútbol 11",
    "date": "Inicia el 25/12",
    "imageUrl": "https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  },
  {
    "name": "Torneo Relámpago de Pádel",
    "sport": "Pádel",
    "date": "Este Sábado",
    "imageUrl": "https://images.unsplash.com/photo-1544298134-2f085a6e5684?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  },
];

final List<Map<String, dynamic>> teamRequests = [
  {
    "teamName": "Los Gladiadores FC",
    "sport": "Fútbol 7",
    "location": "Cancha Rápida #1",
    "dateTime": "Hoy, 20:00hs",
    "needed": 2,
    "avatarUrl": "https://i.pravatar.cc/150?img=11",
  },
  {
    "teamName": "Pádel Masters",
    "sport": "Pádel",
    "location": "Club de Pádel Premium",
    "dateTime": "Mañana, 18:30hs",
    "needed": 1,
    "avatarUrl": "https://i.pravatar.cc/150?img=12",
  },
];

final List<Map<String, dynamic>> courts = [
  {
    "name": "Cancha Rápida #1",
    "location": "Centro Deportivo Municipal",
    "sport": "Fútbol",
    "imageUrl": "https://images.unsplash.com/photo-1551954133-15a31d683633?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "rating": 4.8,
    "reviews": 32,
  },
  {
    "name": "Pádel Cristal Pro",
    "location": "Club de Pádel Premium",
    "sport": "Pádel",
    "imageUrl": "https://images.unsplash.com/photo-1628779238320-b9816a74a4d6?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "rating": 4.9,
    "reviews": 55,
  },
];

// --- ELITE WIDGETS V12 (con correcciones de Opacidad) ---

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  const SectionHeader({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 24.0, bottom: 16.0),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.black87, size: 24),
          if (icon != null) const SizedBox(width: 8),
          Text(title, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87)),
        ],
      ),
    );
  }
}

class TournamentCard extends StatelessWidget {
  final Map<String, dynamic> tournamentData;
  const TournamentCard({super.key, required this.tournamentData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(left: 16, bottom: 12, top: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), spreadRadius: 1, blurRadius: 15, offset: const Offset(0, 8))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.network(tournamentData['imageUrl'], height: 190, width: double.infinity, fit: BoxFit.cover),
            Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black.withAlpha(204), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.center))),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF185a9d).withAlpha(204), borderRadius: BorderRadius.circular(8)),
                    child: Text(tournamentData['sport'], style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  Text(tournamentData['name'], style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(tournamentData['date'], style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withAlpha(230), fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamRequestCard extends StatelessWidget {
  final Map<String, dynamic> requestData;
  const TeamRequestCard({super.key, required this.requestData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 15, spreadRadius: 2, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(radius: 22, backgroundImage: NetworkImage(requestData['avatarUrl'])),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(requestData['teamName'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(requestData['sport'], style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
            ]),
          ]),
          const Divider(height: 24, thickness: 1),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _buildInfoColumn(Icons.location_on_outlined, requestData['location']),
            _buildInfoColumn(Icons.calendar_today_outlined, requestData['dateTime']),
          ]),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text.rich(TextSpan(children: [
              TextSpan(text: 'Faltan: ', style: GoogleFonts.poppins(color: Colors.grey[700])),
              TextSpan(text: '${requestData['needed']} Jugadores', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black87)),
            ])),
            ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.group_add_outlined, size: 20), label: Text('Unirse', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF185a9d), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10))),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String text) {
    return Row(children: [Icon(icon, size: 18, color: Colors.grey[700]), const SizedBox(width: 6), Text(text, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87))]);
  }
}

class CourtCard extends StatelessWidget {
  final Map<String, dynamic> courtData;
  const CourtCard({super.key, required this.courtData});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withAlpha(26), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4))]),
        child: IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ClipRRect(borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)), child: Image.network(courtData['imageUrl'], height: 120, width: 110, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 120, width: 110, color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 40, color: Colors.grey)))),
          Expanded(child: Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(courtData['name'], style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)), const SizedBox(height: 5), Text(courtData['location'], style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)), const SizedBox(height: 10), Row(children: [const Icon(Icons.star_rounded, color: Colors.amber, size: 20), const SizedBox(width: 4), Text('${courtData['rating']} (${courtData['reviews']})', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold))])]))),
        ]))
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;
  late Future<UserProfile?> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.isLoggedIn && authService.userId != null) {
      _userProfileFuture = ApiService().getUserProfile(authService.userId!, token: authService.token);
    } else {
      _userProfileFuture = Future.value(null);
    }
  }

  void _onItemTapped(int index) {
    if (index == _bottomNavIndex) return;
    switch (index) {
      case 0:
        setState(() => _bottomNavIndex = 0);
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/create-reservation');
        break;
      case 3:
        context.go('/chats');
        break;
      case 4:
        final authService = Provider.of<AuthService>(context, listen: false);
        context.go('/profile/${authService.userId}');
        break;
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('Cerrar Sesión', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('¿Estás seguro?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(dialogContext).pop()),
          TextButton(
            child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              authService.logout();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: _buildAppBar(authService),
          body: _buildBody(authService),
          bottomNavigationBar: _buildFloatingBottomNavBar(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(AuthService authService) {
    if (authService.profileExists != true) {
      return AppBar(backgroundColor: const Color(0xFFF8F9FA), elevation: 0);
    }

    return AppBar(
      flexibleSpace: FutureBuilder<UserProfile?>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          String displayName = 'Bienvenido';
          String? photoUrl;

          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
            displayName = 'Hola, ${snapshot.data!.fullName.split(' ').first}';
            photoUrl = snapshot.data!.profilePictureUrl;
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(displayName, style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                  PopupMenuButton<String>(
                    onSelected: (value) => value == 'logout' ? _showLogoutConfirmationDialog(context) : context.go('/profile/${authService.userId}'),
                    offset: const Offset(0, 50),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'profile',
                        child: ListTile(leading: Icon(Icons.person_outline), title: Text('Mi Perfil')),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'logout',
                        child: ListTile(leading: Icon(Icons.logout, color: Colors.red), title: Text('Cerrar Sesión', style: TextStyle(color: Colors.red))),
                      ),
                    ],
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                          ? NetworkImage(photoUrl)
                          : NetworkImage("https://i.pravatar.cc/150?u=${authService.userId}") as ImageProvider,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      elevation: 0,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
    );
  }


  Widget _buildBody(AuthService authService) {
    final profileExists = authService.profileExists;

    if (profileExists == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (profileExists == false) {
      return _buildCreateProfilePrompt(context);
    } else {
      return _buildMainContent();
    }
  }

  Widget _buildCreateProfilePrompt(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.assignment_ind_outlined, size: 80, color: Color(0xFF185a9d)),
              const SizedBox(height: 24),
              Text(
                '¡Casi listo!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Para disfrutar de todas las funciones y conectar con otros jugadores, necesitas completar tu perfil.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Crear Mi Perfil'),
                onPressed: () => context.go('/create-profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF185a9d),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SectionHeader(title: 'Torneos Destacados', icon: Icons.emoji_events_outlined),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tournaments.length,
            padding: const EdgeInsets.only(right: 16),
            itemBuilder: (context, index) => TournamentCard(tournamentData: tournaments[index]),
          ),
        ),
        const SectionHeader(title: 'Actividad Reciente', icon: Icons.whatshot_outlined),
        ...teamRequests.map((request) => TeamRequestCard(requestData: request)),
        ...courts.map((court) => CourtCard(courtData: court)),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildFloatingBottomNavBar() {
    return SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 2)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_filled, 0, label: 'Inicio'),
              _buildNavItem(Icons.search, 1, label: 'Buscar'),
              _buildMiddleNavItem(),
              _buildNavItem(Icons.chat_bubble_outline_rounded, 3, label: 'Chats'),
              _buildNavItem(Icons.person_outline_rounded, 4, label: 'Perfil'),
            ],
          ),
        ),
      );
  }

   Widget _buildNavItem(IconData icon, int index, {String? label}) {
    final isSelected = _bottomNavIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF185a9d) : Colors.grey[600], size: 26),
            if (label != null) const SizedBox(height: 4),
            if (label != null) Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? const Color(0xFF185a9d) : Colors.grey[600])),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMiddleNavItem() {
    return InkWell(
      onTap: () => _onItemTapped(2),
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF185a9d),
          boxShadow: [BoxShadow(color: Color(0xFF185a9d), blurRadius: 10, spreadRadius: -2)]
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
