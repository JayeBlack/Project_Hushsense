import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class NoiseMeasurementMarker extends StatelessWidget {
  final double decibelLevel;
  final String venueName;
  final String venueType;
  final VoidCallback onTap;

  const NoiseMeasurementMarker({
    super.key,
    required this.decibelLevel,
    required this.venueName,
    required this.venueType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getNoiseColor(decibelLevel);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${decibelLevel.toInt()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              'dB',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNoiseColor(double decibelLevel) {
    if (decibelLevel < 40) return AppConstants.noiseQuiet;
    if (decibelLevel < 55) return AppConstants.noiseModerate;
    if (decibelLevel < 70) return AppConstants.noiseLoud;
    return AppConstants.noiseVeryLoud;
  }
}
