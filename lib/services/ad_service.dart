import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:focus_field/utils/debug_log.dart';

class AdService {
  AdService._();
  static final AdService instance = AdService._();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        DebugLog.d('AdService init failed: $e');
      }
    }
  }
}
