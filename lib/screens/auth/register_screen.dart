import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/auth_gradient_background.dart';
import '../../widgets/hover_scale.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onGoToLogin,
  });

  final String? Function({
    required String fullName,
    required String address,
    required String contactNumber,
    required String username,
    required String password,
  }) onRegister;
  final VoidCallback onGoToLogin;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;
  String? _registerError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String? registerError = widget.onRegister(
      fullName: _fullNameController.text.trim(),
      address: _addressController.text.trim(),
      contactNumber: _contactController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() {
      _registerError = registerError;
    });

    if (registerError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.success,
          content: Text('Registration successful. You can now log in.'),
        ),
      );
    }
  }

  String? _requiredField(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }
    return null;
  }

  String? _contactValidator(String? value) {
    final String? required = _requiredField(value, 'Contact number');
    if (required != null) {
      return required;
    }

    final String digitsOnly = value!.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10) {
      return 'Please enter a valid contact number.';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    final String? required = _requiredField(value, 'Password');
    if (required != null) {
      return required;
    }

    final String password = value!.trim();
    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password should include at least one uppercase letter.';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password should include at least one lowercase letter.';
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return 'Password should include at least one number.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthGradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
                      decoration: const BoxDecoration(
                        gradient: AppColors.heroGradient,
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.person_add_alt_1, color: Colors.white, size: 42),
                          SizedBox(height: 8),
                          Text(
                            'Resident Registration',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Create your EasyBorrow resident account.',
                            style: TextStyle(color: Color(0xFFE6F2FF)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _fullNameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.badge_outlined),
                              ),
                              validator: (value) => _requiredField(value, 'Full name'),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Address (Optional)',
                                hintText: 'Purok/Street',
                                helperText: 'Optional but recommended',
                                prefixIcon: Icon(Icons.home_outlined),
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _contactController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: 'Contact Number',
                                prefixIcon: Icon(Icons.call_outlined),
                              ),
                              validator: _contactValidator,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) => _requiredField(value, 'Username'),
                            ),
                            const SizedBox(height: 14),
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
                              validator: _passwordValidator,
                            ),
                            if (_registerError != null) ...[
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _registerError!,
                                  style: const TextStyle(
                                    color: AppColors.danger,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            HoverScale(
                              child: ElevatedButton.icon(
                                onPressed: _submitRegistration,
                                icon: const Icon(Icons.check_circle_outline),
                                label: const Text('Create Account'),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: widget.onGoToLogin,
                              child: const Text('Already registered? Go to Login'),
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
