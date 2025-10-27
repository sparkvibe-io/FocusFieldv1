import 'package:flutter/material.dart';

/// Extra dramatic styling hooks for premium themes (midnightTeal, cyberNeon).
/// Other themes provide a mostly null/neutral instance so calling code can
/// rely on the extension always being present.
class DramaticThemeStyling extends ThemeExtension<DramaticThemeStyling> {
  final LinearGradient? appBackgroundGradient;
  final LinearGradient? cardBackgroundGradient;
  final List<Color>? statAccentColors; // Optional per‑stat accents
  // Optional animated neon background configuration
  final bool neonAnimated;
  final List<Color>? neonColors; // Colors used in animated neon backdrop

  const DramaticThemeStyling({
    this.appBackgroundGradient,
    this.cardBackgroundGradient,
    this.statAccentColors,
    this.neonAnimated = false,
    this.neonColors,
  });

  factory DramaticThemeStyling.neutral() => const DramaticThemeStyling();

  @override
  DramaticThemeStyling copyWith({
    LinearGradient? appBackgroundGradient,
    LinearGradient? cardBackgroundGradient,
    List<Color>? statAccentColors,
    bool? neonAnimated,
    List<Color>? neonColors,
  }) => DramaticThemeStyling(
    appBackgroundGradient: appBackgroundGradient ?? this.appBackgroundGradient,
    cardBackgroundGradient:
        cardBackgroundGradient ?? this.cardBackgroundGradient,
    statAccentColors: statAccentColors ?? this.statAccentColors,
    neonAnimated: neonAnimated ?? this.neonAnimated,
    neonColors: neonColors ?? this.neonColors,
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
  final BoxDecoration Function(ColorScheme) ctaCardDecoration;

  const AppDecorations({
    required this.cardDecoration,
    required this.elevatedCardDecoration,
    required this.subtleCardDecoration,
    required this.ctaCardDecoration,
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
    // CTA card: darker than surroundings in light theme; lighter in dark theme
    ctaCardDecoration: (scheme) {
      final isDark = scheme.brightness == Brightness.dark;
      // Base background: start from surfaceContainerHighest and move toward on-surface (light) or surface (dark)
      final Color backgroundColor = scheme.surfaceContainerHighest;
    final Color adjusted = isDark
      // In dark mode, make it noticeably lighter to pop against other cards
      ? Color.alphaBlend(Colors.white.withValues(alpha: 0.16), backgroundColor)
          // In light mode, darken further for strong prominence
          : Color.alphaBlend(
              scheme.onSurface.withValues(alpha: 0.28),
              Color.alphaBlend(
                scheme.primary.withValues(alpha: 0.10),
                backgroundColor,
              ),
            );

      return BoxDecoration(
        color: adjusted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : scheme.outlineVariant.withValues(alpha: 0.45)),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: isDark ? 0.36 : 0.24),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );
    },
  );

  /// Premium theme decorations (CyberNeon, MidnightTeal) with intense glowing borders
  factory AppDecorations.premium({required Color accentColor, double glowStrength = 1.0}) => AppDecorations(
    cardDecoration: (scheme) => BoxDecoration(
      color: scheme.surfaceContainer.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: accentColor, width: 1.5 * glowStrength.clamp(0.6, 1.6)),
      boxShadow: [
        // Inner glow
        BoxShadow(
          color: accentColor.withValues(alpha: 0.5 * glowStrength),
          blurRadius: 16 + 6 * (glowStrength - 1).clamp(0, 1),
          spreadRadius: 1,
        ),
        // Outer glow
        BoxShadow(
          color: accentColor.withValues(alpha: 0.3 * glowStrength),
          blurRadius: 24 + 8 * (glowStrength - 1).clamp(0, 1),
          spreadRadius: 2,
        ),
      ],
    ),
    elevatedCardDecoration: (scheme) => BoxDecoration(
      color: scheme.surfaceContainer.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: accentColor, width: 2.0 * glowStrength.clamp(0.6, 1.6)),
      boxShadow: [
        // Strong inner glow
        BoxShadow(
          color: accentColor.withValues(alpha: 0.6 * glowStrength),
          blurRadius: 20 + 8 * (glowStrength - 1).clamp(0, 1),
          spreadRadius: 2,
        ),
        // Strong outer glow
        BoxShadow(
          color: accentColor.withValues(alpha: 0.4 * glowStrength),
          blurRadius: 32 + 12 * (glowStrength - 1).clamp(0, 1),
          spreadRadius: 3,
        ),
      ],
    ),
    subtleCardDecoration: (scheme) => BoxDecoration(
      color: scheme.surfaceContainer.withValues(alpha: 0.70),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: accentColor.withValues(alpha: 0.7), width: 1.2 * glowStrength.clamp(0.6, 1.6)),
      boxShadow: [
        BoxShadow(
          color: accentColor.withValues(alpha: 0.35 * glowStrength),
          blurRadius: 12 + 4 * (glowStrength - 1).clamp(0, 1),
          spreadRadius: 1,
        ),
      ],
    ),
    ctaCardDecoration: (scheme) {
      final isDark = scheme.brightness == Brightness.dark;
      // For premium, give CTA a soft accent halo while keeping readability
      final base = scheme.surfaceContainerHighest;
      final adjusted = isDark
          ? Color.alphaBlend(Colors.white.withValues(alpha: 0.08), base)
          : Color.alphaBlend(scheme.onSurface.withValues(alpha: 0.14), base);
      return BoxDecoration(
        color: adjusted,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Add a faint accent glow to attract attention
          BoxShadow(
            color: accentColor.withValues(alpha: isDark ? 0.35 : 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );
    },
  );

  @override
  AppDecorations copyWith({
    BoxDecoration Function(ColorScheme)? cardDecoration,
    BoxDecoration Function(ColorScheme)? elevatedCardDecoration,
    BoxDecoration Function(ColorScheme)? subtleCardDecoration,
    BoxDecoration Function(ColorScheme)? ctaCardDecoration,
  }) => AppDecorations(
    cardDecoration: cardDecoration ?? this.cardDecoration,
    elevatedCardDecoration: elevatedCardDecoration ?? this.elevatedCardDecoration,
    subtleCardDecoration: subtleCardDecoration ?? this.subtleCardDecoration,
    ctaCardDecoration: ctaCardDecoration ?? this.ctaCardDecoration,
  );

  @override
  AppDecorations lerp(ThemeExtension<AppDecorations>? other, double t) {
    if (other is! AppDecorations) return this;
    return t < 0.5 ? this : other;
  }
}

