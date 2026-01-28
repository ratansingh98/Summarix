import 'package:flutter/material.dart';

class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE9F5FB), Color(0xFFF7FBFD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -60,
          child: _GlowOrb(
            size: 200,
            colors: [
              const Color(0xFF9BD5EE).withOpacity(0.6),
              const Color(0xFFBDE9F8).withOpacity(0.1),
            ],
          ),
        ),
        Positioned(
          bottom: -120,
          left: -80,
          child: _GlowOrb(
            size: 240,
            colors: [
              const Color(0xFF8BC3E0).withOpacity(0.4),
              const Color(0xFFE3F4FB).withOpacity(0.1),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: colors,
        ),
      ),
    );
  }
}
