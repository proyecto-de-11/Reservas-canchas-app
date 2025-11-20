import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// Importaciones corregidas según la estructura real del proyecto.
import 'package:myapp/login_screen.dart';             // En la raíz de lib/
import 'package:myapp/home_screen.dart';             // En la raíz de lib/
import 'package:myapp/screens/create_profile_screen.dart'; // En lib/screens/
import 'package:myapp/screens/profile_screen.dart';        // En lib/screens/
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: Consumer<AuthService>(
        builder: (context, authService, child) {
          final router = _buildRouter(authService);
          return MaterialApp.router(
            title: 'SportConnect',
            debugShowCheckedModeBanner: false,
            theme: _buildThemeData(context),
            routerConfig: router,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('es', 'ES'),
            ],
          );
        },
      ),
    );
  }

  GoRouter _buildRouter(AuthService authService) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: authService,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => authService.isLoggedIn ? const HomeScreen() : const LoginScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/create-profile',
          builder: (context, state) => const CreateProfileScreen(),
        ),
        GoRoute(
          path: '/profile/:userId',
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return ProfileScreen(userId: userId);
          },
        ),
      ],
      redirect: (context, state) {
        final isLoggedIn = authService.isLoggedIn;
        final isTryingToLogin = state.matchedLocation == '/login' || state.matchedLocation == '/';

        if (!isLoggedIn && !isTryingToLogin) {
          return '/'; 
        } else if (isLoggedIn && isTryingToLogin) {
          return '/home';
        } 
        
        return null;
      },
    );
  }

  ThemeData _buildThemeData(BuildContext context) {
    const primaryColor = Color(0xFF185a9d);
    final baseTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
