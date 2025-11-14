import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _obscureText = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  _buildHeader(),
                  const SizedBox(height: 50),
                  _buildTextField(
                    focusNode: _emailFocusNode,
                    icon: Icons.alternate_email,
                    hint: 'Usuario / Correo',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    focusNode: _passwordFocusNode,
                    icon: Icons.lock_outline,
                    hint: 'Contraseña',
                    isPassword: true,
                  ),
                  const SizedBox(height: 40),
                  _buildLoginButton(),
                  const SizedBox(height: 16),
                  _buildOwnerLoginButton(),
                  const SizedBox(height: 30),
                  _buildRegisterLink(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.sports_soccer,
          size: 80,
          color: Colors.white.withAlpha(230),
          shadows: [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        const SizedBox(height: 16),
        Text(
          'Bienvenido',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
            shadows: [Shadow(color: Colors.black.withAlpha(64), blurRadius: 8, offset: const Offset(0, 4))],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required FocusNode focusNode,
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    final bool hasFocus = focusNode.hasFocus;
    return TextField(
      focusNode: focusNode,
      obscureText: isPassword ? _obscureText : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.white70),
        prefixIcon: Icon(icon, color: hasFocus ? Colors.white : Colors.white70),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () => context.go('/home'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF185a9d),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      child: Text(
        'Iniciar Sesión',
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildOwnerLoginButton() {
    return OutlinedButton.icon(
      onPressed: () => context.go('/owner-home'),
      icon: const Icon(Icons.business_center_outlined),
      label: const Text('Soy Propietario'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return GestureDetector(
      onTap: () => context.go('/register'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "¿No tienes una cuenta? ",
            style: GoogleFonts.poppins(color: Colors.white70),
          ),
          Text(
            'Regístrate',
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
