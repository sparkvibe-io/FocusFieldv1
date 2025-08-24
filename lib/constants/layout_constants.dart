/// Layout and sizing related constants and helpers to avoid magic numbers
class LayoutConstants {
  // Width breakpoints (material-inspired)
  static const double smallWidth = 0;      // implicit
  static const double mediumWidth = 600;   // tablets portrait / large phones landscape
  static const double largeWidth = 900;    // tablets landscape
  static const double extraLargeWidth = 1200; // desktop / very large
  // Height threshold to consider a screen "small" for vertical layout adjustments
  static const double smallScreenHeightThreshold = 700.0;

  // Progress ring sizing (min / max for adaptive calculation)
  static const double progressRingMinSize = 180.0;
  static const double progressRingSmallMaxSize = 240.0;
  static const double progressRingRegularMaxSize = 280.0;
  static const double progressRingLargeMaxSize = 340.0;
  static const double progressRingExtraLargeMaxSize = 420.0;

  // Real-time noise chart heights
  static const double noiseChartSmallHeight = 100.0;
  static const double noiseChartRegularHeight = 120.0;

  // Spacing values (adaptive)
  static const double spacingSmall = 16.0;
  static const double spacingRegular = 32.0;
  static const double spacingAfterChartSmall = 16.0;
  static const double spacingAfterChartRegular = 24.0;
  static const double progressStatusHeightSmall = 32.0;
  static const double progressStatusHeightRegular = 40.0;
  static const double bottomPaddingSmall = 16.0;
  static const double bottomPaddingRegular = 20.0;

  /// Compute adaptive progress ring size given available maxWidth and whether it's a small screen
  static double computeProgressRingSize(double maxWidth, {required bool isSmallScreen, double availableHeight = double.infinity}) {
    // Determine width tier
    double maxTarget;
    if (maxWidth >= extraLargeWidth) {
      maxTarget = progressRingExtraLargeMaxSize;
    } else if (maxWidth >= largeWidth) {
      maxTarget = progressRingLargeMaxSize;
    } else if (isSmallScreen) {
      maxTarget = progressRingSmallMaxSize;
    } else {
      maxTarget = progressRingRegularMaxSize;
    }
    // Use a proportion of width but clamp to defined min/max
    final computed = maxWidth * (maxWidth >= largeWidth ? 0.32 : 0.55);
    // Also cap by height to avoid overflow on very short landscape
    final heightCap = availableHeight.isFinite ? availableHeight * 0.6 : double.infinity;
    final candidate = heightCap.isFinite ? computed.clamp(0, heightCap) : computed;
  if (candidate < progressRingMinSize) return progressRingMinSize;
  if (candidate > maxTarget) return maxTarget;
  return candidate.toDouble();
  }
}
