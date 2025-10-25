import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../widgets/profile_menu_item.dart';
import '../../../main.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _locationEnabled = true;
  bool _autoUploadEnabled = false;

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
          'Settings',
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
            // Notifications Section
            _buildAnimatedSection(0, _buildNotificationsSection()),
            const SizedBox(height: AppConstants.paddingL),
            
            // Data & Privacy Section
            _buildAnimatedSection(1, _buildDataPrivacySection()),
            const SizedBox(height: AppConstants.paddingL),
            
            // Appearance Section
            _buildAnimatedSection(2, _buildAppearanceSection()),
            const SizedBox(height: AppConstants.paddingL),
            
            // Advanced Section
            _buildAnimatedSection(3, _buildAdvancedSection()),
            const SizedBox(height: AppConstants.paddingL),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return _buildSection(
      'Notifications',
      [
        _buildSwitchItem(
          icon: Icons.notifications_outlined,
          title: 'Push Notifications',
          subtitle: 'Receive updates and alerts',
          value: _notificationsEnabled,
          onChanged: (value) => setState(() => _notificationsEnabled = value),
        ),
        _buildSwitchItem(
          icon: Icons.volume_up_outlined,
          title: 'Sound',
          subtitle: 'Play sound for notifications',
          value: _soundEnabled,
          onChanged: (value) => setState(() => _soundEnabled = value),
        ),
        _buildSwitchItem(
          icon: Icons.vibration,
          title: 'Vibration',
          subtitle: 'Vibrate for notifications',
          value: _vibrationEnabled,
          onChanged: (value) => setState(() => _vibrationEnabled = value),
        ),
      ],
    );
  }

  Widget _buildDataPrivacySection() {
    return _buildSection(
      'Data & Privacy',
      [
        _buildSwitchItem(
          icon: Icons.location_on_outlined,
          title: 'Location Services',
          subtitle: 'Allow location access for measurements',
          value: _locationEnabled,
          onChanged: (value) => setState(() => _locationEnabled = value),
        ),
        _buildSwitchItem(
          icon: Icons.cloud_upload_outlined,
          title: 'Auto Upload',
          subtitle: 'Automatically upload measurements',
          value: _autoUploadEnabled,
          onChanged: (value) => setState(() => _autoUploadEnabled = value),
        ),
        ProfileMenuItem(
          icon: Icons.download_outlined,
          title: 'Export Data',
          subtitle: 'Download your measurement data',
          onTap: _showExportDialog,
        ),
        ProfileMenuItem(
          icon: Icons.delete_outline,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account',
          iconColor: Colors.red.shade600,
          onTap: _showDeleteAccountDialog,
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return _buildSection(
      'Appearance',
      [
        Padding(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppConstants.primaryTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.dark_mode_outlined, color: AppConstants.primaryTeal, size: 20),
              ),
              const SizedBox(width: AppConstants.paddingM),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Theme',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textPrimary,
                        fontFamily: 'Funnel Sans',
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Choose light, dark, or system theme',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppConstants.textSecondary,
                        fontFamily: 'Funnel Sans',
                      ),
                    ),
                  ],
                ),
              ),
              Consumer(
                builder: (context, ref, _) {
                  final themeMode = ref.watch(themeModeProvider);
                  return DropdownButton<ThemeMode>(
                    value: themeMode,
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                    ],
                    onChanged: (mode) {
                      if (mode != null) ref.read(themeModeProvider.notifier).state = mode;
                    },
                  );
                },
              ),
            ],
          ),
        ),
        ProfileMenuItem(
          icon: Icons.palette_outlined,
          title: 'Theme Color',
          subtitle: 'Teal (Default)',
          onTap: _showThemeColorPicker,
        ),
        ProfileMenuItem(
          icon: Icons.text_fields,
          title: 'Text Size',
          subtitle: 'Medium',
          onTap: _showTextSizePicker,
        ),
      ],
    );
  }

  Widget _buildAdvancedSection() {
    return _buildSection(
      'Advanced',
      [
        ProfileMenuItem(
          icon: Icons.storage_outlined,
          title: 'Storage',
          subtitle: '2.4 GB used',
          onTap: _showStorageDetails,
        ),
        ProfileMenuItem(
          icon: Icons.cached_outlined,
          title: 'Clear Cache',
          subtitle: 'Free up storage space',
          onTap: _showClearCacheDialog,
        ),
        ProfileMenuItem(
          icon: Icons.bug_report_outlined,
          title: 'Debug Mode',
          subtitle: 'Enable developer options',
          onTap: _showDebugModeDialog,
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

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Export Data',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
            fontFamily: 'Funnel Sans',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose what data to export:',
              style: TextStyle(
                color: AppConstants.textSecondary,
                fontFamily: 'Funnel Sans',
              ),
            ),
            const SizedBox(height: 16),
            _buildExportOption('Measurement Data', true),
            _buildExportOption('Profile Information', true),
            _buildExportOption('Settings & Preferences', false),
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
              // TODO: Export data
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryTeal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Export',
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

  Widget _buildExportOption(String title, bool isSelected) {
    return Row(
      children: [
        Checkbox(
          value: isSelected,
          onChanged: (value) {
            // TODO: Handle checkbox change
          },
          activeColor: AppConstants.primaryTeal,
        ),
        Text(
          title,
          style: const TextStyle(
            color: AppConstants.textPrimary,
            fontFamily: 'Funnel Sans',
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Delete Account',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.red.shade600,
            fontFamily: 'Funnel Sans',
          ),
        ),
        content: const Text(
          'This action cannot be undone. All your data, measurements, and rewards will be permanently deleted.',
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
              // TODO: Delete account
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Delete',
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

  void _showThemeColorPicker() {
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
              'Choose Theme Color',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
                fontFamily: 'Funnel Sans',
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorOption(AppConstants.primaryTeal, 'Teal', true),
                _buildColorOption(Colors.blue, 'Blue', false),
                _buildColorOption(Colors.purple, 'Purple', false),
                _buildColorOption(Colors.green, 'Green', false),
              ],
            ),
            const SizedBox(height: AppConstants.paddingL),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color, String name, bool isSelected) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        // TODO: Change theme color
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              color: AppConstants.textPrimary,
              fontFamily: 'Funnel Sans',
            ),
          ),
        ],
      ),
    );
  }

  void _showTextSizePicker() {
    // TODO: Implement text size picker
  }

  void _showStorageDetails() {
    // TODO: Show storage details
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Clear Cache',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
            fontFamily: 'Funnel Sans',
          ),
        ),
        content: const Text(
          'This will clear temporary files and free up storage space. Your data will not be affected.',
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
              // TODO: Clear cache
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryTeal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Clear',
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

  void _showDebugModeDialog() {
    // TODO: Show debug mode options
  }
}
