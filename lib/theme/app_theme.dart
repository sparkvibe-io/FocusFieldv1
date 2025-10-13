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
            Color(0xFF05010C), // deep void
            Color(0xFF140033), // violet core
            Color(0xFF001F2A), // teal shadow
            Color(0xFF002F4F), // cyan edge
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
        cardBackgroundGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0E1233), Color(0xFF050B1F)],
        ),
        statAccentColors: [
          Color(0xFF00F5FF), // cyan
          Color(0xFFFF1FAE), // magenta
          Color(0xFFB347FF), // purple
        ],
      );
      decorations = AppDecorations.premium(
        accentColor: const Color(0xFF00FFF0),
      );
    } else if (mode == AppThemeMode.midnightTeal) {
      dramatic = DramaticThemeStyling(
        appBackgroundGradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF001916), // deep abyss
            Color(0xFF002B28), // teal core
            Color(0xFF004139), // emerald rise
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        cardBackgroundGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF002C29),
            const Color(0xFF001E1D).withValues(alpha: 0.85),
          ],
        ),
        statAccentColors: const [
          Color(0xFF00C9A5), // primary teal
          Color(0xFF008FA6), // blue‑teal
          Color(0xFF5DF27C), // green accent
        ],
      );
      decorations = AppDecorations.premium(
        accentColor: const Color(0xFF00D295),
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
          seedColor: const Color(0xFF006A6A), // Professional Teal
          brightness: Brightness.light,
        );
        return baseLight.copyWith(
          surface: const Color(0xFFF0F5F5), // Soft gray background
          surfaceContainer: const Color(0xFFE8EEEE),
          surfaceContainerHighest:
              Colors.white, // White cards for high contrast
          primary: const Color(0xFF005A5A),
          onPrimary: Colors.white,
          outline: baseLight.outline.withValues(alpha: 0.5),
        );
      case AppThemeMode.dark:
        final baseDark = ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E0E0), // Vibrant Cyan
          brightness: Brightness.dark,
        );
        return baseDark.copyWith(
          surface: const Color(0xFF1A1C1C), // Dark slate background
          surfaceContainer: const Color(0xFF242626),
          surfaceContainerHighest: const Color(
            0xFF282A2A,
          ), // Lighter gray cards
          primary: const Color(0xFF00E0E0),
          onPrimary: Colors.black,
          outline: baseDark.outline.withValues(alpha: 0.5),
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
          // Reworked to be extremely high contrast neon on near-black with violet + magenta depths
          surface: const Color(0xFF01060F), // almost black with blue hint
          surfaceContainer: const Color(0xFF050B1F),
          surfaceContainerHighest: const Color(0xFF0E1233),
          onSurface: const Color(0xFFE7F8FF), // icy white
          primary: const Color(0xFF00FFF0), // electric aqua
          onPrimary: const Color(0xFF001F1C),
          primaryContainer: const Color(0xFF003E5A),
          onPrimaryContainer: const Color(0xFF8CFFF6),
          secondary: const Color(0xFFFF2EC4), // hotter magenta
          tertiary: const Color(0xFF7B5BFF), // violet
          outline: const Color(0xFF3F4F9A),
        );
      case AppThemeMode.midnightTeal:
        final baseTeal = ColorScheme.fromSeed(
          seedColor: const Color(0xFF009688),
          brightness: Brightness.dark,
        );
        return baseTeal.copyWith(
          // Deeper green-cyan abyss with bio-luminescent mints
          surface: const Color(0xFF001312), // darker than before
          surfaceContainer: const Color(0xFF001E1D),
          surfaceContainerHighest: const Color(0xFF002C29),
          onSurface: const Color(0xFFCCFFEF), // pale mint
          primary: const Color(0xFF00D295), // vivid emerald teal
          onPrimary: const Color(0xFF00261A),
          primaryContainer: const Color(0xFF004D39),
          onPrimaryContainer: const Color(0xFF92FFDE),
          secondary: const Color(0xFF00A7C4), // aqua teal
          tertiary: const Color(0xFF43F56A), // bio green
          outline: const Color(0xFF1E5E55),
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
        // Borderless with clear background for good visibility
        return CardThemeData(
          elevation: highContrast ? 2 : 0,
          shape: baseShape,
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.9),
          shadowColor:
              highContrast ? scheme.onSurface.withValues(alpha: 0.4) : null,
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
              elevation: 2,
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
