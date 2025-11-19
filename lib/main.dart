import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/login_screen.dart';
import 'package:myapp/register_screen.dart';
import 'package:myapp/screens/search_users_screen.dart';
import 'package:myapp/services/auth_service.dart'; // Importar AuthService

void main() async { // Convertir main a async
  // Asegurarse de que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Intentar cargar el token de autenticación al iniciar la app
  await AuthService.tryLoadToken();

  runApp(const MyApp());
}

// Determina la ruta inicial basada en si el usuario está autenticado
final String initialRoute = AuthService.token != null ? '/home' : '/';

final GoRouter _router = GoRouter(
  initialLocation: initialRoute,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'chats',
          builder: (context, state) => const Center(child: Text('Chats Screen')),
        ),
      ],
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/create-reservation',
      builder: (context, state) => const Center(child: Text('Create Reservation Screen')),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const Center(child: Text('Profile Screen')),
    ),
    GoRoute(
      path: '/search', // Nueva ruta para la pantalla de búsqueda
      builder: (context, state) => const SearchUsersScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: _router,
    );
  }
}
