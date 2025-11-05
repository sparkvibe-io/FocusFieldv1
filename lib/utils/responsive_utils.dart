import 'package:flutter/material.dart';

/// Responsive breakpoints for different screen sizes
/// Based on Material Design guidelines and common device categories
class ScreenBreakpoints {
  ScreenBreakpoints._(); // Private constructor to prevent instantiation

  /// Phone screens (up to 600dp)
  static const double phone = 600;

  /// Small tablets (600dp - 720dp)
  static const double tablet = 720;

  /// Large tablets and desktops (720dp+)
  static const double desktop = 1024;
}

/// Typography scaling based on screen width and orientation
/// Returns a multiplier for text scaling
///
/// Portrait (more vertical space):
/// - Phone (<600dp): 1.0x (baseline)
/// - Small tablet (600-720dp): 1.15x
/// - Large tablet (>720dp): 1.25x
///
/// Landscape (limited vertical space):
/// - All sizes: 0.95x - 1.0x (compact for tight vertical space)
double getTextScale(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final orientation = MediaQuery.of(context).orientation;

  // In landscape, use compact scaling to fit more content vertically
  if (orientation == Orientation.landscape) {
    if (width < ScreenBreakpoints.phone) return 0.95;
    if (width < ScreenBreakpoints.tablet) return 0.95;
    return 1.0;  // Reduced from 1.1x - baseline for tablets in landscape
  }

  // Portrait: Standard scaling (more vertical space available)
  if (width < ScreenBreakpoints.phone) return 1.0;
  if (width < ScreenBreakpoints.tablet) return 1.15;
  return 1.25;
}

/// Progress ring size proportional to screen width and orientation
///
/// Portrait:
/// - Phone (<600dp): 206px (baseline)
/// - Small tablet (600-720dp): 240px (+16%)
/// - Large tablet (>720dp): 280px (+36%)
///
/// Landscape (30% smaller to fit limited vertical space):
/// - Phone (<600dp): 180px (compact)
/// - Small tablet (600-720dp): 180px (compact)
/// - Large tablet (>720dp): 195px (30% reduction from 280px)
double getProgressRingSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final orientation = MediaQuery.of(context).orientation;

  // In landscape, use much smaller ring (limited vertical space)
  if (orientation == Orientation.landscape) {
    if (width < ScreenBreakpoints.phone) return 180;
    if (width < ScreenBreakpoints.tablet) return 180;
    return 195;  // 30% smaller than 280px for better fit
  }

  // Portrait: Standard sizing
  if (width < ScreenBreakpoints.phone) return 206;
  if (width < ScreenBreakpoints.tablet) return 240;
  return 280;
}

/// Chart height proportional to screen size and orientation
///
/// Portrait:
/// - Phone (<600dp): 110px (baseline)
/// - Small tablet (600-720dp): 128px (+16%)
/// - Large tablet (>720dp): 150px (+36%)
///
/// Landscape (compact for limited vertical space):
/// - Phone (<600dp): 100px (compact)
/// - Small tablet (600-720dp): 110px (compact)
/// - Large tablet (>720dp): 120px (compact, 20% reduction)
double getChartHeight(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final orientation = MediaQuery.of(context).orientation;

  // In landscape, use compact chart heights
  if (orientation == Orientation.landscape) {
    if (width < ScreenBreakpoints.phone) return 100;
    if (width < ScreenBreakpoints.tablet) return 110;
    return 120;  // Reduced from 150px
  }

  // Portrait: Standard heights
  if (width < ScreenBreakpoints.phone) return 110;
  if (width < ScreenBreakpoints.tablet) return 128;
  return 150;
}

/// Card padding proportional to screen size and orientation
///
/// Portrait:
/// - Phone (<600dp): 12px (baseline)
/// - Small tablet (600-720dp): 16px
/// - Large tablet (>720dp): 20px
///
/// Landscape (compact for limited vertical space):
/// - All sizes: 8px (compact for vertical space)
double getCardPadding(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final orientation = MediaQuery.of(context).orientation;

  // In landscape, use minimal padding to maximize content space
  if (orientation == Orientation.landscape) {
    return 8;  // Reduced from 12px for tighter layout
  }

  // Portrait: Standard padding
  if (width < ScreenBreakpoints.phone) return 12;
  if (width < ScreenBreakpoints.tablet) return 16;
  return 20;
}

/// Spacing between widgets proportional to screen size and orientation
///
/// Portrait:
/// - Phone (<600dp): 12px (baseline)
/// - Small tablet (600-720dp): 16px
/// - Large tablet (>720dp): 20px
///
/// Landscape (very compact for limited vertical space):
/// - Phone (<600dp): 6px (very compact)
/// - Small tablet (600-720dp): 6px (very compact)
/// - Large tablet (>720dp): 8px (very compact)
double getSpacing(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final orientation = MediaQuery.of(context).orientation;

  // In landscape, use very compact spacing to maximize vertical space
  if (orientation == Orientation.landscape) {
    if (width < ScreenBreakpoints.phone) return 6;
    if (width < ScreenBreakpoints.tablet) return 6;
    return 8;  // Reduced from 12px - aggressive vertical compression
  }

  // Portrait: Standard spacing
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
