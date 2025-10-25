import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_constants.dart';
import '../../core/animations/waveform_animation.dart';
import 'onboarding_screen.dart';
import 'dart:async'; // Added for Timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _startAnimations();

    // Fallback timer to ensure navigation happens
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _navigateToOnboarding();
      }
    });
  }

  void _startAnimations() async {
    try {
      // Start all animations simultaneously
      _logoController.forward();
      _textController.forward();
      _pulseController.repeat(reverse: true);

      // Wait for a fixed delay and navigate regardless of animation completion
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        _navigateToOnboarding();
      }
    } catch (e) {
      // If there's any error, still navigate to onboarding
      debugPrint('Animation error: $e');
      if (mounted) {
        _navigateToOnboarding();
      }
    }
  }

  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.volume_up,
                size: 60,
                color: theme.colorScheme.onPrimary,
              ),
            )
                .animate(controller: _logoController)
                .scale(
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(1.0, 1.0),
                  curve: Curves.elasticOut,
                )
                .then()
                .shimmer(duration: const Duration(seconds: 2)),

            const SizedBox(height: 40),

            // App Name Animation
            Text(
              AppConstants.appName,
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            )
                .animate(controller: _textController)
                .fadeIn(duration: const Duration(milliseconds: 800))
                .slideY(begin: 0.3, end: 0.0),

            const SizedBox(height: 16),

            // Tagline Animation
            Text(
              'The World\'s Largest Real-Time Urban Noise Map',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            )
                .animate(controller: _textController)
                .fadeIn(delay: const Duration(milliseconds: 400))
                .slideY(begin: 0.3, end: 0.0),

            const SizedBox(height: 60),

            // Loading Indicator
            const SizedBox(
              width: 40,
              height: 40,
              child: WaveformAnimation(isActive: true, amplitude: 0.7, color: AppConstants.primaryTeal, height: 24, waveCount: 7, duration: Duration(milliseconds: 1200),),
            )
                .animate(controller: _pulseController)
                .scale(
                    begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2))
                .then()
                .fadeIn(duration: const Duration(milliseconds: 500)),
          ],
        ),
      ),
    );
  }
}
