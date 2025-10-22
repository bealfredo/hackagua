import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';
import '../onboarding/onboarding_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Palette inspired by the provided mock
    const Color brand = Color(0xFF0F172A); // dark navy for primary button/text
    const Color accent = Color(0xFF38BDF8); // light blue for logo aura
    const Color inputBorder = Color(0xFFE5E7EB);
    const Color hint = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth < 600
                ? constraints.maxWidth - 32
                : 480.0;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 24,
                          offset: Offset(0, 16),
                        )
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo with subtle glow
                          Center(
                            child: Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [accent.withOpacity(.25), Colors.white],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: accent.withOpacity(.35),
                                    blurRadius: 30,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: const CircleAvatar(
                                backgroundColor: Color(0xFFEFF6FF),
                                child: Icon(Icons.water_drop, color: brand, size: 36),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Welcome to Escuta d'Água",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: brand,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Sign in to continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.2,
                              color: hint,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Email
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: brand,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Informe seu email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'you@example.com',
                              prefixIcon: const Icon(Icons.mail_outline, color: hint),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: inputBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: brand, width: 1.2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.redAccent),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: brand,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe sua senha';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_outline, color: hint),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                  color: hint,
                                ),
                                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: inputBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: brand, width: 1.2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.redAccent),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // TODO: Implementar recuperação de senha
                              },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(color: hint, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Sign in button
                          SizedBox(
                            height: 48,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: brand,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: authProvider.isLoading
                                  ? null
                                  : () async {
                                      if (!_formKey.currentState!.validate()) return;

                                      final success = await authProvider.login(
                                        _emailController.text.trim(),
                                        _passwordController.text,
                                      );

                                      if (!success && mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              authProvider.errorMessage ?? 'Erro ao fazer login',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                      if (success && mounted) {
                                        final userId = authProvider.user?.id;
                                        if (userId != null) {
                                          final box = await Hive.openBox('auth_box');
                                          final seen = box.get('onboarding_seen_$userId') == true;
                                          final next = seen
                                              ? const HomeScreen()
                                              : OnboardingScreen(userId: userId);

                                          // Replace whole stack so back button doesn't return to login
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(builder: (_) => next),
                                            (_) => false,
                                          );
                                        }
                                      }
                                    },
                              child: authProvider.isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                    )
                                  : const Text(
                                      'Sign in',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Sign up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Need an account? ',
                                style: TextStyle(color: hint, fontWeight: FontWeight.w700),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Navegar para cadastro
                                },
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(color: brand, fontWeight: FontWeight.w800),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
