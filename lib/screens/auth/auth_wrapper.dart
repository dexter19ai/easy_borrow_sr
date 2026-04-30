import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../dashboard/main_dashboard.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;
  bool _showLogin = true;

  String? _handleLogin({
    required String username,
    required String password,
  }) {
    final String? loginError = AppState.login(
      username: username,
      password: password,
    );

    if (loginError == null) {
      setState(() {
        _isLoggedIn = true;
      });
    }

    return loginError;
  }

  String? _handleRegister({
    required String fullName,
    required String address,
    required String contactNumber,
    required String username,
    required String password,
  }) {
    final String? registerError = AppState.registerResident(
      fullName: fullName,
      address: address,
      contactNumber: contactNumber,
      username: username,
      password: password,
    );

    if (registerError == null) {
      setState(() {
        _showLogin = true;
      });
    }

    return registerError;
  }

  void _handleLogout() {
    AppState.logout();
    setState(() {
      _isLoggedIn = false;
      _showLogin = true;
    });
  }

  void _showRegister() {
    setState(() {
      _showLogin = false;
    });
  }

  void _showLoginScreen() {
    setState(() {
      _showLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return MainDashboard(onLogout: _handleLogout);
    }

    if (_showLogin) {
      return LoginScreen(
        onLogin: _handleLogin,
        onGoToRegister: _showRegister,
      );
    }

    return RegisterScreen(
      onRegister: _handleRegister,
      onGoToLogin: _showLoginScreen,
    );
  }
}
