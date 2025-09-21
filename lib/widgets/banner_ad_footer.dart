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

  static const String _testUnitId = AppConstants.testBannerAdUnitId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await AdService.instance.initialize();
    const size = AdSize.banner; // 320x50 on phones typically
    final ad = BannerAd(
      size: size,
      adUnitId: _testUnitId,
      listener: BannerAdListener(
        onAdLoaded:
            (ad) => setState(() {
              _loading = false;
            }),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          if (mounted) {
            setState(() {
              _loading = false;
            });
          }
        },
      ),
      request: const AdRequest(),
    );
    await ad.load();
    if (mounted) {
      setState(() {
        _banner = ad;
      });
    } else {
      ad.dispose();
    }
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
