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
        cardBackgroundGradient: cardBackgroundGradient ?? this.cardBackgroundGradient,
        statAccentColors: statAccentColors ?? this.statAccentColors,
      );

  @override
  DramaticThemeStyling lerp(ThemeExtension<DramaticThemeStyling>? other, double t) {
    if (other is! DramaticThemeStyling) return this;
    // We don't attempt to lerp gradients precisely; just switch mid‑way.
    return t < 0.5 ? this : other;
  }
}