import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/app_constants.dart';

/// Subtle waveform animation widget for HushSense premium feel
class WaveformAnimation extends StatefulWidget {
  final bool isActive;
  final double amplitude;
  final Color color;
  final double height;
  final int waveCount;
  final Duration duration;
  final double barWidth;
  final double spacing;

  const WaveformAnimation({
    super.key,
    this.isActive = true,
    this.amplitude = 1.0,
    this.color = AppConstants.primaryTeal,
    this.height = 60,
    this.waveCount = 5,
    this.duration = AppConstants.waveformPulse,
    this.barWidth = 4,
    this.spacing = 2,
  });

  @override
  State<WaveformAnimation> createState() => _WaveformAnimationState();
}

class _WaveformAnimationState extends State<WaveformAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<AnimationController> _waveControllers;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Create individual controllers for each wave bar
    _waveControllers = List.generate(
      widget.waveCount,
      (index) => AnimationController(
        duration: Duration(
          milliseconds: widget.duration.inMilliseconds + (index * 100),
        ),
        vsync: this,
      ),
    );

    if (widget.isActive) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _controller.repeat();
    for (int i = 0; i < _waveControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) {
          _waveControllers[i].repeat();
        }
      });
    }
  }

  void _stopAnimation() {
    _controller.stop();
    for (var controller in _waveControllers) {
      controller.stop();
    }
  }

  @override
  void didUpdateWidget(WaveformAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _waveControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Compute dynamic bar width/spacing to fit within maxWidth
          final maxW = constraints.maxWidth.isFinite ? constraints.maxWidth : double.infinity;
          double barW = widget.barWidth;
          double space = widget.spacing;

          if (maxW.isFinite) {
            // Each bar has horizontal margin on both sides, so account for all margins
            final n = widget.waveCount.toDouble();
            final totalNeeded = n * barW + n * (space * 2);
            if (totalNeeded > maxW) {
              // subtract a tiny epsilon to avoid rounding overflow
              final scale = (maxW - 0.5) / totalNeeded;
              barW = (barW * scale).clamp(1.0, barW);
              space = (space * scale).clamp(0.0, space);
            }
          }

          return ClipRect(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(widget.waveCount, (index) {
                  return AnimatedBuilder(
                    animation: _waveControllers[index],
                    builder: (context, child) {
                      final progress = _waveControllers[index].value;
                      double rawHeight = widget.height * (0.2 + 0.8 * widget.amplitude * math.sin(progress * 2 * math.pi));
                      final height = rawHeight.clamp(6.0, widget.height);

                      return Container(
                        width: barW,
                        height: height,
                        margin: EdgeInsets.symmetric(horizontal: space),
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: 
                            widget.isActive ? 0.8 : 0.3,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Gentle pulse animation for measurement indicators
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final double minScale;
  final double maxScale;
  final Duration duration;

  const PulseAnimation({
    super.key,
    required this.child,
    this.isActive = true,
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.duration = AppConstants.waveformPulse,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppConstants.smoothFade,
    ));

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isActive ? _scaleAnimation.value : 1.0,
          child: widget.child,
        );
      },
    );
  }
}

/// Ripple effect for measurement circles
class RippleEffect extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final Color color;
  final int rippleCount;
  final Duration duration;

  const RippleEffect({
    super.key,
    required this.child,
    this.isActive = true,
    this.color = AppConstants.primaryTeal,
    this.rippleCount = 3,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.rippleCount,
      (index) => AnimationController(
        duration: widget.duration,
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
      );
    }).toList();

    if (widget.isActive) {
      _startRipples();
    }
  }

  void _startRipples() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 400), () {
        if (mounted && widget.isActive) {
          _controllers[i].repeat();
        }
      });
    }
  }

  void _stopRipples() {
    for (var controller in _controllers) {
      controller.stop();
      controller.reset();
    }
  }

  @override
  void didUpdateWidget(RippleEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _startRipples();
      } else {
        _stopRipples();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Ripple circles
        ...List.generate(widget.rippleCount, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final progress = _animations[index].value;
              final scale = 1.0 + (progress * 0.5);
              final opacity = 1.0 - progress;

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color.withValues(alpha: widget.isActive ? opacity * 0.3 : 0.0),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          );
        }),
        // Child widget
        widget.child,
      ],
    );
  }
}

/// Smooth fade transition for UI elements
class SmoothFadeTransition extends StatefulWidget {
  final Widget child;
  final bool visible;
  final Duration duration;
  final Curve curve;

  const SmoothFadeTransition({
    super.key,
    required this.child,
    this.visible = true,
    this.duration = AppConstants.animationNormal,
    this.curve = AppConstants.smoothFade,
  });

  @override
  State<SmoothFadeTransition> createState() => _SmoothFadeTransitionState();
}

class _SmoothFadeTransitionState extends State<SmoothFadeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.visible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(SmoothFadeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}
