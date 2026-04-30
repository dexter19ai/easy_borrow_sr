import 'package:flutter/material.dart';

class HoverScale extends StatefulWidget {
  const HoverScale({
    super.key,
    required this.child,
    this.scaleOnHover = 1.02,
    this.duration = const Duration(milliseconds: 140),
  });

  final Widget child;
  final double scaleOnHover;
  final Duration duration;

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? widget.scaleOnHover : 1,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
