import 'dart:math';
import 'package:flutter/material.dart';
import '../services/translations.dart';
import 'airport_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _logoScale;
  late Animation<Offset> _slideUp;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
    ));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1900), () {
      if (mounted && !_navigated) _navigateToHome();
    });
  }

  void _navigateToHome() {
    if (_navigated) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AirportListScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationService.instance;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _AnimatedGradientBackground(controller: _controller),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withAlpha(150),
                ],
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeIn,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withAlpha(50),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 110,
                      height: 110,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SlideTransition(
                  position: _slideUp,
                  child: Column(
                    children: [
                      Text(
                        t.tr('flightInfo'),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.tr('iranAirports'),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withAlpha(210),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                SlideTransition(
                  position: _slideUp,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _ShimmerButton(
                      label: t.tr('enterApp'),
                      onPressed: _navigateToHome,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    '${t.tr('version')} 1.1.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha(140),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedGradientBackground extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedGradientBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  const Color(0xFF0D47A1),
                  const Color(0xFF1A237E),
                  sin(controller.value * pi * 0.5).abs() % 1,
                )!,
                Color.lerp(
                  const Color(0xFF1565C0),
                  const Color(0xFF283593),
                  cos(controller.value * pi * 0.5).abs() % 1,
                )!,
                Color.lerp(
                  const Color(0xFF1976D2),
                  const Color(0xFF0D47A1),
                  (controller.value * 0.7) % 1,
                )!,
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _ShimmerButton({required this.label, required this.onPressed});

  @override
  State<_ShimmerButton> createState() => _ShimmerButtonState();
}

class _ShimmerButtonState extends State<_ShimmerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.white.withAlpha(180),
                Colors.white,
                Colors.white.withAlpha(180),
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
              begin: Alignment(-1 + _controller.value * 2, 0),
              end: Alignment(1 + _controller.value * 2, 0),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: child,
        );
      },
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white.withAlpha(45),
          foregroundColor: Colors.white,
          elevation: 0,
          side: BorderSide(color: Colors.white.withAlpha(130), width: 1.5),
        ),
        child: Text(
          widget.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
