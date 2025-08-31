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
        final baseOcean = ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: brightness,
        );
        if (brightness == Brightness.light) {
          return baseOcean.copyWith(
            surface: const Color(0xFFF7FAFD),
            surfaceContainer: const Color(0xFFE6F0FA),
            surfaceContainerHighest: const Color(0xFFD9E9F7),
            primary: const Color(0xFF0D57A4),
            onPrimary: Colors.white,
            primaryContainer: const Color(0xFFB3D4FF),
            onPrimaryContainer: const Color(0xFF002E5C),
            secondary: const Color(0xFF0277BD),
            tertiary: const Color(0xFF00ACC1),
            outline: const Color(0xFF4F6B85),
          );
        } else {
          return baseOcean.copyWith(
            surface: const Color(0xFF071923),
            surfaceContainer: const Color(0xFF0F2734),
            surfaceContainerHighest: const Color(0xFF143140),
            primary: const Color(0xFF64B5F6),
            onPrimary: const Color(0xFF002B49),
            primaryContainer: const Color(0xFF0D4364),
            onPrimaryContainer: const Color(0xFFBFE1FF),
            secondary: const Color(0xFF29B6F6),
            tertiary: const Color(0xFF26C6DA),
            outline: const Color(0xFF4D6B7B),
          );
        }
      case AppThemeMode.forestGreen:
        final baseForest = ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: brightness,
        );
        if (brightness == Brightness.light) {
          return baseForest.copyWith(
            surface: const Color(0xFFF6FBF5),
            surfaceContainer: const Color(0xFFE6F3E5),
            surfaceContainerHighest: const Color(0xFFD9EAD8),
            primary: const Color(0xFF1B6B25),
            primaryContainer: const Color(0xFFBCE5BF),
            onPrimaryContainer: const Color(0xFF06330C),
            secondary: const Color(0xFF388E3C),
            tertiary: const Color(0xFF8D6E63),
            outline: const Color(0xFF5C745D),
          );
        } else {
          return baseForest.copyWith(
            surface: const Color(0xFF101F13),
            surfaceContainer: const Color(0xFF1B2B1E),
            surfaceContainerHighest: const Color(0xFF223526),
            primary: const Color(0xFF81C784),
            onPrimary: const Color(0xFF083913),
            primaryContainer: const Color(0xFF1F4F24),
            onPrimaryContainer: const Color(0xFFCDECCF),
            secondary: const Color(0xFF66BB6A),
            tertiary: const Color(0xFFA1887F),
            outline: const Color(0xFF517055),
          );
        }
      case AppThemeMode.purpleNight:
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A1B9A),
          brightness: Brightness.dark,
        );
      case AppThemeMode.goldLuxury:
        final baseGold = ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8F00),
          brightness: brightness,
        );
        if (brightness == Brightness.light) {
          return baseGold.copyWith(
            surface: const Color(0xFFFCFAF6),
            surfaceContainer: const Color(0xFFF3E8D6),
            surfaceContainerHighest: const Color(0xFFE6D9C5),
            primary: const Color(0xFFB26A00),
            primaryContainer: const Color(0xFFFFDDAE),
            onPrimaryContainer: const Color(0xFF402400),
            secondary: const Color(0xFFC77800),
            tertiary: const Color(0xFF795548),
            outline: const Color(0xFF8B7155),
          );
        } else {
          return baseGold.copyWith(
            surface: const Color(0xFF20160A),
            surfaceContainer: const Color(0xFF2C2114),
            surfaceContainerHighest: const Color(0xFF3A2D1F),
            primary: const Color(0xFFFFCA7A),
            onPrimary: const Color(0xFF3D2500),
            primaryContainer: const Color(0xFF5C3A00),
            onPrimaryContainer: const Color(0xFFFFE3B6),
            secondary: const Color(0xFFFFB74D),
            tertiary: const Color(0xFFD7CCC8),
            outline: const Color(0xFF786047),
          );
        }
      case AppThemeMode.solarSunrise:
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7043), // Warm orange
          brightness: brightness,
        );
      case AppThemeMode.cyberNeon:
        final baseNeon = ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E5FF),
          brightness: Brightness.dark,
        );
        return baseNeon.copyWith(
          // Deep techno purple/blue base distinct from generic dark
          surface: const Color(0xFF070013),
          surfaceContainer: const Color(0xFF100026),
          surfaceContainerHighest: const Color(0xFF1E0040),
          onSurface: const Color(0xFFF5E8FF), // lavender white
          primary: const Color(0xFF00F5FF), // neon cyan
          onPrimary: const Color(0xFF001C1F),
          primaryContainer: const Color(0xFF003F47),
          onPrimaryContainer: const Color(0xFF8CF9FF),
          secondary: const Color(0xFFFF1FAE), // hot magenta
          tertiary: const Color(0xFFB347FF), // vivid purple
          outline: const Color(0xFF5A2F7A),
        );
      case AppThemeMode.midnightTeal:
        final baseTeal = ColorScheme.fromSeed(
          seedColor: const Color(0xFF009688),
          brightness: Brightness.dark,
        );
        return baseTeal.copyWith(
          // Teal/green base distinct from system dark or neon
          surface: const Color(0xFF001F1C),
          surfaceContainer: const Color(0xFF002B28),
          surfaceContainerHighest: const Color(0xFF003A36),
          onSurface: const Color(0xFFD1FFF5), // soft mint white
          primary: const Color(0xFF00C9A5), // saturated teal-green
          onPrimary: const Color(0xFF00201A),
          primaryContainer: const Color(0xFF005047),
          onPrimaryContainer: const Color(0xFF8CF6E4),
          secondary: const Color(0xFF008FA6), // blue-teal contrast
          tertiary: const Color(0xFF5DF27C), // bright green accent
          outline: const Color(0xFF2E6059),
        );
    }
  }
}