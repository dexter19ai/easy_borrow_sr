import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/auth_gradient_background.dart';
import '../../widgets/hover_scale.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onGoToRegister,
  });

  final String? Function({
    required String username,
    required String password,
  }) onLogin;
  final VoidCallback onGoToRegister;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  String? _loginError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String? error = widget.onLogin(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() {
      _loginError = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthGradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                      decoration: const BoxDecoration(
                        gradient: AppColors.heroGradient,
                      ),
                      child: const Column(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.handshake_outlined,
                              size: 36,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'EasyBorrow San Ramon',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Borrow barangay equipment in a few quick steps.',
                            style: TextStyle(
                              color: Color(0xFFE6F2FF),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Username is required.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_showPassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _showPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Password is required.';
                                }
                                return null;
                              },
                            ),
                            if (_loginError != null) ...[
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _loginError!,
                                  style: const TextStyle(
                                    color: AppColors.danger,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 22),
                            HoverScale(
                              child: ElevatedButton.icon(
                                onPressed: _submitLogin,
                                icon: const Icon(Icons.login_rounded),
                                label: const Text('Login'),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: widget.onGoToRegister,
                              child: const Text('No account yet? Register here'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
