import 'package:flutter/material.dart';

class AppConstants {
  // Card & Border Colors
  static const Color cardBackground = surfaceColor;
  static const Color borderColor = Color(0xFFE5E7EB); // Tailwind gray-200

  // App Information
  static const String appName = 'HushSense';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'The world\'s largest decentralized urban noise mapping platform';

  // HushSense Brand Colors - Inspired by Logo
  static const Color primaryTeal = Color(0xFF3ABAB4);
  static const Color deepBlue = Color(0xFF1C2A4D);
  static const Color mutedGreenBg = Color(0xFFF6FAF9); // Softer off-white/gray for less eye fatigue
  static const Color softGray = Color(0xFFB0BEC5);
  static const Color pureWhite = Color(0xFFFFFFFF);
  
  // Legacy Colors (for backward compatibility)
  static const Color primaryColor = primaryTeal;
  static const Color primaryDarkColor = deepBlue;
  static const Color secondaryColor = Color(0xFF10B981);
  static const Color accentColor = primaryTeal;
  static const Color backgroundColor = mutedGreenBg; // Use softened off-white
  static const Color surfaceColor = Color(0xFFF9FBFC); // Slightly off-white for cards/containers
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF97316);
  static const Color successColor = Color(0xFF22C55E);

  // Text Colors - HushSense Theme
  static const Color textPrimary = deepBlue;
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = softGray;
  static const Color textOnTeal = pureWhite;

  // Noise Level Colors - HushSense Theme
  static const Color noiseQuiet = primaryTeal;
  static const Color noiseModerate = Color(0xFF3ABAB4);
  static const Color noiseLoud = Color(0xFFF97316);
  static const Color noiseVeryLoud = Color(0xFFEF4444);
  static const Color noiseExtreme = Color(0xFF7C2D12);

  // Additional Accent Colors
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color accentOrange = Color(0xFFF97316);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121A2F);
  static const Color darkSurface = Color(0xFF1A2332);
  static const Color darkTextPrimary = Color(0xFFCFD8DC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Dimensions
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  // Animation Durations - Premium Feel
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationGentle = Duration(milliseconds: 800);
  static const Duration waveformPulse = Duration(milliseconds: 1500);
  
  // Animation Curves - Smooth & Premium
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve gentleSpring = Curves.elasticOut;
  static const Curve smoothFade = Curves.easeInOutQuart;

  // Noise Measurement Constants
  static const double minDecibelLevel = 30.0;
  static const double maxDecibelLevel = 120.0;
  static const int measurementDurationSeconds = 10;
  static const int passiveMeasurementIntervalSeconds = 300; // 5 minutes

  // Rewards Constants
  static const int baseRewardPerMeasurement = 10;
  static const int venueCheckInReward = 50;
  static const int dailyStreakBonus = 5;
  static int weeklyBonus =
      100; // Changed to non-const for potential future dynamic updates

  // Map Constants
  static const double defaultMapZoom = 15.0;
  static const double maxMapZoom = 20.0;
  static const double minMapZoom = 10.0;

  // API Endpoints (to be configured)
  static const String baseApiUrl = 'https://api.hushsense.com';
  static const String hederaNetworkUrl = 'https://testnet.hashscan.io';

  // Feature Flags
  static const bool enablePassiveMode =
      false; // Will be enabled in future versions
  static const bool enableHederaIntegration =
      false; // Will be enabled when Hedera SDK is ready
  static const bool enableAds = false; // Will be enabled in production

  // Privacy & Security
  static const int maxDataRetentionDays = 365;
  static const bool enableDataAnonymization = true;
  static const bool enableLocationPrecisionReduction = true;
}
