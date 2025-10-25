import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import 'profile/edit_profile_screen.dart';
import 'profile/settings_screen.dart';
import 'profile/privacy_screen.dart';
import 'profile/about_screen.dart';
import 'profile/wallet_settings_screen.dart';
import 'profile/activity_history_screen.dart';
import 'profile/language_screen.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/stats_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;
  late Animation<double> _scaleAnimation;

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

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
    ));

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

  Widget _buildAnimatedSection(int index, Widget child, {bool useScale = false}) {
    if (useScale) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: SlideTransition(
          position: _slideAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: child,
          ),
        ),
      );
    }
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              _buildAnimatedSection(0, _buildProfileHeader()),
              const SizedBox(height: AppConstants.paddingXL),
              
              // Quick Stats
              _buildAnimatedSection(1, _buildQuickStats()),
              const SizedBox(height: AppConstants.paddingXL),
              
              // Account Section
              _buildAnimatedSection(2, _buildAccountSection()),
              const SizedBox(height: AppConstants.paddingL),
              
              // Settings Section
              _buildAnimatedSection(3, _buildSettingsSection()),
              const SizedBox(height: AppConstants.paddingL),
              
              // Support Section
              _buildAnimatedSection(4, _buildSupportSection()),
              const SizedBox(height: AppConstants.paddingL),
              
              // Sign Out
              _buildAnimatedSection(5, _buildSignOutButton()),
              const SizedBox(height: AppConstants.paddingL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryTeal.withValues(alpha: 0.1),
            AppConstants.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppConstants.primaryTeal.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Avatar and Edit Button
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConstants.primaryTeal,
                      AppConstants.primaryColor,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.primaryTeal.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showAvatarPicker(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppConstants.accentGold,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.accentGold.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          // Name and Username
          Text(
            'Sound Scout',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            '@soundscout_2024',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          // Location and Join Date
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: AppConstants.textSecondary,
              ),
              SizedBox(width: 4),
              Text(
                'Accra, Ghana',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textSecondary,
                  fontFamily: 'Funnel Sans',
                ),
              ),
              SizedBox(width: 16),
              Icon(
                Icons.calendar_today,
                size: 16,
                color: AppConstants.textSecondary,
              ),
              SizedBox(width: 4),
              Text(
                'Joined Oct 2024',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textSecondary,
                  fontFamily: 'Funnel Sans',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Impact',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppConstants.paddingM),
        const Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Measurements',
                value: '127',
                subtitle: 'Total recorded',
                icon: Icons.mic,
                color: AppConstants.primaryTeal,
              ),
            ),
            SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: StatsCard(
                title: 'City Rank',
                value: '#47',
                subtitle: 'San Francisco',
                icon: Icons.leaderboard,
                color: AppConstants.accentGold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      'Account',
      [
        ProfileMenuItem(
          icon: Icons.edit,
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          ),
        ),
        ProfileMenuItem(
          icon: Icons.wallet,
          title: 'Wallet Settings',
          subtitle: 'Manage your HUSH wallet',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WalletSettingsScreen()),
          ),
        ),
        ProfileMenuItem(
          icon: Icons.history,
          title: 'Activity History',
          subtitle: 'View your measurement history',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ActivityHistoryScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return _buildSection(
      'Settings',
      [
        ProfileMenuItem(
          icon: Icons.settings,
          title: 'App Settings',
          subtitle: 'Notifications, privacy & more',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          ),
        ),
        ProfileMenuItem(
          icon: Icons.security,
          title: 'Privacy & Security',
          subtitle: 'Control your data and privacy',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrivacyScreen()),
          ),
        ),
        ProfileMenuItem(
          icon: Icons.language,
          title: 'Language',
          subtitle: 'English (US)',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LanguageScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSection(
      'Support',
      [
        ProfileMenuItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () {
            // TODO: Navigate to help
          },
        ),
        ProfileMenuItem(
          icon: Icons.info_outline,
          title: 'About HushSense',
          subtitle: 'App version and information',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutScreen()),
          ),
        ),
        ProfileMenuItem(
          icon: Icons.star_outline,
          title: 'Rate App',
          subtitle: 'Rate us on the App Store',
          onTap: () {
            // TODO: Open app store rating
          },
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppConstants.paddingM),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  item,
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      color: theme.colorScheme.outline,
                      indent: 56,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSignOutButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      child: ElevatedButton(
        onPressed: () => _showSignOutDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red.shade700,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.red.shade200),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Funnel Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAvatarPicker(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),
            Text(
              'Change Profile Picture',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppConstants.paddingL),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption(Icons.camera_alt, 'Camera', () {
                  Navigator.pop(context);
                  // TODO: Open camera
                }),
                _buildAvatarOption(Icons.photo_library, 'Gallery', () {
                  Navigator.pop(context);
                  // TODO: Open gallery
                }),
                _buildAvatarOption(Icons.person, 'Default', () {
                  Navigator.pop(context);
                  // TODO: Set default avatar
                }),
              ],
            ),
            const SizedBox(height: AppConstants.paddingL),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption(IconData icon, String label, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppConstants.primaryTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppConstants.primaryTeal,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Sign Out',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to sign out of your account?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Handle sign out
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(
                fontFamily: 'Funnel Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

