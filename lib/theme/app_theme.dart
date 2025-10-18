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

    // Dramatic extension (default neutral)
    DramaticThemeStyling dramatic = DramaticThemeStyling.neutral();
    AppDecorations decorations = AppDecorations.standard();

    if (mode == AppThemeMode.cyberNeon) {
      dramatic = const DramaticThemeStyling(
        appBackgroundGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF000000), // Pure black
            Color(0xFF0A0020), // Deep purple-black
            Color(0xFF001520), // Midnight blue-black
            Color(0xFF000000), // Back to pure black
          ],
          stops: [0.0, 0.33, 0.66, 1.0],
        ),
        cardBackgroundGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF150028), Color(0xFF0A0015)],
        ),
        statAccentColors: [
          Color(0xFF00FFFF), // Electric cyan
          Color(0xFFFF00FF), // Pure magenta
          Color(0xFF9D00FF), // Electric purple
        ],
      );
      decorations = AppDecorations.premium(
        accentColor: const Color(0xFF00FFFF), // Brighter cyan for stronger glow
      );
    } else if (mode == AppThemeMode.midnightTeal) {
      dramatic = DramaticThemeStyling(
        appBackgroundGradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF000A09), // Deep ocean black
            Color(0xFF001412), // Darker teal abyss
            Color(0xFF002522), // Slightly lighter abyss
            Color(0xFF000A09), // Back to deep black
          ],
          stops: [0.0, 0.4, 0.7, 1.0],
        ),
        cardBackgroundGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF001F1D),
            const Color(0xFF001412).withValues(alpha: 0.90),
          ],
        ),
        statAccentColors: const [
          Color(0xFF00E5B8), // Bioluminescent teal
          Color(0xFF00C9A0), // Bright jade
          Color(0xFF52FFAA), // Electric mint
        ],
      );
      decorations = AppDecorations.premium(
        accentColor: const Color(0xFF00E5B8), // Brighter teal for stronger glow
      );
    }

    final highContrast = enableHighContrast;
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [dramatic, decorations],
      // Make scaffold transparent for dramatic premium themes so gradient shows through
      scaffoldBackgroundColor:
          (mode == AppThemeMode.cyberNeon || mode == AppThemeMode.midnightTeal)
              ? Colors.transparent
              : colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor:
            (mode == AppThemeMode.cyberNeon ||
                    mode == AppThemeMode.midnightTeal)
                ? Colors.transparent
                : colorScheme.surface,
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
          surface: Colors.white, // Pure White background
          surfaceContainer: const Color(0xFFF8FFFE), // Subtle teal tint
          surfaceContainerHighest:
              Colors.white, // White cards for high contrast
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
          surface: const Color(0xFF121416), // Slightly lighter for contrast
          surfaceContainer: const Color(0xFF1C2022), // Rich charcoal
          surfaceContainerHighest: const Color(
            0xFF262B2D,
          ), // Elevated dark cards - lighter for better borders
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
          // True cyberpunk: Ultra-bright neon on deep black with glowing accents
          surface: const Color(0xFF000000), // Pure black for maximum neon contrast
          surfaceContainer: const Color(0xFF0A0015), // Deep violet-black
          surfaceContainerHighest: const Color(0xFF150028), // Darker violet for cards
          onSurface: const Color(0xFFFFFFFF), // Pure white text
          primary: const Color(0xFF00FFFF), // Electric cyan - max brightness
          onPrimary: const Color(0xFF000000),
          primaryContainer: const Color(0xFF003D5C),
          onPrimaryContainer: const Color(0xFF00FFFF),
          secondary: const Color(0xFFFF00FF), // Pure magenta - max brightness
          tertiary: const Color(0xFF9D00FF), // Electric purple
          outline: const Color(0xFF00FFFF), // Cyan outline for neon glow
        );
      case AppThemeMode.midnightTeal:
        final baseTeal = ColorScheme.fromSeed(
          seedColor: const Color(0xFF009688),
          brightness: Brightness.dark,
        );
        return baseTeal.copyWith(
          // Deep ocean abyss: Darker, richer teal with bioluminescent accents
          surface: const Color(0xFF000A09), // Almost black with hint of teal
          surfaceContainer: const Color(0xFF001412), // Deep ocean floor
          surfaceContainerHighest: const Color(0xFF001F1D), // Slightly lighter for cards
          onSurface: const Color(0xFFD5FFF0), // Pale mint glow
          primary: const Color(0xFF00E5B8), // Vivid bioluminescent teal
          onPrimary: const Color(0xFF000000),
          primaryContainer: const Color(0xFF004D3D),
          onPrimaryContainer: const Color(0xFF7FFFD4), // Aquamarine glow
          secondary: const Color(0xFF00C9A0), // Bright jade
          tertiary: const Color(0xFF52FFAA), // Electric mint
          outline: const Color(0xFF00E5B8), // Teal outline for glow
        );
    }
  }

  static CardThemeData _cardThemeFor(
    AppThemeMode mode,
    ColorScheme scheme,
    bool highContrast,
  ) {
    // Borderless by default with subtle background highlights
    final baseShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side:
          highContrast
              ? BorderSide(color: scheme.primary, width: 1.2)
              : BorderSide.none,
    );

    switch (mode) {
      case AppThemeMode.cyberNeon:
        return CardThemeData(
          color: scheme.surfaceContainer.withValues(alpha: 0.8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF00FFF0), width: 1.2),
          ),
          margin: EdgeInsets.zero,
        );
      case AppThemeMode.midnightTeal:
        return CardThemeData(
          color: scheme.surfaceContainer.withValues(alpha: 0.85),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF004D39), width: 1.0),
          ),
          margin: EdgeInsets.zero,
        );
      default:
        // Cards with visible elevation and colored shadows for depth
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
  }

  static ElevatedButtonThemeData _elevatedButtonThemeFor(
    AppThemeMode mode,
    ColorScheme scheme,
  ) {
    final base = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    switch (mode) {
      case AppThemeMode.cyberNeon:
        return ElevatedButtonThemeData(
          style: base.merge(
            ElevatedButton.styleFrom(
              backgroundColor: scheme.primary.withValues(alpha: 0.08),
              foregroundColor: scheme.primary,
              shadowColor: scheme.primary.withValues(alpha: 0.4),
              elevation: 6,
              side: const BorderSide(color: Color(0xFF00FFF0), width: 1.2),
              overlayColor: scheme.secondary.withValues(alpha: 0.18),
            ),
          ),
        );
      case AppThemeMode.midnightTeal:
        return ElevatedButtonThemeData(
          style: base.merge(
            ElevatedButton.styleFrom(
              backgroundColor: scheme.primary.withValues(alpha: 0.10),
              foregroundColor: scheme.primary,
              shadowColor: scheme.primary.withValues(alpha: 0.25),
              elevation: 4,
              side: const BorderSide(color: Color(0xFF004D39), width: 1.0),
              overlayColor: scheme.secondary.withValues(alpha: 0.14),
            ),
          ),
        );
      default:
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
  }

  static OutlinedButtonThemeData _outlinedButtonThemeFor(
    AppThemeMode mode,
    ColorScheme scheme,
  ) {
    final base = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    switch (mode) {
      case AppThemeMode.cyberNeon:
        return OutlinedButtonThemeData(
          style: base.merge(
            OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF00FFF0), width: 1.2),
              foregroundColor: scheme.primary,
              overlayColor: scheme.secondary.withValues(alpha: 0.16),
            ),
          ),
        );
      case AppThemeMode.midnightTeal:
        return OutlinedButtonThemeData(
          style: base.merge(
            OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF004D39), width: 1.0),
              foregroundColor: scheme.primary,
              overlayColor: scheme.secondary.withValues(alpha: 0.12),
            ),
          ),
        );
      default:
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
  }

  static TextTheme _textThemeFor(AppThemeMode mode, ColorScheme scheme) {
    final base = ThemeData(brightness: scheme.brightness).textTheme.apply(
      displayColor: scheme.onSurface,
      bodyColor: scheme.onSurface,
    );
    switch (mode) {
      case AppThemeMode.cyberNeon:
        return base.copyWith(
          titleLarge: base.titleLarge?.copyWith(
            color: const Color(0xFFE4FBFF),
            fontWeight: FontWeight.w600,
          ),
          titleMedium: base.titleMedium?.copyWith(
            color: const Color(0xFF8ADFFF),
          ),
          bodySmall: base.bodySmall?.copyWith(
            color: scheme.onSurface.withValues(alpha: 0.72),
          ),
          labelSmall: base.labelSmall?.copyWith(color: const Color(0xFFFF2EC4)),
        );
      case AppThemeMode.midnightTeal:
        return base.copyWith(
          titleLarge: base.titleLarge?.copyWith(
            color: const Color(0xFFC2FFE9),
            fontWeight: FontWeight.w600,
          ),
          titleMedium: base.titleMedium?.copyWith(
            color: const Color(0xFF6BD9B7),
          ),
          bodySmall: base.bodySmall?.copyWith(
            color: scheme.onSurface.withValues(alpha: 0.68),
          ),
          labelSmall: base.labelSmall?.copyWith(color: const Color(0xFF43F56A)),
        );
      default:
        return base;
    }
  }
}
