import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../widgets/profile_menu_item.dart';

class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  bool _dataCollectionEnabled = true;
  bool _analyticsEnabled = false;
  bool _locationSharingEnabled = true;
  bool _profileVisibilityPublic = false;
  String _dataRetention = '2 years';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimations = List.generate(4, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.15,
          0.6 + (index * 0.15),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _slideAnimations = List.generate(4, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.15,
          0.6 + (index * 0.15),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _animationController.forward();
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppConstants.textPrimary,
          ),
        ),
        title: const Text(
          'Privacy & Security',
          style: TextStyle(
            color: AppConstants.textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Funnel Sans',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Privacy Overview Card
            _buildAnimatedSection(0, _buildPrivacyOverviewCard()),
            const SizedBox(height: AppConstants.paddingL),
            
            // Data Collection Section
            _buildAnimatedSection(1, _buildDataCollectionSection()),
            const SizedBox(height: AppConstants.paddingL),
            
            // Sharing & Visibility Section
            _buildAnimatedSection(2, _buildSharingSection()),
            const SizedBox(height: AppConstants.paddingL),
            
            // Security Section
            _buildAnimatedSection(3, _buildSecuritySection()),
            const SizedBox(height: AppConstants.paddingL),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyOverviewCard() {
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.primaryTeal.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppConstants.primaryTeal.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.security,
                  color: AppConstants.primaryTeal,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Privacy Matters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textPrimary,
                        fontFamily: 'Funnel Sans',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'HushSense is built with privacy-first principles',
                      style: TextStyle(
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
          const SizedBox(height: AppConstants.paddingM),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.accentGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppConstants.accentGold.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppConstants.accentGold,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'All data is encrypted and stored securely on the blockchain',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppConstants.accentGold,
                      fontFamily: 'Funnel Sans',
                      fontWeight: FontWeight.w500,
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

  Widget _buildDataCollectionSection() {
    return _buildSection(
      'Data Collection',
      [
        _buildSwitchItem(
          icon: Icons.data_usage,
          title: 'Measurement Data Collection',
          subtitle: 'Allow collection of noise measurements',
          value: _dataCollectionEnabled,
          onChanged: (value) => setState(() => _dataCollectionEnabled = value),
        ),
        _buildSwitchItem(
          icon: Icons.analytics_outlined,
          title: 'Usage Analytics',
          subtitle: 'Help improve the app with anonymous usage data',
          value: _analyticsEnabled,
          onChanged: (value) => setState(() => _analyticsEnabled = value),
        ),
        ProfileMenuItem(
          icon: Icons.schedule,
          title: 'Data Retention',
          subtitle: _dataRetention,
          onTap: _showDataRetentionPicker,
        ),
        ProfileMenuItem(
          icon: Icons.download_outlined,
          title: 'Download My Data',
          subtitle: 'Get a copy of all your data',
          onTap: _showDownloadDataDialog,
        ),
      ],
    );
  }

  Widget _buildSharingSection() {
    return _buildSection(
      'Sharing & Visibility',
      [
        _buildSwitchItem(
          icon: Icons.location_on_outlined,
          title: 'Location Sharing',
          subtitle: 'Share location data for noise mapping',
          value: _locationSharingEnabled,
          onChanged: (value) => setState(() => _locationSharingEnabled = value),
        ),
        _buildSwitchItem(
          icon: Icons.public,
          title: 'Public Profile',
          subtitle: 'Make your profile visible to other users',
          value: _profileVisibilityPublic,
          onChanged: (value) => setState(() => _profileVisibilityPublic = value),
        ),
        ProfileMenuItem(
          icon: Icons.block,
          title: 'Blocked Users',
          subtitle: 'Manage blocked users',
          onTap: _showBlockedUsersScreen,
        ),
        ProfileMenuItem(
          icon: Icons.share_outlined,
          title: 'Data Sharing Preferences',
          subtitle: 'Control how your data is shared',
          onTap: _showDataSharingPreferences,
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return _buildSection(
      'Security',
      [
        ProfileMenuItem(
          icon: Icons.key,
          title: 'Change Password',
          subtitle: 'Update your account password',
          onTap: _showChangePasswordDialog,
        ),
        ProfileMenuItem(
          icon: Icons.security,
          title: 'Two-Factor Authentication',
          subtitle: 'Add an extra layer of security',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppConstants.accentGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Recommended',
              style: TextStyle(
                fontSize: 12,
                color: AppConstants.accentGold,
                fontWeight: FontWeight.w600,
                fontFamily: 'Funnel Sans',
              ),
            ),
          ),
          onTap: _showTwoFactorSetup,
        ),
        ProfileMenuItem(
          icon: Icons.devices,
          title: 'Active Sessions',
          subtitle: 'Manage your logged-in devices',
          onTap: _showActiveSessionsScreen,
        ),
        ProfileMenuItem(
          icon: Icons.history,
          title: 'Login History',
          subtitle: 'View recent account activity',
          onTap: _showLoginHistoryScreen,
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
            fontFamily: 'Funnel Sans',
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        Container(
          decoration: BoxDecoration(
            color: AppConstants.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppConstants.borderColor,
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
                    const Divider(
                      height: 1,
                      color: AppConstants.borderColor,
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

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (iconColor ?? AppConstants.primaryTeal).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppConstants.primaryTeal,
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
                    fontWeight: FontWeight.w600,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppConstants.primaryTeal,
            activeTrackColor: AppConstants.primaryTeal.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  void _showDataRetentionPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: const BoxDecoration(
          color: AppConstants.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppConstants.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),
            const Text(
              'Data Retention Period',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
                fontFamily: 'Funnel Sans',
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),
            ...[
              '6 months',
              '1 year',
              '2 years',
              '5 years',
              'Forever',
            ].map((period) => ListTile(
              title: Text(
                period,
                style: const TextStyle(
                  color: AppConstants.textPrimary,
                  fontFamily: 'Funnel Sans',
                ),
              ),
              trailing: _dataRetention == period ? const Icon(Icons.check, color: AppConstants.primaryTeal) : null,
              onTap: () {
                setState(() => _dataRetention = period);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: AppConstants.paddingL),
          ],
        ),
      ),
    );
  }

  void _showDownloadDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Download Your Data',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
            fontFamily: 'Funnel Sans',
          ),
        ),
        content: const Text(
          'We\'ll prepare a download package with all your data. This may take a few minutes.',
          style: TextStyle(
            color: AppConstants.textSecondary,
            fontFamily: 'Funnel Sans',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppConstants.textSecondary,
                fontFamily: 'Funnel Sans',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Start data download
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryTeal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Download',
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

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
            fontFamily: 'Funnel Sans',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppConstants.textSecondary,
                fontFamily: 'Funnel Sans',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Change password
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryTeal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Update',
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

  void _showBlockedUsersScreen() {
    // TODO: Navigate to blocked users screen
  }

  void _showDataSharingPreferences() {
    // TODO: Show data sharing preferences
  }

  void _showTwoFactorSetup() {
    // TODO: Show two-factor authentication setup
  }

  void _showActiveSessionsScreen() {
    // TODO: Navigate to active sessions screen
  }

  void _showLoginHistoryScreen() {
    // TODO: Navigate to login history screen
  }
}
