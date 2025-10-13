import 'package:flutter/material.dart';

/// Responsive breakpoints for different screen sizes
/// Based on Material Design guidelines and common device categories
class ScreenBreakpoints {
  ScreenBreakpoints._(); // Private constructor to prevent instantiation

  /// Phone screens (up to 600dp)
  static const double phone = 600;

  /// Small tablets (600dp - 840dp)
  static const double tablet = 840;

  /// Large tablets and desktops (840dp+)
  static const double desktop = 1024;
}

/// Typography scaling based on screen width
/// Returns a multiplier for text scaling
/// - Phone (<600dp): 1.0x (baseline)
/// - Small tablet (600-840dp): 1.15x
/// - Large tablet (>840dp): 1.25x
double getTextScale(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < ScreenBreakpoints.phone) return 1.0;
  if (width < ScreenBreakpoints.tablet) return 1.15;
  return 1.25;
}

/// Progress ring size proportional to screen width
/// - Phone (<600dp): 206px (baseline)
/// - Small tablet (600-840dp): 240px (+16%)
/// - Large tablet (>840dp): 280px (+36%)
double getProgressRingSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < ScreenBreakpoints.phone) return 206;
  if (width < ScreenBreakpoints.tablet) return 240;
  return 280;
}

/// Chart height proportional to screen size
/// - Phone (<600dp): 110px (baseline)
/// - Small tablet (600-840dp): 128px (+16%)
/// - Large tablet (>840dp): 150px (+36%)
double getChartHeight(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < ScreenBreakpoints.phone) return 110;
  if (width < ScreenBreakpoints.tablet) return 128;
  return 150;
}

/// Card padding proportional to screen size
/// - Phone (<600dp): 12px (baseline)
/// - Small tablet (600-840dp): 16px
/// - Large tablet (>840dp): 20px
double getCardPadding(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < ScreenBreakpoints.phone) return 12;
  if (width < ScreenBreakpoints.tablet) return 16;
  return 20;
}

/// Spacing between widgets proportional to screen size
/// - Phone (<600dp): 12px (baseline)
/// - Small tablet (600-840dp): 16px
/// - Large tablet (>840dp): 20px
double getSpacing(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < ScreenBreakpoints.phone) return 12;
  if (width < ScreenBreakpoints.tablet) return 16;
  return 20;
}

/// Icon size proportional to screen size
/// - Phone (<600dp): 24px (baseline)
/// - Small tablet (600-840dp): 28px
/// - Large tablet (>840dp): 32px
double getIconSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < ScreenBreakpoints.phone) return 24;
  if (width < ScreenBreakpoints.tablet) return 28;
  return 32;
}

/// Button height proportional to screen size
/// - Phone (<600dp): 48px (baseline, Material minimum)
/// - Small tablet (600-840dp): 56px
/// - Large tablet (>840dp): 64px
double getButtonHeight(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < ScreenBreakpoints.phone) return 48;
  if (width < ScreenBreakpoints.tablet) return 56;
  return 64;
}

/// Check if current device is a tablet
/// A device is considered a tablet if its shortest side is >= 600dp
bool isTablet(BuildContext context) {
  return MediaQuery.of(context).size.shortestSide >= ScreenBreakpoints.phone;
}

/// Check if current orientation is landscape
bool isLandscape(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.landscape;
}

/// Check if should use master-detail layout
/// Returns true for tablets in landscape mode
bool useMasterDetail(BuildContext context) {
  return isTablet(context) && isLandscape(context);
}

/// Get master pane width for master-detail layout
/// Returns 60% of screen width for master pane (Today tab)
double getMasterPaneWidth(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width * 0.6;
}

/// Get detail pane width for master-detail layout
/// Returns 40% of screen width for detail pane (Trends)
double getDetailPaneWidth(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width * 0.4;
}

/// Extension for easy access to responsive utilities
extension ResponsiveContext on BuildContext {
  /// Text scale multiplier
  double get textScale => getTextScale(this);

  /// Progress ring size
  double get progressRingSize => getProgressRingSize(this);

  /// Chart height
  double get chartHeight => getChartHeight(this);

  /// Card padding
  double get cardPadding => getCardPadding(this);

  /// Widget spacing
  double get spacing => getSpacing(this);

  /// Icon size
  double get iconSize => getIconSize(this);

  /// Button height
  double get buttonHeight => getButtonHeight(this);

  /// Is tablet device
  bool get isTabletDevice => isTablet(this);

  /// Is landscape orientation
  bool get isLandscapeMode => isLandscape(this);

  /// Should use master-detail layout
  bool get useMasterDetailLayout => useMasterDetail(this);

  /// Master pane width (60%)
  double get masterPaneWidth => getMasterPaneWidth(this);

  /// Detail pane width (40%)
  double get detailPaneWidth => getDetailPaneWidth(this);
}
