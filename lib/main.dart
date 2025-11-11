import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myapp/court_details_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'create_reservation_screen.dart';
import 'profile_screen.dart';
import 'owner_home_screen.dart';
import 'manage_court_screen.dart';

void main() async {
  await initializeDateFormatting('es_ES', null);
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterScreen();
          },
        ),
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: 'create-reservation',
          builder: (BuildContext context, GoRouterState state) {
            return const CreateReservationScreen();
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
        ),
        GoRoute(
          path: 'owner-home',
          builder: (BuildContext context, GoRouterState state) {
            return const OwnerHomeScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'manage-court',
              builder: (BuildContext context, GoRouterState state) {
                final Court? court = state.extra as Court?;
                return ManageCourtScreen(court: court);
              },
            ),
            GoRoute(
              path: 'court-details',
              builder: (BuildContext context, GoRouterState state) {
                // --- INICIO DE LA CORRECCIÓN ---
                final Court? court = state.extra as Court?;

                // Si los datos de la cancha no existen, muestra una pantalla de error.
                if (court == null) {
                  return Scaffold(
                    appBar: AppBar(title: const Text('Error')),
                    body: const Center(
                      child: Text('No se pudo cargar la información de la cancha.'),
                    ),
                  );
                }

                // Si los datos existen, muestra la pantalla de detalles.
                return CourtDetailsScreen(court: court);
                // --- FIN DE LA CORRECCIÓN ---
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: const Color(0xFF007BFF), // Un azul más moderno
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
