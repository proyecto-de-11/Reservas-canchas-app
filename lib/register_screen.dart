
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

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

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );

    _controller.forward();

    _nameFocusNode.addListener(() => setState(() {}));
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
    _confirmPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          _buildTopBluePart(size),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomWhiteCard(size),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBluePart(Size size) {
    return Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFF0056B3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Icon(
              Icons.person_add_alt_1_rounded,
              size: 80,
              color: Colors.white.withOpacity(0.9),
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Crear Cuenta',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomWhiteCard(Size size) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: size.height * 0.7,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    focusNode: _nameFocusNode,
                    icon: Icons.person_outline,
                    hint: 'Nombre Completo',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    focusNode: _emailFocusNode,
                    icon: Icons.alternate_email,
                    hint: 'Correo Electrónico',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    focusNode: _passwordFocusNode,
                    icon: Icons.lock_outline,
                    hint: 'Contraseña',
                    isPassword: true,
                    obscureText: _obscurePassword,
                    toggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    focusNode: _confirmPasswordFocusNode,
                    icon: Icons.lock_outline,
                    hint: 'Confirmar Contraseña',
                    isPassword: true,
                    obscureText: _obscureConfirmPassword,
                    toggleObscure: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  const SizedBox(height: 32),
                  _buildRegisterButton(),
                  const SizedBox(height: 24),
                  _buildLoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required FocusNode focusNode,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleObscure,
  }) {
    final bool hasFocus = focusNode.hasFocus;
    return TextFormField(
      focusNode: focusNode,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
        prefixIcon: Icon(
          icon,
          color: hasFocus ? const Color(0xFF007BFF) : Colors.grey[500],
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[500],
                ),
                onPressed: toggleObscure,
              )
            : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF007BFF), width: 1.5),
        ),
      ),
      style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFF0056B3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007BFF).withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            // Register logic
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(
          'Registrarse',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: () => context.go('/'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "¿Ya tienes una cuenta? ",
            style: GoogleFonts.poppins(color: Colors.grey[600]),
          ),
          Text(
            'Inicia Sesión',
            style: GoogleFonts.poppins(
              color: const Color(0xFF007BFF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
