import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AuthGradientBackground extends StatelessWidget {
  const AuthGradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.pageGradient),
      child: Stack(
        children: [
          const Positioned(
            top: -80,
            right: -40,
            child: _BackdropCircle(
              size: 220,
              color: Color(0x332E7CCF),
            ),
          ),
          const Positioned(
            bottom: -70,
            left: -30,
            child: _BackdropCircle(
              size: 180,
              color: Color(0x2230B6A6),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _BackdropCircle extends StatelessWidget {
  const _BackdropCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
