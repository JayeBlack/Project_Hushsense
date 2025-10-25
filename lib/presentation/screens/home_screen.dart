import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../widgets/stats_card.dart';
import '../widgets/quick_action_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for each section
    _fadeAnimations = List.generate(6, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.6 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _slideAnimations = List.generate(6, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.6 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    // Start animation after a brief delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedSection(int index, Widget child) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildAnimatedSection(0, _buildHeader(context)),
              const SizedBox(height: AppConstants.paddingXL),
              
              // Stats Overview
              _buildAnimatedSection(1, _buildStatsSection()),
              const SizedBox(height: AppConstants.paddingXL),
              
              // Quick Actions
              _buildAnimatedSection(2, _buildQuickActions()),
              const SizedBox(height: AppConstants.paddingXL),
              
              // Recent Activity
              _buildAnimatedSection(3, _buildRecentActivity(context)),
              const SizedBox(height: AppConstants.paddingL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryTeal.withValues(alpha: 0.05),
            AppConstants.primaryColor.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppConstants.primaryTeal.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppConstants.textSecondary,
                        fontFamily: 'Funnel Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          AppConstants.primaryTeal,
                          AppConstants.primaryColor,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'Sound Scout',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Funnel Sans',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConstants.primaryTeal,
                      AppConstants.primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.primaryTeal.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppConstants.accentGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppConstants.accentGold.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppConstants.accentGold,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Ready to map the sound of your city?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppConstants.accentGold,
                    fontFamily: 'Funnel Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Impact',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
            fontFamily: 'Funnel Sans',
          ),
        ),
        SizedBox(height: AppConstants.paddingM),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Measurements',
                value: '127',
                subtitle: 'This month',
                icon: Icons.mic,
                color: AppConstants.primaryTeal,
              ),
            ),
            SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: StatsCard(
                title: '\$HUSH Earned',
                value: '2.4K',
                subtitle: 'Total rewards',
                icon: Icons.monetization_on,
                color: AppConstants.accentGold,
              ),
            ),
          ],
        ),
        SizedBox(height: AppConstants.paddingM),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Streak',
                value: '12',
                subtitle: 'Days active',
                icon: Icons.local_fire_department,
                color: AppConstants.accentOrange,
              ),
            ),
            SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: StatsCard(
                title: 'Rank',
                value: '#47',
                subtitle: 'In your city',
                icon: Icons.leaderboard,
                color: AppConstants.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
            fontFamily: 'Funnel Sans',
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                title: 'Start\nMeasuring',
                subtitle: 'Capture noise data',
                icon: Icons.play_circle_fill,
                color: AppConstants.primaryTeal,
                onTap: () {
                  // TODO: Navigate to measure screen (index 2)
                },
              ),
            ),
            const SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: QuickActionCard(
                title: 'Check-in\nVenue',
                subtitle: 'Rate a location',
                icon: Icons.location_on,
                color: AppConstants.primaryColor,
                onTap: () {
                  // TODO: Navigate to venue check-in flow
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingM),
        QuickActionCard(
          title: 'View Noise Map',
          subtitle: 'Explore your city\'s sound landscape',
          icon: Icons.map,
          color: AppConstants.accentGold,
          isWide: true,
          onTap: () {
            // TODO: Navigate to map screen (index 1)
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
                fontFamily: 'Funnel Sans',
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to activity history screen
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  color: AppConstants.primaryTeal,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Funnel Sans',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingM),
        _buildActivityItem(
          'Measurement at Central Park',
          '65 dB • 2 hours ago',
          Icons.mic,
          AppConstants.primaryTeal,
        ),
        _buildActivityItem(
          'Venue Check-in: Quiet Cafe',
          '42 dB • Yesterday',
          Icons.location_on,
          AppConstants.primaryColor,
        ),
        _buildActivityItem(
          'Earned 50 \$HUSH tokens',
          'Daily streak bonus • 2 days ago',
          Icons.monetization_on,
          AppConstants.accentGold,
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppConstants.softGray.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textPrimary,
                    fontFamily: 'Funnel Sans',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppConstants.textSecondary,
                    fontFamily: 'Funnel Sans',
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

