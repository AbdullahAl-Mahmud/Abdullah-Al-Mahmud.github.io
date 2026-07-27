import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/app_constants.dart';
import '../widgets/app_logo.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
    _timer = Timer(const Duration(seconds: 2), _openApp);
  }

  void _openApp() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (_, animation, secondaryAnimation) =>
            const MainNavigationScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE7F7EF), Color(0xFFE8F0FF), Color(0xFFF8FBFA)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -100,
              right: -90,
              child: _DecorativeCircle(size: 310, color: Color(0x22138A5B)),
            ),
            const Positioned(
              bottom: -120,
              left: -100,
              child: _DecorativeCircle(size: 360, color: Color(0x222374E1)),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _scale,
                      child: const AppLogo(size: 96, showText: false),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: const Color(0xFF0F3D2E),
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppConstants.tagline,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF426256),
                          ),
                    ),
                    const SizedBox(height: 36),
                    const SizedBox(
                      width: 34,
                      height: 34,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Connecting to campus transport…',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF61756D),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
