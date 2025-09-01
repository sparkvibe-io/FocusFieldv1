import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

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
        debugPrint('AdService init failed: $e');
      }
    }
  }
}