/// Semantic colors derived from ColorScheme for consistent banners, toasts, etc.
class SemanticColors extends ThemeExtension<SemanticColors> {
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;

  const SemanticColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
  });

  factory SemanticColors.fromScheme(ColorScheme scheme) {
    // Map to close M3 tokens for predictable contrast
    final success = scheme.tertiaryContainer;
    final onSuccess = scheme.onTertiaryContainer;
    final warning = scheme.secondaryContainer;
    final onWarning = scheme.onSecondaryContainer;
    final info = scheme.primaryContainer;
    final onInfo = scheme.onPrimaryContainer;
    return SemanticColors(
      success: success,
      onSuccess: onSuccess,
      warning: warning,
      onWarning: onWarning,
      info: info,
      onInfo: onInfo,
    );
  }

  @override
  SemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
  }) => SemanticColors(
    success: success ?? this.success,
    onSuccess: onSuccess ?? this.onSuccess,
    warning: warning ?? this.warning,
    onWarning: onWarning ?? this.onWarning,
    info: info ?? this.info,
    onInfo: onInfo ?? this.onInfo,
  );

  @override
  ThemeExtension<SemanticColors> lerp(
    ThemeExtension<SemanticColors>? other,
    double t,
  ) {
    if (other is! SemanticColors) return this;
    Color lerpC(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    return SemanticColors(
      success: lerpC(success, other.success),
      onSuccess: lerpC(onSuccess, other.onSuccess),
      warning: lerpC(warning, other.warning),
      onWarning: lerpC(onWarning, other.onWarning),
      info: lerpC(info, other.info),
      onInfo: lerpC(onInfo, other.onInfo),
    );
  }
}

/// Categorical palette for activities/charts using the active ColorScheme.
class CategoricalPalette extends ThemeExtension<CategoricalPalette> {
  final List<Color> series;

  const CategoricalPalette({required this.series});

  factory CategoricalPalette.fromScheme(ColorScheme cs) {
    // Use a mix of base and container tones for distinct yet cohesive series.
    final series = <Color>[
      cs.primary,
      cs.secondary,
      cs.tertiary,
      cs.primaryContainer,
      cs.secondaryContainer,
      cs.tertiaryContainer,
      cs.inversePrimary,
      cs.surfaceTint,
    ].whereType<Color>().toList();
    return CategoricalPalette(series: series);
  }

  @override
  CategoricalPalette copyWith({List<Color>? series}) =>
      CategoricalPalette(series: series ?? this.series);

  @override
  ThemeExtension<CategoricalPalette> lerp(
    ThemeExtension<CategoricalPalette>? other,
    double t,
  ) {
    if (other is! CategoricalPalette) return this;
    final len = series.length;
    final out = <Color>[];
    for (var i = 0; i < len; i++) {
      final a = series[i % series.length];
      final b = other.series[i % other.series.length];
      out.add(Color.lerp(a, b, t) ?? a);
    }
    return CategoricalPalette(series: out);
  }
}

extension SemanticAndPaletteExtension on BuildContext {
  SemanticColors get semanticColors {
    final theme = Theme.of(this);
    final ext = theme.extension<SemanticColors>();
    return ext ?? SemanticColors.fromScheme(theme.colorScheme);
  }

  CategoricalPalette get categoricalPalette {
    final theme = Theme.of(this);
    final ext = theme.extension<CategoricalPalette>();
    return ext ?? CategoricalPalette.fromScheme(theme.colorScheme);
  }

  // Map a filled container color to the corresponding readable text color
  Color onColorFor(Color container, ColorScheme cs) {
    // Heuristic: check matches against scheme containers
    if (container.toARGB32() == cs.primary.toARGB32() ||
        container.toARGB32() == cs.primaryContainer.toARGB32()) {
      return cs.onPrimaryContainer;
    }
    if (container.toARGB32() == cs.secondary.toARGB32() ||
        container.toARGB32() == cs.secondaryContainer.toARGB32()) {
      return cs.onSecondaryContainer;
    }
    if (container.toARGB32() == cs.tertiary.toARGB32() ||
        container.toARGB32() == cs.tertiaryContainer.toARGB32()) {
      return cs.onTertiaryContainer;
    }
    // Fallback using contrast check
    final luminance = container.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
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

  /// Get prominent CTA card decoration (darker in light theme, lighter in dark theme)
  BoxDecoration get ctaCardDecoration {
    final theme = Theme.of(this);
    final decorations = theme.extension<AppDecorations>() ?? AppDecorations.standard();
    return decorations.ctaCardDecoration(theme.colorScheme);
  }
}
