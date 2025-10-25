import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_constants.dart';

class NoiseVisualizer extends StatefulWidget {
  final bool isActive;
  final double decibelLevel;

  const NoiseVisualizer({
    super.key,
    required this.isActive,
    required this.decibelLevel,
  });

  @override
  State<NoiseVisualizer> createState() => _NoiseVisualizerState();
}

class _NoiseVisualizerState extends State<NoiseVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(NoiseVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !oldWidget.isActive) {
      _startAnimations();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopAnimations();
    }
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _waveController.repeat();
    _particleController.repeat();
  }

  void _stopAnimations() {
    _pulseController.stop();
    _waveController.stop();
    _particleController.stop();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circles
          _buildBackgroundCircles(),

          // Main pulse circle
          _buildPulseCircle(),

          // Wave rings
          _buildWaveRings(),

          // Particles
          _buildParticles(),

          // Center icon
          _buildCenterIcon(),
        ],
      ),
    );
  }

  Widget _buildBackgroundCircles() {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(3, (index) {
        return Container(
          width: 200 - (index * 30),
          height: 200 - (index * 30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getNoiseColor().withValues(alpha: 0.05),
            border: Border.all(
              color: _getNoiseColor().withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPulseCircle() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.3);
        final opacity = 1.0 - _pulseController.value;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getNoiseColor().withValues(alpha: opacity * 0.3),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveRings() {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            final delay = index * 0.2;
            final progress = (_waveController.value + delay) % 1.0;
            final scale = 1.0 + (progress * 0.5);
            final opacity = 1.0 - progress;

            return Transform.scale(
              scale: scale,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getNoiseColor().withValues(alpha: opacity * 0.6),
                    width: 2,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildParticles() {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(8, (index) {
        return AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            // final angle = (index / 8) * 2 * 3.14159; // Unused variable
            final progress = (_particleController.value + (index * 0.1)) % 1.0;
            final radius = 60 + (progress * 40);
            final opacity = 1.0 - progress;

            final x = radius * (progress * 0.5) * (index % 2 == 0 ? 1 : -1);
            final y = radius * (progress * 0.5) * (index % 3 == 0 ? 1 : -1);

            return Transform.translate(
              offset: Offset(x, y),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getNoiseColor().withValues(alpha: opacity),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildCenterIcon() {
    return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getNoiseColor().withValues(alpha: 0.1),
            border: Border.all(color: _getNoiseColor(), width: 2),
          ),
          child: Icon(
            widget.isActive ? Icons.mic : Icons.mic_none,
            color: _getNoiseColor(),
            size: 30,
          ),
        )
        .animate(target: widget.isActive ? 1 : 0)
        .scale(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
        );
  }

  Color _getNoiseColor() {
    if (widget.decibelLevel < 50) return AppConstants.noiseQuiet;
    if (widget.decibelLevel < 70) return AppConstants.noiseModerate;
    if (widget.decibelLevel < 85) return AppConstants.noiseLoud;
    if (widget.decibelLevel < 100) return AppConstants.noiseVeryLoud;
    return AppConstants.noiseExtreme;
  }
}
