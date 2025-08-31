import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system,
  light,
  dark,
  // Premium themes
  oceanBlue,
  forestGreen,
  purpleNight,
  goldLuxury,
  solarSunrise, // Warm energizing palette
  midnightTeal, // Deep modern teal with cyan & lime accents
  cyberNeon, // Vibrant futuristic neon
}

extension AppThemeModeExtension on AppThemeMode {
  String get displayName {
    switch (this) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.oceanBlue:
        return 'Ocean Blue';
      case AppThemeMode.forestGreen:
        return 'Forest Green';
      case AppThemeMode.purpleNight:
        return 'Purple Night';
      case AppThemeMode.goldLuxury:
        return 'Gold Luxury';
      case AppThemeMode.solarSunrise:
        return 'Solar Sunrise';
      case AppThemeMode.cyberNeon:
        return 'Cyber Neon';
      case AppThemeMode.midnightTeal:
        return 'Midnight Teal';
    }
  }

  bool get isPremium {
    switch (this) {
      case AppThemeMode.system:
      case AppThemeMode.light:
      case AppThemeMode.dark:
        return false;
      case AppThemeMode.oceanBlue:
      case AppThemeMode.forestGreen:
      case AppThemeMode.purpleNight:
      case AppThemeMode.goldLuxury:
  case AppThemeMode.solarSunrise:
  case AppThemeMode.midnightTeal:
  case AppThemeMode.cyberNeon:
        return true;
    }
  }

  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
      case AppThemeMode.oceanBlue:
      case AppThemeMode.forestGreen:
      case AppThemeMode.goldLuxury:
  case AppThemeMode.solarSunrise:
        return ThemeMode.light;
      case AppThemeMode.dark:
      case AppThemeMode.purpleNight:
  case AppThemeMode.midnightTeal:
  case AppThemeMode.cyberNeon:
        return ThemeMode.dark;
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeMode.system:
        return Icons.brightness_auto;
      case AppThemeMode.light:
        return Icons.brightness_high;
      case AppThemeMode.dark:
        return Icons.brightness_low;
      case AppThemeMode.oceanBlue:
        return Icons.water;
      case AppThemeMode.forestGreen:
        return Icons.forest;
      case AppThemeMode.purpleNight:
        return Icons.nightlight;
      case AppThemeMode.goldLuxury:
        return Icons.diamond;
      case AppThemeMode.solarSunrise:
        return Icons.wb_sunny;
      case AppThemeMode.cyberNeon:
        return Icons.bolt;
      case AppThemeMode.midnightTeal:
        return Icons.dark_mode;
    }
  }

  Color get primaryColor {
    switch (this) {
      case AppThemeMode.system:
      case AppThemeMode.light:
      case AppThemeMode.dark:
        return Colors.blue;
      case AppThemeMode.oceanBlue:
        return const Color(0xFF0288D1);
      case AppThemeMode.forestGreen:
        return const Color(0xFF2E7D32);
      case AppThemeMode.purpleNight:
        return const Color(0xFF673AB7);
      case AppThemeMode.goldLuxury:
        return const Color(0xFFFFB300);
      case AppThemeMode.solarSunrise:
        return const Color(0xFFFF7043); // Deep orange
      case AppThemeMode.cyberNeon:
        return const Color(0xFF00E5FF); // Neon cyan
      case AppThemeMode.midnightTeal:
        return const Color(0xFF009688); // Teal accent
    }
  }

  String get description {
    switch (this) {
      case AppThemeMode.system:
        return 'Follows system theme';
      case AppThemeMode.light:
        return 'Light theme';
      case AppThemeMode.dark:
        return 'Dark theme';
      case AppThemeMode.oceanBlue:
        return 'Calm ocean blues';
      case AppThemeMode.forestGreen:
        return 'Natural forest greens';
      case AppThemeMode.purpleNight:
        return 'Mystical purple night';
      case AppThemeMode.goldLuxury:
        return 'Elegant gold accents';
      case AppThemeMode.solarSunrise:
        return 'Warm sunrise energy';
      case AppThemeMode.cyberNeon:
        return 'Futuristic neon glow';
      case AppThemeMode.midnightTeal:
        return 'Deep teal focus';
    }
  }
}

// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  static const String _themeKey = 'app_theme_mode';
  
  ThemeNotifier() : super(AppThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      if (mounted) {
        if (themeIndex >= 0 && themeIndex < AppThemeMode.values.length) {
          state = AppThemeMode.values[themeIndex];
        } else {
          state = AppThemeMode.system;
        }
      }
    } catch (e) {
      // If there's an error, default to system theme
      if (mounted) {
        state = AppThemeMode.system;
      }
    }
  }

  Future<void> setTheme(AppThemeMode theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme.index);
      if (mounted) {
        state = theme;
      }
    } catch (e) {
      // Handle error silently or show user feedback
    }
  }

  void cycleTheme({bool hasPremiumAccess = false}) {
    // Define available themes based on premium access
    final availableThemes = hasPremiumAccess 
        ? AppThemeMode.values 
        : [AppThemeMode.system, AppThemeMode.light, AppThemeMode.dark];
    
    final currentIndex = availableThemes.indexOf(state);
    final nextIndex = currentIndex >= 0 
        ? (currentIndex + 1) % availableThemes.length
        : 0;
    
    setTheme(availableThemes[nextIndex]);
  }
  
  // Method to reset to free theme if user loses premium access
  void resetToFreeThemeIfNeeded({required bool hasPremiumAccess}) {
    if (!hasPremiumAccess && state.isPremium) {
      setTheme(AppThemeMode.system);
    }
  }
}
