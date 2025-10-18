import 'package:flutter/material.dart';

/// Extra dramatic styling hooks for premium themes (midnightTeal, cyberNeon).
/// Other themes provide a mostly null/neutral instance so calling code can
/// rely on the extension always being present.
class DramaticThemeStyling extends ThemeExtension<DramaticThemeStyling> {
  final LinearGradient? appBackgroundGradient;
  final LinearGradient? cardBackgroundGradient;
  final List<Color>? statAccentColors; // Optional per‑stat accents

  const DramaticThemeStyling({
    this.appBackgroundGradient,
    this.cardBackgroundGradient,
    this.statAccentColors,
  });

  factory DramaticThemeStyling.neutral() => const DramaticThemeStyling();

  @override
  DramaticThemeStyling copyWith({
    LinearGradient? appBackgroundGradient,
    LinearGradient? cardBackgroundGradient,
    List<Color>? statAccentColors,
  }) => DramaticThemeStyling(
    appBackgroundGradient: appBackgroundGradient ?? this.appBackgroundGradient,
    cardBackgroundGradient:
        cardBackgroundGradient ?? this.cardBackgroundGradient,
    statAccentColors: statAccentColors ?? this.statAccentColors,
  );

  @override
  DramaticThemeStyling lerp(
    ThemeExtension<DramaticThemeStyling>? other,
    double t,
  ) {
    if (other is! DramaticThemeStyling) return this;
    // We don't attempt to lerp gradients precisely; just switch mid‑way.
    return t < 0.5 ? this : other;
  }
}

/// Global container decoration system for consistent, borderless cards
/// Uses subtle background highlights instead of explicit borders
class AppDecorations extends ThemeExtension<AppDecorations> {
  final BoxDecoration Function(ColorScheme) cardDecoration;
  final BoxDecoration Function(ColorScheme) elevatedCardDecoration;
  final BoxDecoration Function(ColorScheme) subtleCardDecoration;

  const AppDecorations({
    required this.cardDecoration,
    required this.elevatedCardDecoration,
    required this.subtleCardDecoration,
  });

  /// Clean borderless cards with prominent backgrounds and depth shadows
  factory AppDecorations.standard() => AppDecorations(
    cardDecoration: (scheme) {
      final isDark = scheme.brightness == Brightness.dark;

      // Lighter, more prominent backgrounds without borders
      final backgroundColor = isDark
          ? scheme.surfaceContainerHighest // Use full opacity in dark
          : scheme.surfaceContainerHighest; // Use full opacity in light

      return BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: isDark ? 0.4 : 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      );
    },
    elevatedCardDecoration: (scheme) {
      final isDark = scheme.brightness == Brightness.dark;

      return BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: isDark ? 0.5 : 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );
    },
    subtleCardDecoration: (scheme) {
      final isDark = scheme.brightness == Brightness.dark;

      return BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      );
    },
  );

  /// Premium theme decorations (CyberNeon, MidnightTeal) with intense glowing borders
  factory AppDecorations.premium({required Color accentColor}) => AppDecorations(
    cardDecoration: (scheme) => BoxDecoration(
      color: scheme.surfaceContainer.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: accentColor, width: 1.5),
      boxShadow: [
        // Inner glow
        BoxShadow(
          color: accentColor.withValues(alpha: 0.5),
          blurRadius: 16,
          spreadRadius: 1,
        ),
        // Outer glow
        BoxShadow(
          color: accentColor.withValues(alpha: 0.3),
          blurRadius: 24,
          spreadRadius: 2,
        ),
      ],
    ),
    elevatedCardDecoration: (scheme) => BoxDecoration(
      color: scheme.surfaceContainer.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: accentColor, width: 2.0),
      boxShadow: [
        // Strong inner glow
        BoxShadow(
          color: accentColor.withValues(alpha: 0.6),
          blurRadius: 20,
          spreadRadius: 2,
        ),
        // Strong outer glow
        BoxShadow(
          color: accentColor.withValues(alpha: 0.4),
          blurRadius: 32,
          spreadRadius: 3,
        ),
      ],
    ),
    subtleCardDecoration: (scheme) => BoxDecoration(
      color: scheme.surfaceContainer.withValues(alpha: 0.70),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: accentColor.withValues(alpha: 0.7), width: 1.2),
      boxShadow: [
        BoxShadow(
          color: accentColor.withValues(alpha: 0.35),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ],
    ),
  );

  @override
  AppDecorations copyWith({
    BoxDecoration Function(ColorScheme)? cardDecoration,
    BoxDecoration Function(ColorScheme)? elevatedCardDecoration,
    BoxDecoration Function(ColorScheme)? subtleCardDecoration,
  }) => AppDecorations(
    cardDecoration: cardDecoration ?? this.cardDecoration,
    elevatedCardDecoration: elevatedCardDecoration ?? this.elevatedCardDecoration,
    subtleCardDecoration: subtleCardDecoration ?? this.subtleCardDecoration,
  );

  @override
  AppDecorations lerp(ThemeExtension<AppDecorations>? other, double t) {
    if (other is! AppDecorations) return this;
    return t < 0.5 ? this : other;
  }
}

/// Helper extension to easily access theme decorations from BuildContext
extension ThemeDecorationExtension on BuildContext {
  /// Get standard card decoration from theme
  BoxDecoration get cardDecoration {
    final theme = Theme.of(this);
    final decorations = theme.extension<AppDecorations>() ?? AppDecorations.standard();
    return decorations.cardDecoration(theme.colorScheme);
  }

  /// Get elevated card decoration from theme
  BoxDecoration get elevatedCardDecoration {
    final theme = Theme.of(this);
    final decorations = theme.extension<AppDecorations>() ?? AppDecorations.standard();
    return decorations.elevatedCardDecoration(theme.colorScheme);
  }

  /// Get subtle card decoration from theme
  BoxDecoration get subtleCardDecoration {
    final theme = Theme.of(this);
    final decorations = theme.extension<AppDecorations>() ?? AppDecorations.standard();
    return decorations.subtleCardDecoration(theme.colorScheme);
  }
}
