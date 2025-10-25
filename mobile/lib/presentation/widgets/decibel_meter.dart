import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

class DecibelMeter extends StatelessWidget {
  final double decibelLevel;
  final bool isMeasuring;

  const DecibelMeter({
    super.key,
    required this.decibelLevel,
    required this.isMeasuring,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Decibel Level Display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                decibelLevel.toStringAsFixed(1),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getNoiseColor(),
                ),
              ),

              const SizedBox(width: AppConstants.paddingS),

              Text(
                'dB',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.paddingM),

          // Noise Level Label
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingM,
              vertical: AppConstants.paddingS,
            ),
            decoration: BoxDecoration(
              color: _getNoiseColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
              border: Border.all(
                color: _getNoiseColor().withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              _getNoiseLevelLabel(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _getNoiseColor(),
              ),
            ),
          ),

          const SizedBox(height: AppConstants.paddingL),

          // Gauge
          _buildGauge(),
        ],
      ),
    );
  }

  Widget _buildGauge() {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            AppConstants.noiseQuiet,
            AppConstants.noiseModerate,
            AppConstants.noiseLoud,
            AppConstants.noiseVeryLoud,
            AppConstants.noiseExtreme,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Gauge background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppConstants.backgroundColor.withValues(alpha: 0.3),
            ),
          ),

          // Gauge fill
          FractionallySizedBox(
            widthFactor: _getGaugePercentage(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),

          // Gauge indicator
          Positioned(
            left:
                _getGaugePercentage() * 200 - 4, // Assuming gauge width is 200
            top: 0,
            child: Container(
              width: 8,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.textPrimary.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getGaugePercentage() {
    final normalizedLevel =
        (decibelLevel - AppConstants.minDecibelLevel) /
        (AppConstants.maxDecibelLevel - AppConstants.minDecibelLevel);
    return normalizedLevel.clamp(0.0, 1.0);
  }

  String _getNoiseLevelLabel() {
    if (decibelLevel < 50) return 'Quiet';
    if (decibelLevel < 70) return 'Moderate';
    if (decibelLevel < 85) return 'Loud';
    if (decibelLevel < 100) return 'Very Loud';
    return 'Extreme';
  }

  Color _getNoiseColor() {
    if (decibelLevel < 50) return AppConstants.noiseQuiet;
    if (decibelLevel < 70) return AppConstants.noiseModerate;
    if (decibelLevel < 85) return AppConstants.noiseLoud;
    if (decibelLevel < 100) return AppConstants.noiseVeryLoud;
    return AppConstants.noiseExtreme;
  }
}

