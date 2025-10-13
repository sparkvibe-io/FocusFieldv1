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

  /// Default borderless decorations with subtle background highlights
  factory AppDecorations.standard() => AppDecorations(
    cardDecoration: (scheme) => BoxDecoration(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: scheme.outline.withValues(alpha: 0.15),
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: scheme.shadow.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    elevatedCardDecoration: (scheme) => BoxDecoration(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: scheme.outline.withValues(alpha: 0.2),
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: scheme.shadow.withValues(alpha: 0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    subtleCardDecoration: (scheme) => BoxDecoration(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: scheme.outline.withValues(alpha: 0.1),
        width: 0.5,
      ),
    ),
  );

  /// Premium theme decorations (CyberNeon, MidnightTeal) with glowing borders
  factory AppDecorations.premium({required Color accentColor}) => AppDecorations(
    cardDecoration: (scheme) => BoxDecoration(
      color: scheme.surfaceContainer.withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: accentColor, width: 1.2),
      boxShadow: [
        BoxShadow(
          color: accentColor.withValues(alpha: 0.3),
          blurRadius: 12,
          spreadRadius: 0,
        ),
      ],
    ),
    elevatedCardDecoration: (scheme) => BoxDecoration(
      color: scheme.surfaceContainer.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: accentColor, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: accentColor.withValues(alpha: 0.4),
          blurRadius: 16,
          spreadRadius: 1,
        ),
      ],
    ),
    subtleCardDecoration: (scheme) => BoxDecoration(
      color: scheme.surfaceContainer.withValues(alpha: 0.65),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: accentColor.withValues(alpha: 0.6), width: 1.0),
      boxShadow: [
        BoxShadow(
          color: accentColor.withValues(alpha: 0.2),
          blurRadius: 8,
          spreadRadius: 0,
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
