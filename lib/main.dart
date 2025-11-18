import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'create_reservation_screen.dart';
import 'profile_screen.dart';
import 'chat_list_screen.dart';
import 'chat_screen.dart';
import 'sports_preferences_screen.dart';
import 'team_stats_screen.dart';

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
          routes: <RouteBase>[
            GoRoute(
              path: 'chats',
              builder: (BuildContext context, GoRouterState state) {
                return const ChatListScreen();
              },
              routes: <RouteBase>[
                GoRoute(
                  path: ':userId',
                  builder: (BuildContext context, GoRouterState state) {
                    final userId = state.pathParameters['userId'];
                    if (userId == null || userId.isEmpty) {
                      return Scaffold(
                        appBar: AppBar(title: const Text('Error de Navegación')),
                        body: const Center(child: Text('El ID del chat no es válido.')),
                      );
                    }
                    final extra = state.extra as Map<String, dynamic>?;
                    final userName = extra?['userName'] as String? ?? 'Usuario';
                    return ChatScreen(otherUserName: userName);
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'team-stats',
              builder: (BuildContext context, GoRouterState state) {
                return const TeamStatsScreen();
              },
            ),
          ],
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
          routes: <RouteBase>[
            GoRoute(
              path: 'preferences',
              builder: (BuildContext context, GoRouterState state) {
                return const SportsPreferencesScreen();
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
        primaryColor: const Color(0xFF007BFF),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
