import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:myapp/home_screen.dart';
import 'package:myapp/login_screen.dart';
import 'package:myapp/register_screen.dart';
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
        final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

        if (!isLoggedIn && !isLoggingIn) {
          return '/login';
        }

        if (isLoggedIn && isLoggingIn) {
          return '/home';
        }

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
