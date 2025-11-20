import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

import 'package:myapp/home_screen.dart';
import 'package:myapp/login_screen.dart';
import 'package:myapp/screens/register_screen.dart'; // Importación corregida
import 'package:myapp/screens/create_profile_screen.dart';
import 'package:myapp/screens/search_users_screen.dart';
import 'package:myapp/screens/chat_list_screen.dart';
import 'package:myapp/screens/chat_screen.dart';
import 'package:myapp/profile_screen.dart';
import 'package:myapp/services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyAppWrapper());
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final router = GoRouter(
      refreshListenable: authService,
      initialLocation: '/login', 
      
      redirect: (context, state) {
        final isLoggedIn = authService.isLoggedIn;
        final location = state.matchedLocation;

        developer.log(
          'GoRouter Check: Logueado=$isLoggedIn, Destino solicitado=${state.uri}, Ubicación actual=$location',
          name: 'GoRouter.Redirect',
        );

        final isPublicRoute = location == '/login' || location == '/register';

        if (!isLoggedIn && !isPublicRoute) {
          developer.log('Decisión: NO Logueado y en ruta privada. REDIRIGIENDO a /login', name: 'GoRouter.Redirect');
          return '/login';
        }

        if (isLoggedIn && isPublicRoute) {
            developer.log('Decisión: SÍ Logueado y en ruta pública. REDIRIGIENDO a /home', name: 'GoRouter.Redirect');
            return '/home';
        }

        developer.log('Decisión: Sin redirección global. PERMITIENDO NAVEGACIÓN a $location', name: 'GoRouter.Redirect');
        return null; 
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/create-profile',
          builder: (context, state) => const CreateProfileScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchUsersScreen(),
        ),
        GoRoute(
          path: '/create-reservation',
          builder: (context, state) => const Center(child: Text('Create Reservation Screen')),
        ),
        GoRoute(
            path: '/profile/:userId',
            builder: (context, state) {
              final userId = state.pathParameters['userId']!;
              return ProfileScreen(userId: userId);
            }),
        GoRoute(
          path: '/chats',
          builder: (context, state) => const ChatListScreen(),
        ),
        GoRoute(
            path: '/chat/:userId',
            builder: (context, state) {
              final userId = state.pathParameters['userId']!;
              return ChatScreen(userId: userId);
            }),
      ],
    );

    return MaterialApp.router(
      title: 'Cancha-Now',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
