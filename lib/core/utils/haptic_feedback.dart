import 'package:flutter/services.dart';

/// HushSense haptic feedback utilities for premium UX
class HushHaptics {
  /// Gentle haptic feedback for button taps
  static Future<void> lightTap() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium haptic feedback for important actions
  static Future<void> mediumTap() async {
    await HapticFeedback.mediumImpact();
  }

  /// Strong haptic feedback for critical actions
  static Future<void> heavyTap() async {
    await HapticFeedback.heavyImpact();
  }

  /// Subtle vibration for measurement start/stop
  static Future<void> measurementFeedback() async {
    await HapticFeedback.selectionClick();
  }

  /// Success feedback for completed actions
  static Future<void> successFeedback() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  /// Error feedback for failed actions
  static Future<void> errorFeedback() async {
    await HapticFeedback.heavyImpact();
  }

  /// Gentle notification feedback
  static Future<void> notificationFeedback() async {
    await HapticFeedback.selectionClick();
  }
}
