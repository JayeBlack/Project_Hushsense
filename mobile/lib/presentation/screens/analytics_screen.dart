import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../core/constants/app_constants.dart';
import '../providers/app_providers.dart';
import '../../domain/models/noise_measurement.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  List<NoiseMeasurement> _measurements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeasurements();
  }

  Future<void> _loadMeasurements() async {
    try {
      final noiseMeasurementsBox = ref.read(noiseMeasurementsBoxProvider);
      final measurements = noiseMeasurementsBox.values.toList();

      setState(() {
        _measurements = measurements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Failed to load measurements: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(

                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.analytics,
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
                          'Analytics',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                        Text(
                          'Insights from your measurements',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _loadMeasurements,
                    icon: const Icon(
                      Icons.refresh,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppConstants.primaryTeal,
                      ),
                    )
                  : _measurements.isEmpty
                      ? _buildEmptyState()
                      : _buildAnalyticsContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppConstants.primaryTeal.withValues(alpha: 0.1),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              size: 48,
              color: AppConstants.primaryTeal,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Data Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Take some measurements to see\nanalytics and insights here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppConstants.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to measure screen
              DefaultTabController.of(context).animateTo(2);
            },
            icon: const Icon(Icons.mic),
            label: const Text('Start Measuring'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsContent() {
    final stats = _calculateStats();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          _buildSummaryCards(stats),

          const SizedBox(height: 24),

          // Charts Section
          _buildChartsSection(stats),

          const SizedBox(height: 24),

          // Insights Section
          _buildInsightsSection(stats),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(MeasurementStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Readings',
                stats.totalMeasurements.toString(),
                Icons.assessment,
                AppConstants.primaryTeal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Average dB',
                stats.averageDecibel.toStringAsFixed(1),
                Icons.volume_up,
                AppConstants.secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Peak dB',
                stats.peakDecibel.toStringAsFixed(1),
                Icons.trending_up,
                AppConstants.errorColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Quietest dB',
                stats.minDecibel.toStringAsFixed(1),
                Icons.volume_down,
                AppConstants.successColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppConstants.deepBlue.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(MeasurementStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Noise Distribution',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppConstants.surfaceColor,
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            boxShadow: [
              BoxShadow(
                color: AppConstants.deepBlue.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDistributionBar('Quiet (0-40 dB)', stats.quietCount,
                  stats.totalMeasurements, AppConstants.noiseQuiet),
              const SizedBox(height: 12),
              _buildDistributionBar('Moderate (40-55 dB)', stats.moderateCount,
                  stats.totalMeasurements, AppConstants.noiseModerate),
              const SizedBox(height: 12),
              _buildDistributionBar('Loud (55-70 dB)', stats.loudCount,
                  stats.totalMeasurements, AppConstants.noiseLoud),
              const SizedBox(height: 12),
              _buildDistributionBar('Very Loud (70+ dB)', stats.veryLoudCount,
                  stats.totalMeasurements, AppConstants.noiseVeryLoud),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionBar(
      String label, int count, int total, Color color) {
    final percentage = total > 0 ? count / total : 0.0;

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppConstants.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: AppConstants.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: 20,
                width: (MediaQuery.of(context).size.width - 140) * percentage,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsSection(MeasurementStats stats) {
    final insights = _generateInsights(stats);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Insights',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...insights.map((insight) => _buildInsightCard(insight)),
      ],
    );
  }

  Widget _buildInsightCard(String insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(
          color: AppConstants.primaryTeal.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConstants.primaryTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppConstants.primaryTeal,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insight,
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  MeasurementStats _calculateStats() {
    if (_measurements.isEmpty) {
      return MeasurementStats.empty();
    }

    final decibelLevels = _measurements.map((m) => m.decibelLevel).toList();

    return MeasurementStats(
      totalMeasurements: _measurements.length,
      averageDecibel:
          decibelLevels.reduce((a, b) => a + b) / decibelLevels.length,
      peakDecibel: decibelLevels.reduce(math.max),
      minDecibel: decibelLevels.reduce(math.min),
      quietCount: _measurements.where((m) => m.decibelLevel < 40).length,
      moderateCount: _measurements
          .where((m) => m.decibelLevel >= 40 && m.decibelLevel < 55)
          .length,
      loudCount: _measurements
          .where((m) => m.decibelLevel >= 55 && m.decibelLevel < 70)
          .length,
      veryLoudCount: _measurements.where((m) => m.decibelLevel >= 70).length,
    );
  }

  List<String> _generateInsights(MeasurementStats stats) {
    List<String> insights = [];

    if (stats.averageDecibel < 45) {
      insights.add(
          'Your average noise level is quite low. You seem to prefer quiet environments.');
    } else if (stats.averageDecibel > 65) {
      insights.add(
          'You frequently encounter loud environments. Consider using ear protection in noisy areas.');
    }

    if (stats.peakDecibel > 80) {
      insights.add(
          'You\'ve recorded some very loud measurements. Prolonged exposure to sounds over 85 dB can cause hearing damage.');
    }

    if (stats.quietCount > stats.totalMeasurements * 0.5) {
      insights.add(
          'Most of your measurements are in quiet environments. You might enjoy peaceful locations.');
    }

    if (stats.veryLoudCount > stats.totalMeasurements * 0.3) {
      insights.add(
          'You frequently encounter very loud environments. Consider monitoring your exposure to protect your hearing.');
    }

    if (insights.isEmpty) {
      insights.add(
          'Keep measuring to get personalized insights about your noise exposure patterns.');
    }

    return insights;
  }
}

class MeasurementStats {
  final int totalMeasurements;
  final double averageDecibel;
  final double peakDecibel;
  final double minDecibel;
  final int quietCount;
  final int moderateCount;
  final int loudCount;
  final int veryLoudCount;

  MeasurementStats({
    required this.totalMeasurements,
    required this.averageDecibel,
    required this.peakDecibel,
    required this.minDecibel,
    required this.quietCount,
    required this.moderateCount,
    required this.loudCount,
    required this.veryLoudCount,
  });

  factory MeasurementStats.empty() {
    return MeasurementStats(
      totalMeasurements: 0,
      averageDecibel: 0,
      peakDecibel: 0,
      minDecibel: 0,
      quietCount: 0,
      moderateCount: 0,
      loudCount: 0,
      veryLoudCount: 0,
    );
  }
}
