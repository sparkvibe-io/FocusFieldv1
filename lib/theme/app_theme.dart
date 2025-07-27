import 'package:flutter/material.dart';
import 'package:silence_score/providers/theme_provider.dart';
import 'package:silence_score/services/accessibility_service.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(AppThemeMode.light);
  static ThemeData get darkTheme => _buildTheme(AppThemeMode.dark);
  
  static ThemeData getThemeForMode(AppThemeMode mode, {bool enableHighContrast = false}) => 
      _buildTheme(mode, enableHighContrast: enableHighContrast);

  static ThemeData _buildTheme(AppThemeMode mode, {bool enableHighContrast = false}) {
    final brightness = mode.themeMode == ThemeMode.dark || mode == AppThemeMode.purpleNight 
        ? Brightness.dark 
        : Brightness.light;
    
    var colorScheme = _getColorScheme(mode, brightness);
    
    // Apply high contrast adjustments if enabled
    if (enableHighContrast) {
      final accessibilityService = AccessibilityService();
      colorScheme = accessibilityService.adjustColorSchemeForContrast(colorScheme);
    }
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surfaceContainer,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  static ColorScheme _getColorScheme(AppThemeMode mode, Brightness brightness) {
    switch (mode) {
      case AppThemeMode.system:
        return brightness == Brightness.dark 
            ? ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark)
            : ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light);
      case AppThemeMode.light:
        return ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light);
      case AppThemeMode.dark:
        return ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);
      case AppThemeMode.oceanBlue:
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: brightness,
        );
      case AppThemeMode.forestGreen:
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: brightness,
        );
      case AppThemeMode.purpleNight:
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A1B9A),
          brightness: Brightness.dark,
        );
      case AppThemeMode.goldLuxury:
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8F00),
          brightness: brightness,
        );
    }
  }
}