import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Funnel Sans', // Global app font (variable)

      // HushSense Color Scheme - Inspired by Logo
      colorScheme: const ColorScheme.light(
        primary: AppConstants.primaryTeal,
        onPrimary: AppConstants.pureWhite,
        primaryContainer: AppConstants.mutedGreenBg,
        onPrimaryContainer: AppConstants.deepBlue,

        secondary: AppConstants.primaryTeal,
        onSecondary: AppConstants.pureWhite,
        secondaryContainer: AppConstants.mutedGreenBg,
        onSecondaryContainer: AppConstants.deepBlue,

        tertiary: AppConstants.deepBlue,
        onTertiary: AppConstants.pureWhite,
        tertiaryContainer: Color(0xFFE8F4FD),
        onTertiaryContainer: AppConstants.deepBlue,

        error: AppConstants.errorColor,
        onError: AppConstants.pureWhite,
        errorContainer: Color(0xFFFEE2E2),
        onErrorContainer: Color(0xFF991B1B),
        
        surface: AppConstants.pureWhite,
        onSurface: AppConstants.deepBlue,
        surfaceContainerHighest: AppConstants.mutedGreenBg,
        onSurfaceVariant: AppConstants.textSecondary,
        
        outline: AppConstants.softGray,
        outlineVariant: Color(0xFFE2E8F0),
        
        shadow: Color(0x1A000000),
        scrim: Color(0x52000000),
        inverseSurface: AppConstants.deepBlue,
        onInverseSurface: AppConstants.pureWhite,
        inversePrimary: AppConstants.primaryTeal,
      ),

      // Background Color
      scaffoldBackgroundColor: AppConstants.mutedGreenBg,

      // App Bar Theme - HushSense Style
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppConstants.mutedGreenBg,
        foregroundColor: AppConstants.deepBlue,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppConstants.deepBlue,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 600)],
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Card Theme - Premium HushSense Style
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppConstants.pureWhite,
        shadowColor: AppConstants.deepBlue.withValues(alpha: 0.08),
      ),

      // Elevated Button Theme - Teal Primary
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppConstants.primaryTeal,
          foregroundColor: AppConstants.pureWhite,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Funnel Sans',
            fontVariations: [FontVariation('wght', 560)],
          ),
          animationDuration: AppConstants.animationNormal,
        ),
      ),

      // Outlined Button Theme - Teal Border
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.primaryTeal,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          side: const BorderSide(color: AppConstants.primaryTeal, width: 1.5),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Funnel Sans',
            fontVariations: [FontVariation('wght', 560)],
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingM,
            vertical: AppConstants.paddingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Funnel Sans',
            fontVariations: [FontVariation('wght', 520)],
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(
            color: AppConstants.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(color: AppConstants.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(
            color: AppConstants.errorColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingM,
          vertical: AppConstants.paddingM,
        ),
        hintStyle: const TextStyle(
          color: AppConstants.textTertiary,
          fontSize: 16,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 430)],
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConstants.surfaceColor,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: AppConstants.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 560)],
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 480)],
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppConstants.backgroundColor,
        selectedColor: AppConstants.primaryColor.withValues(alpha: 0.1),
        disabledColor: AppConstants.textTertiary.withValues(alpha: 0.1),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 500)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        elevation: 0,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFFCBD5E1),
        thickness: 1,
        space: 1,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 420)],
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 420)],
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 420)],
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 680)],
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 660)],
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 640)],
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 600)],
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 560)],
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 540)],
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 450)],
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 440)],
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppConstants.textSecondary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 430)],
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 560)],
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 540)],
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppConstants.textSecondary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 520)],
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Funnel Sans',

      // HushSense Dark Mode Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.primaryTeal,
        onPrimary: AppConstants.pureWhite,
        primaryContainer: AppConstants.darkSurface,
        onPrimaryContainer: AppConstants.primaryTeal,

        secondary: AppConstants.primaryTeal,
        onSecondary: AppConstants.pureWhite,
        secondaryContainer: AppConstants.darkSurface,
        onSecondaryContainer: AppConstants.primaryTeal,

        tertiary: AppConstants.mutedGreenBg,
        onTertiary: AppConstants.deepBlue,
        tertiaryContainer: AppConstants.darkSurface,
        onTertiaryContainer: AppConstants.mutedGreenBg,

        error: AppConstants.errorColor,
        onError: AppConstants.pureWhite,
        
        surface: AppConstants.darkBackground,
        onSurface: AppConstants.darkTextPrimary,
        surfaceContainerHighest: AppConstants.darkSurface,
        onSurfaceVariant: AppConstants.darkTextSecondary,
        
        outline: AppConstants.softGray,
        outlineVariant: Color(0xFF374151),
        
        shadow: Color(0x40000000),
        scrim: Color(0x80000000),
        inverseSurface: AppConstants.pureWhite,
        onInverseSurface: AppConstants.deepBlue,
        inversePrimary: AppConstants.deepBlue,
      ),

      scaffoldBackgroundColor: AppConstants.darkBackground,

      // Dark Mode App Bar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppConstants.darkBackground,
        foregroundColor: AppConstants.darkTextPrimary,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 600)],
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Dark Mode Cards
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppConstants.darkSurface,
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),

      // Complete dark theme button styles
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppConstants.primaryTeal,
          foregroundColor: AppConstants.pureWhite,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Funnel Sans',
            fontVariations: [FontVariation('wght', 560)],
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.primaryTeal,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          side: const BorderSide(color: AppConstants.primaryTeal, width: 1.5),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Funnel Sans',
            fontVariations: [FontVariation('wght', 560)],
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.primaryTeal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingM,
            vertical: AppConstants.paddingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Funnel Sans',
            fontVariations: [FontVariation('wght', 520)],
          ),
        ),
      ),

      // Dark input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(
            color: AppConstants.primaryTeal,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(color: AppConstants.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(
            color: AppConstants.errorColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingM,
          vertical: AppConstants.paddingM,
        ),
        hintStyle: const TextStyle(
          color: AppConstants.darkTextSecondary,
          fontSize: 16,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 430)],
        ),
      ),

      // Dark bottom navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConstants.darkSurface,
        selectedItemColor: AppConstants.primaryTeal,
        unselectedItemColor: AppConstants.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 560)],
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 480)],
        ),
      ),

      // Dark text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 420)],
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 420)],
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 420)],
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 680)],
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 660)],
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 640)],
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 600)],
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 560)],
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 540)],
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 450)],
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 440)],
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppConstants.darkTextSecondary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 430)],
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 560)],
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppConstants.darkTextPrimary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 540)],
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppConstants.darkTextSecondary,
          fontFamily: 'Funnel Sans',
          fontVariations: [FontVariation('wght', 520)],
        ),
      ),
    );
  }
}
