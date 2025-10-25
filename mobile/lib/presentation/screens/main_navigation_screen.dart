import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hush_sense/presentation/screens/capture_screen.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/haptic_feedback.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'rewards_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 2; // Start with Measure screen as it's the main feature
  late AnimationController _indicatorController;
  late Animation<double> _indicatorAnimation;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MapScreen(),
    const MeasureScreen(),
    const RewardsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _indicatorAnimation = Tween<double>(
      begin: _currentIndex.toDouble(),
      end: _currentIndex.toDouble(),
    ).animate(CurvedAnimation(
      parent: _indicatorController,
      curve: AppConstants.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 12),
        child: _FloatingNavBar(
          currentIndex: _currentIndex,
          indicatorAnimation: _indicatorAnimation,
          onTap: _setIndex,
        ),
      ),
    );
  }

  void _setIndex(int index) {
    if (index == _currentIndex) return;
    
    HushHaptics.lightTap();
    
    _indicatorAnimation = Tween<double>(
      begin: _currentIndex.toDouble(),
      end: index.toDouble(),
    ).animate(CurvedAnimation(
      parent: _indicatorController,
      curve: AppConstants.easeInOutCubic,
    ));
    
    setState(() {
      _currentIndex = index;
    });
    
    _indicatorController.forward(from: 0.0);
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final Animation<double> indicatorAnimation;
  final Function(int) onTap;

  const _FloatingNavBar({
    required this.currentIndex,
    required this.indicatorAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppConstants.deepBlue.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppConstants.deepBlue.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Animated indicator
                AnimatedBuilder(
                  animation: indicatorAnimation,
                  builder: (context, child) {
                    return Positioned(
                      left: _getIndicatorPosition(indicatorAnimation.value, constraints.maxWidth),
                      top: 12,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppConstants.primaryTeal,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.primaryTeal.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Navigation items - centered vertically
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _NavItem(
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home,
                        label: 'Home',
                        isActive: currentIndex == 0,
                        onTap: () => onTap(0),
                      ),
                      _NavItem(
                        icon: Icons.map_outlined,
                        activeIcon: Icons.map,
                        label: 'Map',
                        isActive: currentIndex == 1,
                        onTap: () => onTap(1),
                      ),
                      _NavItem(
                        icon: Icons.mic_outlined,
                        activeIcon: Icons.mic,
                        label: 'Measure',
                        isActive: currentIndex == 2,
                        onTap: () => onTap(2),
                      ),
                      _NavItem(
                        icon: Icons.card_giftcard_outlined,
                        activeIcon: Icons.card_giftcard,
                        label: 'Rewards',
                        isActive: currentIndex == 3,
                        onTap: () => onTap(3),
                      ),
                      _NavItem(
                        icon: Icons.person_outline,
                        activeIcon: Icons.person,
                        label: 'Profile',
                        isActive: currentIndex == 4,
                        onTap: () => onTap(4),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  double _getIndicatorPosition(double animationValue, double containerWidth) {
    // Calculate accurate position based on actual container width
    const double horizontalPadding = 20.0;
    const double itemWidth = 56.0;
    
    // Available width for items after padding
    final double availableWidth = containerWidth - (horizontalPadding * 2);
    
    // Space between items (4 gaps for 5 items)
    final double spaceBetweenItems = (availableWidth - (5 * itemWidth)) / 4;
    
    // Calculate position for each item
    final double itemPosition = horizontalPadding + (animationValue * (itemWidth + spaceBetweenItems));
    
    return itemPosition;
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                size: 24,
                color: isActive 
                    ? AppConstants.surfaceColor 
                    : AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive 
                    ? AppConstants.surfaceColor 
                    : AppConstants.textSecondary,
                fontFamily: 'Funnel Sans',
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
