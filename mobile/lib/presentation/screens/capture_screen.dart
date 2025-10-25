import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../core/constants/app_constants.dart';
import '../providers/app_providers.dart';
import '../../core/animations/waveform_animation.dart';
import '../../core/widgets/premium_button.dart';
import '../../core/utils/haptic_feedback.dart';
import '../widgets/noise_measurement_modal.dart';
import '../../domain/models/noise_measurement.dart';
import '../../domain/models/venue.dart';
import 'history_screen.dart';
import 'analytics_screen.dart';
import 'map_screen.dart';

class MeasureScreen extends ConsumerStatefulWidget {
  const MeasureScreen({super.key});

  @override
  ConsumerState<MeasureScreen> createState() => _MeasureScreenState();
}

class _MeasureScreenState extends ConsumerState<MeasureScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late AnimationController _waveformController;
  late AnimationController _breathingController;

  NoiseMeasurementType? _selectedMeasurementType;
  Venue? _selectedVenue;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _waveformController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Start subtle breathing animation
    _breathingController.repeat(reverse: true);

    // Get current location on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationProvider.notifier).getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    _waveformController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final measurementState = ref.watch(measurementStateProvider);
    final locationState = ref.watch(locationProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Header
                _buildHeader(),

                const SizedBox(height: 24),

                // Location Card
                _buildLocationCard(locationState),

                const SizedBox(height: 20),

                // Main Measurement Circle with Dynamic Visualization
                _buildMeasurementCircle(measurementState),

                const SizedBox(height: 20),

                // Decibel Display
                _buildDecibelDisplay(measurementState),

                const SizedBox(height: 20),

                // Control Buttons
                _buildControlButtons(measurementState),

                const SizedBox(height: 20),

                // Quick Actions
                _buildQuickActions(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.mic,
            color: AppConstants.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Noise Measure',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimary,
                ),
              ),
              Text(
                'Measure ambient noise levels',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.help_outline,
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard(LocationState locationState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.deepBlue.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            color: AppConstants.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Location',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  locationState.address ?? 'Getting location...',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (locationState.isLoading)
            const SizedBox(
              width: 32,
              height: 24,
              child: WaveformAnimation(
                isActive: true,
                amplitude: 0.7,
                color: AppConstants.primaryTeal,
                height: 16,
                waveCount: 5,
                duration: Duration(milliseconds: 1200),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMeasurementCircle(MeasurementState measurementState) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ambient glow
            AnimatedBuilder(
              animation: _breathingController,
              builder: (context, child) {
                return Container(
                  width: 280 + (20 * _breathingController.value),
                  height: 280 + (20 * _breathingController.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppConstants.primaryTeal.withValues(alpha: 0.05),
                        AppConstants.primaryTeal.withValues(alpha: 0.02),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),

            // Dynamic ripple circles when measuring
            if (measurementState.isMeasuring) ...[
              _buildRippleCircle(280, 0.1),
              _buildRippleCircle(240, 0.2),
              _buildRippleCircle(200, 0.3),
            ],

            // Main measurement circle with premium styling
            AnimatedBuilder(
              animation: _breathingController,
              builder: (context, child) {
                return Container(
                  width: 180 + (8 * _breathingController.value),
                  height: 180 + (8 * _breathingController.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppConstants.primaryTeal.withValues(alpha: 0.15),
                        AppConstants.primaryTeal.withValues(alpha: 0.08),
                        AppConstants.primaryTeal.withValues(alpha: 0.03),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.primaryTeal.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppConstants.surfaceColor,
                      border: Border.all(
                        color: AppConstants.primaryTeal,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.deepBlue.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: measurementState.isMeasuring
                          ? _buildDynamicWaveform(measurementState)
                          : _buildStaticMicrophone(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicWaveform(MeasurementState measurementState) {
    return WaveformAnimation(
      isActive: true,
      amplitude: math.min(1.0, measurementState.currentDecibelLevel / 80.0),
      color: AppConstants.primaryTeal,
      height: 40,
      waveCount: 9,
      duration: const Duration(milliseconds: 800),
    );
  }

  Widget _buildStaticMicrophone() {
    return AnimatedBuilder(
      animation: _breathingController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (0.1 * _breathingController.value),
          child: Icon(
            Icons.mic,
            size: 32,
            color: AppConstants.primaryTeal.withValues(
              alpha: 0.6 + (0.4 * _breathingController.value),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRippleCircle(double size, double opacity) {
    return AnimatedBuilder(
      animation: _rippleController,
      builder: (context, child) {
        return Container(
          width: size * (0.8 + 0.2 * _rippleController.value),
          height: size * (0.8 + 0.2 * _rippleController.value),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppConstants.primaryColor
                  .withValues(alpha: opacity * (1 - _rippleController.value)),
              width: 1,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDecibelDisplay(MeasurementState measurementState) {
    return Column(
      children: [
        // Large decibel number
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: measurementState.currentDecibelLevel.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimary,
                ),
              ),
              const TextSpan(
                text: ' dB',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Status indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: _getNoiseColor(measurementState.currentDecibelLevel),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _getNoiseLabel(measurementState.currentDecibelLevel),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Color _getNoiseColor(double decibelLevel) {
    if (decibelLevel < 40) return AppConstants.noiseQuiet;
    if (decibelLevel < 55) return AppConstants.noiseModerate;
    if (decibelLevel < 70) return AppConstants.noiseLoud;
    return AppConstants.noiseVeryLoud;
  }

  String _getNoiseLabel(double decibelLevel) {
    if (decibelLevel < 40) return 'Quiet';
    if (decibelLevel < 55) return 'Moderate';
    if (decibelLevel < 70) return 'Loud';
    return 'Very Loud';
  }

  Widget _buildControlButtons(MeasurementState measurementState) {
    return Row(
      children: [
        // Venue Check-in Button
        Expanded(
          child: PremiumButton(
            text:
                _selectedVenue != null ? 'Venue\nSelected' : 'Venue\nCheck-in',
            icon: Icons.store,
            onPressed: measurementState.isMeasuring
                ? null
                : () {
                    HushHaptics.lightTap();
                    _showVenueSelection();
                  },
            style: _selectedVenue != null
                ? PremiumButtonStyle.primary
                : PremiumButtonStyle.secondary,
          ),
        ),

        const SizedBox(width: 12),

        // Main Record Button with Premium Styling
        Expanded(
          flex: 2,
          child: PremiumButton(
            text: measurementState.isMeasuring ? 'Stop' : 'Start',
            icon: measurementState.isMeasuring ? Icons.stop : Icons.mic,
            onPressed: () {
              HushHaptics.mediumTap();
              if (measurementState.isMeasuring) {
                _stopMeasurement();
              } else {
                _showMeasurementTypeModal();
              }
            },
            style: PremiumButtonStyle.primary,
            isExpanded: true,
          ),
        ),

        const SizedBox(width: 12),

        // Report Button
        Expanded(
          child: PremiumButton(
            text: 'Report',
            icon: Icons.report,
            onPressed: measurementState.isMeasuring
                ? null
                : () {
                    HushHaptics.lightTap();
                    _showReportModal();
                  },
            style: PremiumButtonStyle.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppConstants.textPrimary,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.history,
                title: 'History',
                subtitle: 'View past measurements',
                onTap: () {
                  HushHaptics.lightTap();
                  _showHistoryScreen();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.analytics,
                title: 'Analytics',
                subtitle: 'See your trends',
                onTap: () {
                  HushHaptics.lightTap();
                  _showAnalyticsScreen();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showMeasurementTypeModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => NoiseMeasurementModal(
        onTypeSelected: (type) {
          _selectedMeasurementType = type;
          _startMeasurement();
        },
      ),
    );
  }

  Future<void> _startMeasurement() async {
    try {
      // Start real audio measurement
      await ref.read(measurementStateProvider.notifier).startMeasurement();
      _rippleController.repeat();
      _waveformController.repeat();

      // Update UI state to show measuring
      setState(() {
        // UI will automatically update based on measurementState.isMeasuring
      });

      // Show measurement started feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(width: 8),
                Text(
                    '🎙️ Measuring ${_getMeasurementTypeDescription(_selectedMeasurementType!)}'),
              ],
            ),
            backgroundColor: AppConstants.primaryTeal,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Auto-stop measurement after 30 seconds for demo
      Timer(const Duration(seconds: 30), () {
        if (mounted && ref.read(measurementStateProvider).isMeasuring) {
          _stopMeasurement();
        }
      });
    } catch (e) {
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(
                        'Failed to start real measurement: ${e.toString()}')),
              ],
            ),
            backgroundColor: AppConstants.errorColor,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _stopMeasurement() {
    ref.read(measurementStateProvider.notifier).stopMeasurement();
    _rippleController.stop();
    _waveformController.stop();

    // Save measurement and show results
    _saveMeasurement();
  }

  Future<void> _saveMeasurement() async {
    final measurementState = ref.read(measurementStateProvider);
    final locationState = ref.read(locationProvider);

    if (measurementState.decibelHistory.isEmpty) return;

    try {
      // Calculate average decibel level
      final averageDecibel =
          measurementState.decibelHistory.reduce((a, b) => a + b) /
              measurementState.decibelHistory.length;

      // Create noise measurement
      final measurement = NoiseMeasurement(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        decibelLevel: averageDecibel,
        latitude: locationState.latitude ?? 0.0,
        longitude: locationState.longitude ?? 0.0,
        timestamp: measurementState.measurementStartTime ?? DateTime.now(),
        type: _getMeasurementTypeEnum(_selectedMeasurementType),
        venueId: _selectedVenue?.id,
        userId: 'current_user', // TODO: Get from auth
      );

      // Save to Hive
      final noiseMeasurementsBox = ref.read(noiseMeasurementsBoxProvider);
      await noiseMeasurementsBox.add(measurement);

      // Show detailed results modal
      if (mounted) {
        _showMeasurementResults(measurement, averageDecibel);
      }

      // Notify map screen about new measurement (if it's loaded)
      // This will help update the map with the new measurement
      debugPrint(
          '📊 New measurement saved: ${averageDecibel.toStringAsFixed(1)} dB at ${locationState.address}');

      // Reset selection
      _selectedMeasurementType = null;
      _selectedVenue = null;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save measurement: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showMeasurementResults(
      NoiseMeasurement measurement, double averageDecibel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        title: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getNoiseColor(averageDecibel),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Measurement Complete!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textPrimary,
                        ),
                  ),
                  Text(
                    '${averageDecibel.toStringAsFixed(1)} dB • ${_getNoiseLabel(averageDecibel)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConstants.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultItem(
              'Type',
              _getMeasurementTypeDescription(_selectedMeasurementType ??
                  NoiseMeasurementType.noiseMeasure),
              Icons.category,
            ),
            const SizedBox(height: 12),
            _buildResultItem(
              'Location',
              ref.read(locationProvider).address ?? 'Unknown location',
              Icons.location_on,
            ),
            const SizedBox(height: 12),
            _buildResultItem(
              'Duration',
              '30 seconds',
              Icons.timer,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getNoiseColor(averageDecibel).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Health Impact',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getHealthAdvice(averageDecibel),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'View Details',
              style: TextStyle(color: AppConstants.primaryTeal),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to maps screen to show the measurement
              _navigateToMapsScreen();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryTeal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppConstants.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.textSecondary,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppConstants.textPrimary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getHealthAdvice(double decibelLevel) {
    if (decibelLevel < 40) {
      return 'Perfect for concentration and relaxation. Ideal environment for work and sleep.';
    }
    if (decibelLevel < 55) {
      return 'Comfortable for conversation and light work. Generally pleasant environment.';
    }
    if (decibelLevel < 70) {
      return 'May cause fatigue with prolonged exposure. Consider breaks if staying long.';
    }
    if (decibelLevel < 85) {
      return 'Potentially harmful with extended exposure. Limit time in this environment.';
    }
    return 'Dangerous - hearing protection recommended. Avoid prolonged exposure.';
  }

  String _getMeasurementTypeDescription(NoiseMeasurementType type) {
    switch (type) {
      case NoiseMeasurementType.noiseMeasure:
        return 'Starting general noise measurement';
      case NoiseMeasurementType.noiseLevel:
        return 'Starting decibel level measurement';
      case NoiseMeasurementType.venueMeasures:
        return 'Starting venue-specific measurement';
      case NoiseMeasurementType.complaints:
        return 'Starting noise complaint recording';
    }
  }

  MeasurementType _getMeasurementTypeEnum(NoiseMeasurementType? type) {
    if (type == null) return MeasurementType.active;

    switch (type) {
      case NoiseMeasurementType.noiseMeasure:
        return MeasurementType.active;
      case NoiseMeasurementType.noiseLevel:
        return MeasurementType.active;
      case NoiseMeasurementType.venueMeasures:
        return MeasurementType.venue;
      case NoiseMeasurementType.complaints:
        return MeasurementType.active;
    }
  }

  void _showVenueSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VenueSelectionBottomSheet(
        onVenueSelected: (venue) {
          setState(() {
            _selectedVenue = venue;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showReportModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ReportModal(),
    );
  }

  void _showHistoryScreen() {
    // Navigate to history screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HistoryScreen(),
      ),
    );
  }

  void _showAnalyticsScreen() {
    // Navigate to analytics screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AnalyticsScreen(),
      ),
    );
  }

  void _navigateToMapsScreen() {
    // Navigate to maps screen to show the measurement
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppConstants.deepBlue.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppConstants.primaryColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppConstants.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VenueSelectionBottomSheet extends StatelessWidget {
  final Function(Venue) onVenueSelected;

  const _VenueSelectionBottomSheet({
    required this.onVenueSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXL),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppConstants.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: AppConstants.paddingL),

            // Title
            Text(
              'Select Venue',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
            ),

            const SizedBox(height: AppConstants.paddingL),

            // Venue list (mock data for now)
            ...List.generate(5, (index) {
              final venues = [
                Venue(
                  id: 'venue_${index + 1}',
                  name: [
                    'Starbucks',
                    'McDonald\'s',
                    'Central Park',
                    'Times Square',
                    'Brooklyn Bridge'
                  ][index],
                  address: 'New York, NY',
                  latitude: 40.7128 + (index * 0.01),
                  longitude: -74.0060 + (index * 0.01),
                  type: VenueType.cafe,
                  tags: ['coffee', 'quiet'],
                  averageNoiseLevel: 45.0 + (index * 5),
                ),
              ];

              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryTeal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  child: const Icon(
                    Icons.store,
                    color: AppConstants.primaryTeal,
                  ),
                ),
                title: Text(
                  venues.first.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimary,
                  ),
                ),
                subtitle: Text(
                  '${venues.first.averageNoiseLevel.toStringAsFixed(1)} dB average',
                  style: const TextStyle(
                    color: AppConstants.textSecondary,
                  ),
                ),
                onTap: () {
                  onVenueSelected(venues.first);
                },
              );
            }),

            const SizedBox(height: AppConstants.paddingL),
          ],
        ),
      ),
    );
  }
}

class _ReportModal extends StatefulWidget {
  @override
  State<_ReportModal> createState() => _ReportModalState();
}

class _ReportModalState extends State<_ReportModal> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Construction';

  final List<String> _categories = [
    'Construction',
    'Traffic',
    'Music/Entertainment',
    'Neighbors',
    'Commercial Activity',
    'Other'
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConstants.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.report_problem,
            color: AppConstants.errorColor,
            size: 24,
          ),
          SizedBox(width: 12),
          Text(
            'Report Noise Issue',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Description (Optional)',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Describe the noise issue...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.warningColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(
                color: AppConstants.warningColor.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppConstants.warningColor,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This report is for community awareness and will not earn rewards.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppConstants.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            HushHaptics.mediumTap();
            _submitReport();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryTeal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
          ),
          child: const Text('Submit Report'),
        ),
      ],
    );
  }

  void _submitReport() {
    // Here you would typically save the report to the database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Noise report submitted successfully!'),
        backgroundColor: AppConstants.successColor,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }
}
