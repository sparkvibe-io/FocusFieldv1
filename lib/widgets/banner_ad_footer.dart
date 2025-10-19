import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:focus_field/services/ad_service.dart';
import 'package:focus_field/constants/app_constants.dart';

/// Simple reusable banner ad container anchored at the bottom.
class FooterBannerAd extends StatefulWidget {
  const FooterBannerAd({super.key});

  @override
  State<FooterBannerAd> createState() => _FooterBannerAdState();
}

class _FooterBannerAdState extends State<FooterBannerAd> {
  BannerAd? _banner;
  bool _loading = true;
  bool _triedFallbackTest = false;

  static final String _unitId = AppConstants.effectiveBannerAdUnitId;

  @override
  void initState() {
    super.initState();
    // Skip initializing ads during widget tests to avoid platform views
    const inTest = bool.fromEnvironment('FLUTTER_TEST', defaultValue: false);
    if (!inTest) {
      _init();
    } else {
      _loading = false;
      _banner = null;
    }
  }

  Future<void> _init() async {
    await AdService.instance.initialize();
    const size = AdSize.banner; // 320x50 on phones typically
    final ad = BannerAd(
      size: size,
      adUnitId: _unitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Debug logging (development only)
          if (kDebugMode) {
            debugPrint('[Ads] Banner loaded with unit: $_unitId, size: ${ad is BannerAd ? ad.size : size}');
          }
          if (!mounted) return;
          setState(() {
            _banner = ad as BannerAd;
            _loading = false;
          });
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) {
            debugPrint('[Ads] Banner failed to load (unit: $_unitId): ${err.message} (code ${err.code})');
          }
          ad.dispose();
          if (mounted) {
            setState(() {
              // Ensure we don't try to render an unloaded/failed ad.
              _banner = null;
              _loading = false;
            });
          }

          // If in production mode and fallback is enabled, try once with the Google test unit to verify integration
          if (!AppConstants.isDevelopmentMode && AppConstants.fallbackTestAdOnFail && !_triedFallbackTest) {
            _triedFallbackTest = true;
            _loadTestFallback();
          }
        },
      ),
      request: const AdRequest(),
    );
    // Start loading; actual assignment occurs in onAdLoaded above to
    // guarantee AdWidget only receives a loaded ad.
    // It's safe to ignore the returned Future here.
    // ignore: discarded_futures
    ad.load();
    if (!mounted) ad.dispose();
  }

  Future<void> _loadTestFallback() async {
    if (kDebugMode) {
      debugPrint('[Ads] Retrying with Google test banner unit to verify integration');
    }
    const size = AdSize.banner;
    final testAd = BannerAd(
      size: size,
      adUnitId: AppConstants.testBannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (kDebugMode) {
            debugPrint('[Ads] Test banner loaded (fallback). Integration verified.');
          }
          if (!mounted) return;
          setState(() {
            _banner = ad as BannerAd;
            _loading = false;
          });
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) {
            debugPrint('[Ads] Test banner also failed: ${err.message} (code ${err.code})');
          }
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );
    // ignore: discarded_futures
    testAd.load();
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // During tests, render nothing
    const inTest = bool.fromEnvironment('FLUTTER_TEST', defaultValue: false);
    if (inTest) return const SizedBox.shrink();
    if (_loading) {
      return SizedBox(
        height: 52,
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary),
        ),
      );
    }
    if (_banner == null) return const SizedBox.shrink();
    return SizedBox(
      height: _banner!.size.height.toDouble(),
      width: _banner!.size.width.toDouble(),
      child: AdWidget(ad: _banner!),
    );
  }
}
