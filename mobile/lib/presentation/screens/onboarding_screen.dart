import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/premium_button.dart';
import '../../core/animations/waveform_animation.dart';
import 'main_navigation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      title: 'Welcome to HushSense',
      subtitle:
          'Join the world\'s largest decentralized noise mapping community',
      description:
          'Help create a quieter, healthier world by contributing to our global noise database. Your smartphone becomes a powerful sensor for positive change.',
      icon: Icons.hearing,
      color: AppConstants.primaryColor,
      gradient: [AppConstants.primaryColor, AppConstants.primaryDarkColor],
    ),
    const OnboardingPage(
      title: 'Measure & Earn',
      subtitle: 'Turn your smartphone into a noise sensor',
      description:
          'Record noise levels in your area and earn HUSH tokens for your contributions. Every measurement helps build a better, quieter world.',
      icon: Icons.mic,
      color: AppConstants.secondaryColor,
      gradient: [AppConstants.secondaryColor, AppConstants.successColor],
    ),
    const OnboardingPage(
      title: 'Discover Quiet Places',
      subtitle: 'Find the perfect spot for work or relaxation',
      description:
          'Explore our interactive noise map to discover quiet venues and peaceful locations. Make informed decisions about where to spend your time.',
      icon: Icons.map,
      color: AppConstants.accentColor,
      gradient: [AppConstants.accentColor, AppConstants.warningColor],
    ),
    const OnboardingPage(
      title: 'Your Privacy Matters',
      subtitle: 'Honest Data Approach',
      description:
          'We only collect decibel levels, never audio content. You control your data completely with our privacy-first, transparent approach.',
      icon: Icons.security,
      color: AppConstants.primaryDarkColor,
      gradient: [AppConstants.primaryDarkColor, AppConstants.primaryColor],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: AppConstants.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: AppConstants.easeInOutCubic,
      );
    }
  }

  void _completeOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavigationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppConstants.surfaceColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingL),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  style: TextButton.styleFrom(
                    foregroundColor: AppConstants.textSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM,
                      vertical: AppConstants.paddingS,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            // Page Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _OnboardingPageWidget(
                    page: page,
                    isActive: _currentPage == index,
                    theme: theme,
                  );
                },
              ),
            ),

            // Page Indicators
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _PageIndicator(
                    isActive: _currentPage == index,
                    color: _pages[index].color,
                    theme: theme,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: Row(
                children: [
                  // Previous Button
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConstants.primaryColor,
                          side: const BorderSide(color: AppConstants.primaryColor),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.paddingM),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusXL),
                          ),
                        ),
                        child: Text(
                          'Previous',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                      ),
                    ),

                  if (_currentPage > 0)
                    const SizedBox(width: AppConstants.paddingM),

                  // Next/Get Started Button
                  Expanded(
                    flex: _currentPage > 0 ? 1 : 1,
                    child: PremiumButton(
                      text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                      onPressed: _nextPage,
                      style: PremiumButtonStyle.primary,
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingM),
          ],
        ),
      ),
    ).animate(controller: _fadeController).fadeIn();
  }
}

class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final bool isActive;
  final ThemeData theme;

  const _OnboardingPageWidget({
    required this.page,
    required this.isActive,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with gradient background
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  page.color.withValues(alpha: 0.1),
                  page.color.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: page.color.withValues(alpha: 0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: AppConstants.iconSizeXL,
              color: page.color,
            ),
          )
              .animate(target: isActive ? 1 : 0)
              .scale(
                duration: const Duration(milliseconds: 400),
                curve: AppConstants.gentleSpring,
              )
              .then()
              .shimmer(duration: const Duration(seconds: 2)),

          // Waveform animation above title
          const SizedBox(height: 28),
          WaveformAnimation(
            isActive: isActive,
            amplitude: 0.7,
            color: page.color,
            height: 28,
            waveCount: 7,
            duration: const Duration(milliseconds: 1600),
          ).animate(target: isActive ? 1 : 0).fadeIn(duration: const Duration(milliseconds: 600)),

          const SizedBox(height: AppConstants.paddingL),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
              fontSize: 28,
            ),
          )
              .animate(target: isActive ? 1 : 0)
              .fadeIn(delay: const Duration(milliseconds: 200))
              .slideY(begin: 0.3, duration: const Duration(milliseconds: 400)),

          const SizedBox(height: AppConstants.paddingM),

          // Subtitle
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: page.color,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          )
              .animate(target: isActive ? 1 : 0)
              .fadeIn(delay: const Duration(milliseconds: 400))
              .slideY(begin: 0.3, duration: const Duration(milliseconds: 400)),

          // Sound reduction motif (horizontal fading gradient)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              height: 6,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    page.color.withValues(alpha: 0.0),
                    page.color.withValues(alpha: 0.25),
                    page.color.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ).animate(target: isActive ? 1 : 0).fadeIn(duration: const Duration(milliseconds: 700)),

          const SizedBox(height: AppConstants.paddingL),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppConstants.textSecondary,
              height: 1.6,
              fontSize: 16,
            ),
          )
              .animate(target: isActive ? 1 : 0)
              .fadeIn(delay: const Duration(milliseconds: 600))
              .slideY(begin: 0.3, duration: const Duration(milliseconds: 400)),
        ],
            ),
          ),
        ),
      );
  }
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;
  final Color color;
  final ThemeData theme;

  const _PageIndicator({
    required this.isActive,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingS),
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? color : AppConstants.textTertiary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradient,
  });
}
