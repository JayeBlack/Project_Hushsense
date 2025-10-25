import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../widgets/profile_menu_item.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

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
          'About HushSense',
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
            // App Info Card
            _buildAnimatedSection(0, _buildAppInfoCard()),
            const SizedBox(height: AppConstants.paddingL),
            
            // Version & Updates
            _buildAnimatedSection(1, _buildVersionSection()),
            const SizedBox(height: AppConstants.paddingL),
            
            // Legal & Support
            _buildAnimatedSection(2, _buildLegalSection()),
            const SizedBox(height: AppConstants.paddingL),
            
            // Community & Social
            _buildAnimatedSection(3, _buildCommunitySection()),
            const SizedBox(height: AppConstants.paddingL),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoCard() {
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
          // App Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.primaryTeal,
                  AppConstants.primaryColor,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryTeal.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.hearing,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          // App Name and Version
          const Text(
            'HushSense',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
              fontFamily: 'Funnel Sans',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Decentralized Urban Noise Mapping',
            style: TextStyle(
              fontSize: 16,
              color: AppConstants.textSecondary,
              fontFamily: 'Funnel Sans',
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          // Description
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'HushSense empowers communities to map urban soundscapes through crowdsourced data collection, creating quieter, healthier cities while rewarding contributors with \$HUSH tokens.',
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textPrimary,
                fontFamily: 'Funnel Sans',
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionSection() {
    return _buildSection(
      'Version & Updates',
      [
        ProfileMenuItem(
          icon: Icons.info_outline,
          title: 'App Version',
          subtitle: '1.0.0 (Build 100)',
          onTap: () {},
        ),
        ProfileMenuItem(
          icon: Icons.system_update,
          title: 'Check for Updates',
          subtitle: 'You have the latest version',
          onTap: _checkForUpdates,
        ),
        ProfileMenuItem(
          icon: Icons.history,
          title: 'Release Notes',
          subtitle: 'See what\'s new in this version',
          onTap: _showReleaseNotes,
        ),
        ProfileMenuItem(
          icon: Icons.bug_report,
          title: 'Report a Bug',
          subtitle: 'Help us improve the app',
          onTap: _reportBug,
        ),
      ],
    );
  }

  Widget _buildLegalSection() {
    return _buildSection(
      'Legal & Support',
      [
        ProfileMenuItem(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          subtitle: 'Read our terms and conditions',
          onTap: _showTermsOfService,
        ),
        ProfileMenuItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'How we protect your data',
          onTap: _showPrivacyPolicy,
        ),
        ProfileMenuItem(
          icon: Icons.gavel_outlined,
          title: 'Open Source Licenses',
          subtitle: 'Third-party software licenses',
          onTap: _showOpenSourceLicenses,
        ),
        ProfileMenuItem(
          icon: Icons.support_agent,
          title: 'Contact Support',
          subtitle: 'Get help from our team',
          onTap: _contactSupport,
        ),
      ],
    );
  }

  Widget _buildCommunitySection() {
    return _buildSection(
      'Community & Social',
      [
        ProfileMenuItem(
          icon: Icons.language,
          title: 'Website',
          subtitle: 'Visit hushsense.io',
          onTap: () => _openUrl('https://hushsense.io'),
        ),
        ProfileMenuItem(
          icon: Icons.forum_outlined,
          title: 'Community Forum',
          subtitle: 'Join discussions with other users',
          onTap: () => _openUrl('https://community.hushsense.io'),
        ),
        ProfileMenuItem(
          icon: Icons.code,
          title: 'GitHub Repository',
          subtitle: 'View source code and contribute',
          onTap: () => _openUrl('https://github.com/hushsense'),
        ),
        ProfileMenuItem(
          icon: Icons.article_outlined,
          title: 'Documentation',
          subtitle: 'Learn more about HushSense',
          onTap: () => _openUrl('https://docs.hushsense.io'),
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

  void _checkForUpdates() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Check for Updates',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
            fontFamily: 'Funnel Sans',
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: AppConstants.primaryTeal,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'You have the latest version of HushSense!',
              style: TextStyle(
                color: AppConstants.textSecondary,
                fontFamily: 'Funnel Sans',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryTeal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'OK',
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

  void _showReleaseNotes() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: const BoxDecoration(
          color: AppConstants.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
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
              'Release Notes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
                fontFamily: 'Funnel Sans',
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReleaseNote(
                      '1.0.0',
                      'October 2024',
                      [
                        '🎉 Initial release of HushSense',
                        '📱 Premium UI with smooth animations',
                        '🎵 Real-time noise measurement',
                        '🏆 Gamification and rewards system',
                        '🔐 Blockchain integration with Hedera',
                        '🗺️ Interactive noise mapping',
                      ],
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

  Widget _buildReleaseNote(String version, String date, List<String> features) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Version $version',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textPrimary,
                  fontFamily: 'Funnel Sans',
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.textSecondary,
                  fontFamily: 'Funnel Sans',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.textPrimary,
                fontFamily: 'Funnel Sans',
              ),
            ),
          )),
        ],
      ),
    );
  }

  void _reportBug() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Report a Bug',
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
              decoration: InputDecoration(
                labelText: 'Bug Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Please describe the bug in detail...',
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
              // TODO: Submit bug report
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryTeal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Submit',
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

  void _showTermsOfService() {
    // TODO: Show terms of service
  }

  void _showPrivacyPolicy() {
    // TODO: Show privacy policy
  }

  void _showOpenSourceLicenses() {
    // TODO: Show open source licenses
  }

  void _contactSupport() {
    // TODO: Open support contact
  }

  void _openUrl(String url) {
    // TODO: Open URL in browser
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening $url...',
          style: const TextStyle(fontFamily: 'Funnel Sans'),
        ),
        backgroundColor: AppConstants.primaryTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
