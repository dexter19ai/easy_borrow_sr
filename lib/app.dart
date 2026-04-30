import 'package:flutter/material.dart';

import 'screens/auth/auth_wrapper.dart';
import 'theme/app_theme.dart';

class EasyBorrowApp extends StatelessWidget {
  const EasyBorrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyBorrow San Ramon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AuthWrapper(),
    );
  }
}
