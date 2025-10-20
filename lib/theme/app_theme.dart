import 'package:flutter/material.dart';
import 'package:focus_field/providers/theme_provider.dart';
import 'package:focus_field/services/accessibility_service.dart';
import 'package:focus_field/theme/theme_extensions.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(AppThemeMode.light);
  static ThemeData get darkTheme => _buildTheme(AppThemeMode.dark);

  static ThemeData getThemeForMode(
    AppThemeMode mode, {
    bool enableHighContrast = false,
  }) => _buildTheme(mode, enableHighContrast: enableHighContrast);

  static ThemeData _buildTheme(
    AppThemeMode mode, {
    bool enableHighContrast = false,
  }) {
    final brightness =
        mode.themeMode == ThemeMode.dark || mode == AppThemeMode.purpleNight
            ? Brightness.dark
            : Brightness.light;

    var colorScheme = _getColorScheme(mode, brightness);

    // Apply high contrast adjustments if enabled
    if (enableHighContrast) {
      final accessibilityService = AccessibilityService();
      colorScheme = accessibilityService.adjustColorSchemeForContrast(
        colorScheme,
      );
    }

    // Neutral dramatic extension and standard decorations for all themes
    DramaticThemeStyling dramatic = DramaticThemeStyling.neutral();
    AppDecorations decorations = AppDecorations.standard();
    // All themes now use neutral backgrounds with standard decorations (no gradients, no glowing borders)

    final highContrast = enableHighContrast;
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [dramatic, decorations],
      // All themes use standard surface background (no transparency)
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        toolbarHeight: 56,
      ),
      cardTheme: _cardThemeFor(mode, colorScheme, highContrast),
      elevatedButtonTheme: _elevatedButtonThemeFor(mode, colorScheme),
      outlinedButtonTheme: _outlinedButtonThemeFor(mode, colorScheme),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      textTheme: _textThemeFor(mode, colorScheme).apply(
        bodyColor: highContrast ? colorScheme.onSurface : null,
        displayColor: highContrast ? colorScheme.onSurface : null,
      ),
      dividerTheme: DividerThemeData(
        thickness: highContrast ? 1.2 : null,
        color: highContrast ? colorScheme.onSurface : null,
      ),
      listTileTheme:
          highContrast
              ? ListTileThemeData(
                iconColor: colorScheme.onSurface,
                textColor: colorScheme.onSurface,
                tileColor: colorScheme.surface,
                selectedColor: colorScheme.primary,
              )
              : null,
    );
  }

  static ColorScheme _getColorScheme(AppThemeMode mode, Brightness brightness) {
    switch (mode) {
      case AppThemeMode.system:
        return brightness == Brightness.dark
            ? _getColorScheme(AppThemeMode.dark, Brightness.dark)
            : _getColorScheme(AppThemeMode.light, Brightness.light);
      case AppThemeMode.light:
        final baseLight = ColorScheme.fromSeed(
          seedColor: const Color(0xFF00897B), // Vibrant Teal
          brightness: Brightness.light,
        );
        return baseLight.copyWith(
          surface: const Color(
            0xFFFAFAFA,
          ), // Soft neutral gray - easier on eyes
          surfaceContainer: const Color(0xFFF5F5F5), // Slightly darker neutral
          surfaceContainerHighest: const Color(
            0xFFFFFFFF,
          ), // Pure white cards for contrast
          primary: const Color(0xFF00897B), // Vibrant Teal
          secondary: const Color(0xFF00BFA5), // Bright Teal Accent
          tertiary: const Color(0xFFFF6F00), // Energetic Orange
          onPrimary: Colors.white,
          outline: baseLight.outline, // Full visibility
        );
      case AppThemeMode.dark:
        final baseDark = ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E5E5), // Electric Cyan
          brightness: Brightness.dark,
        );
        return baseDark.copyWith(
          surface: const Color(
            0xFF1E1E1E,
          ), // Neutral dark gray - easier on eyes (VS Code-style)
          surfaceContainer: const Color(0xFF2A2A2A), // Slightly lighter neutral
          surfaceContainerHighest: const Color(
            0xFF353535,
          ), // Elevated dark cards - neutral gray for better readability
          primary: const Color(0xFF00E5E5), // Electric Cyan
          secondary: const Color(0xFF00FFC6), // Neon Teal
          tertiary: const Color(0xFFFFB74D), // Warm Gold
          onPrimary: const Color(0xFF001414), // Darker for contrast
          outline: baseDark.outline, // Full visibility
        );
      case AppThemeMode.oceanBlue:
        final baseOcean = ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: brightness,
        );
        if (brightness == Brightness.light) {
          return baseOcean.copyWith(
            // Neutral backgrounds matching industry standards
            surface: const Color(0xFFFAFAFA), // Soft neutral gray
            surfaceContainer: const Color(
              0xFFF5F5F5,
            ), // Slightly darker neutral
            surfaceContainerHighest: const Color(
              0xFFFFFFFF,
            ), // Pure white cards
            // Keep blue accents for theme identity
            primary: const Color(0xFF0D57A4),
            onPrimary: Colors.white,
            primaryContainer: const Color(0xFFB3D4FF),
            onPrimaryContainer: const Color(0xFF002E5C),
            secondary: const Color(0xFF0277BD),
            tertiary: const Color(0xFF00ACC1),
            outline: baseOcean.outline, // Standard outline
          );
        } else {
          return baseOcean.copyWith(
            // Neutral backgrounds matching industry standards
            surface: const Color(
              0xFF1E1E1E,
            ), // Neutral dark gray (VS Code style)
            surfaceContainer: const Color(
              0xFF2A2A2A,
            ), // Slightly lighter neutral
            surfaceContainerHighest: const Color(
              0xFF353535,
            ), // Elevated dark cards
            // Keep blue accents for theme identity
            primary: const Color(0xFF64B5F6),
            onPrimary: const Color(0xFF002B49),
            primaryContainer: const Color(0xFF0D4364),
            onPrimaryContainer: const Color(0xFFBFE1FF),
            secondary: const Color(0xFF29B6F6),
            tertiary: const Color(0xFF26C6DA),
            outline: baseOcean.outline, // Standard outline
          );
        }
      case AppThemeMode.forestGreen:
        final baseForest = ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: brightness,
        );
        if (brightness == Brightness.light) {
          return baseForest.copyWith(
            // Neutral backgrounds matching industry standards
            surface: const Color(0xFFFAFAFA), // Soft neutral gray
            surfaceContainer: const Color(
              0xFFF5F5F5,
            ), // Slightly darker neutral
            surfaceContainerHighest: const Color(
              0xFFFFFFFF,
            ), // Pure white cards
            // Keep green accents for theme identity
            primary: const Color(0xFF1B6B25),
            primaryContainer: const Color(0xFFBCE5BF),
            onPrimaryContainer: const Color(0xFF06330C),
            secondary: const Color(0xFF388E3C),
            tertiary: const Color(0xFF8D6E63),
            outline: baseForest.outline, // Standard outline
          );
        } else {
          return baseForest.copyWith(
            // Neutral backgrounds matching industry standards
            surface: const Color(
              0xFF1E1E1E,
            ), // Neutral dark gray (VS Code style)
            surfaceContainer: const Color(
              0xFF2A2A2A,
            ), // Slightly lighter neutral
            surfaceContainerHighest: const Color(
              0xFF353535,
            ), // Elevated dark cards
            // Keep green accents for theme identity
            primary: const Color(0xFF81C784),
            onPrimary: const Color(0xFF083913),
            primaryContainer: const Color(0xFF1F4F24),
            onPrimaryContainer: const Color(0xFFCDECCF),
            secondary: const Color(0xFF66BB6A),
            tertiary: const Color(0xFFA1887F),
            outline: baseForest.outline, // Standard outline
          );
        }
      case AppThemeMode.purpleNight:
        final basePurple = ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A1B9A),
          brightness: Brightness.dark,
        );
        return basePurple.copyWith(
          // Subtle purple tint (5% shift) for theme differentiation
          surface: const Color(0xFF1E1A24), // +5% purple tint
          surfaceContainer: const Color(0xFF2A2530), // Subtle purple
          surfaceContainerHighest: const Color(
            0xFF353040,
          ), // Elevated cards with purple hint
          // CRITICAL: Change primary from cyan to purple for proper theme identity
          primary: const Color(0xFFBB86FC), // Material Purple 200
          onPrimary: const Color(0xFF3A1C60), // Darker purple for contrast
          secondary: const Color(0xFFCE93D8), // Light purple accent
          tertiary: const Color(0xFFE1BEE7), // Soft purple highlight
          outline: basePurple.outline, // Standard outline
        );
      case AppThemeMode.goldLuxury:
        final baseGold = ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8F00),
          brightness: brightness,
        );
        if (brightness == Brightness.light) {
          return baseGold.copyWith(
            // Neutral backgrounds matching industry standards
            surface: const Color(0xFFFAFAFA), // Soft neutral gray
            surfaceContainer: const Color(
              0xFFF5F5F5,
            ), // Slightly darker neutral
            surfaceContainerHighest: const Color(
              0xFFFFFFFF,
            ), // Pure white cards
            // Keep gold accents for theme identity
            primary: const Color(0xFFB26A00),
            primaryContainer: const Color(0xFFFFDDAE),
            onPrimaryContainer: const Color(0xFF402400),
            secondary: const Color(0xFFC77800),
            tertiary: const Color(0xFF795548),
            outline: baseGold.outline, // Standard outline
          );
        } else {
          return baseGold.copyWith(
            // Neutral backgrounds matching industry standards
            surface: const Color(
              0xFF1E1E1E,
            ), // Neutral dark gray (VS Code style)
            surfaceContainer: const Color(
              0xFF2A2A2A,
            ), // Slightly lighter neutral
            surfaceContainerHighest: const Color(
              0xFF353535,
            ), // Elevated dark cards
            // Keep gold accents for theme identity
            primary: const Color(0xFFFFCA7A),
            onPrimary: const Color(0xFF3D2500),
            primaryContainer: const Color(0xFF5C3A00),
            onPrimaryContainer: const Color(0xFFFFE3B6),
            secondary: const Color(0xFFFFB74D),
            tertiary: const Color(0xFFD7CCC8),
            outline: baseGold.outline, // Standard outline
          );
        }
      case AppThemeMode.solarSunrise:
        final baseSunrise = ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7043), // Warm orange
          brightness: brightness,
        );
        if (brightness == Brightness.light) {
          return baseSunrise.copyWith(
            // Neutral backgrounds matching industry standards
            surface: const Color(0xFFFAFAFA), // Soft neutral gray
            surfaceContainer: const Color(
              0xFFF5F5F5,
            ), // Slightly darker neutral
            surfaceContainerHighest: const Color(
              0xFFFFFFFF,
            ), // Pure white cards
            // Keep orange accents from seed color
            outline: baseSunrise.outline, // Standard outline
          );
        } else {
          return baseSunrise.copyWith(
            // Neutral backgrounds matching industry standards
            surface: const Color(
              0xFF1E1E1E,
            ), // Neutral dark gray (VS Code style)
            surfaceContainer: const Color(
              0xFF2A2A2A,
            ), // Slightly lighter neutral
            surfaceContainerHighest: const Color(
              0xFF353535,
            ), // Elevated dark cards
            // Keep orange accents from seed color
            outline: baseSunrise.outline, // Standard outline
          );
        }
      case AppThemeMode.cyberNeon:
        final baseNeon = ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E5FF),
          brightness: Brightness.dark,
        );
        return baseNeon.copyWith(
          // Subtle cool cyan tint (3% shift) for futuristic atmosphere
          surface: const Color(0xFF1A1E20), // +3% cool cyan tint
          surfaceContainer: const Color(0xFF252A2D), // Subtle cyan
          surfaceContainerHighest: const Color(
            0xFF30353A,
          ), // Elevated cards with cyan hint
          onSurface: const Color(0xFFFFFFFF), // Pure white text
          // Keep neon accents for theme identity
          primary: const Color(0xFF00FFFF), // Electric cyan - max brightness
          onPrimary: const Color(0xFF000000),
          primaryContainer: const Color(0xFF003D5C),
          onPrimaryContainer: const Color(0xFF00FFFF),
          secondary: const Color(0xFFFF00FF), // Pure magenta - max brightness
          tertiary: const Color(0xFF9D00FF), // Electric purple
          outline: baseNeon.outline, // Standard outline (no neon glow)
        );
      case AppThemeMode.midnightTeal:
        final baseTeal = ColorScheme.fromSeed(
          seedColor: const Color(0xFF009688),
          brightness: Brightness.dark,
        );
        return baseTeal.copyWith(
          // Subtle teal tint (3% shift) for ocean depth atmosphere
          surface: const Color(0xFF1A1E1E), // +3% teal tint
          surfaceContainer: const Color(0xFF252B2B), // Subtle teal
          surfaceContainerHighest: const Color(
            0xFF2F3538,
          ), // Elevated cards with teal hint
          onSurface: const Color(0xFFFFFFFF), // Standard white text
          // Keep teal accents for theme identity
          primary: const Color(0xFF00E5B8), // Vivid bioluminescent teal
          onPrimary: const Color(0xFF000000),
          primaryContainer: const Color(0xFF004D3D),
          onPrimaryContainer: const Color(0xFF7FFFD4), // Aquamarine glow
          secondary: const Color(0xFF00C9A0), // Bright jade
          tertiary: const Color(0xFF52FFAA), // Electric mint
          outline: baseTeal.outline, // Standard outline (no glow)
        );
    }
  }

  static CardThemeData _cardThemeFor(
    AppThemeMode mode,
    ColorScheme scheme,
    bool highContrast,
  ) {
    // Borderless by default with subtle background highlights (standard for all themes)
    final baseShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side:
          highContrast
              ? BorderSide(color: scheme.primary, width: 1.2)
              : BorderSide.none,
    );

    // All themes use standard card decoration (no glowing borders)
    return CardThemeData(
      elevation: highContrast ? 3 : 2,
      shape: baseShape,
      color: scheme.surfaceContainerHighest,
      shadowColor:
          highContrast
              ? scheme.onSurface.withValues(alpha: 0.4)
              : scheme.primary.withValues(alpha: 0.12),
      margin: EdgeInsets.zero,
    );
  }

  static ElevatedButtonThemeData _elevatedButtonThemeFor(
    AppThemeMode mode,
    ColorScheme scheme,
  ) {
    final base = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    // All themes use standard button styling (no glowing borders)
    return ElevatedButtonThemeData(
      style: base.merge(
        ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 4,
          shadowColor: scheme.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonThemeFor(
    AppThemeMode mode,
    ColorScheme scheme,
  ) {
    final base = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    // All themes use standard button styling (no glowing borders)
    return OutlinedButtonThemeData(
      style: base.merge(
        OutlinedButton.styleFrom(
          side: BorderSide(
            color: scheme.outline.withValues(alpha: 0.6),
            width: 1.0,
          ),
          foregroundColor: scheme.primary,
        ),
      ),
    );
  }

  static TextTheme _textThemeFor(AppThemeMode mode, ColorScheme scheme) {
    // All themes use standard text colors (no custom neon/teal tints)
    final base = ThemeData(brightness: scheme.brightness).textTheme.apply(
      displayColor: scheme.onSurface,
      bodyColor: scheme.onSurface,
    );
    return base;
  }
}
