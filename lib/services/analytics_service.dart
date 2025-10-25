import 'package:flutter/foundation.dart';

/// Minimal analytics service focused on paywall & subscription events.
/// Extend later with real analytics backends.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  void logEvent(String name, {Map<String, Object?> parameters = const {}}) {
    if (!kReleaseMode) {
      // ignore: avoid_print
      // print('AnalyticsEvent: $name ${parameters.isEmpty ? '' : parameters}');
    }
  }
}
