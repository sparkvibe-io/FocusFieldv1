import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/theme_provider.dart';
import 'package:focus_field/providers/accessibility_provider.dart';
import 'package:focus_field/screens/splash_screen.dart';
import 'package:focus_field/screens/home_page_elegant.dart';
import 'package:focus_field/theme/app_theme.dart';
import 'package:focus_field/services/navigation_service.dart';
import 'package:focus_field/widgets/dramatic_backdrop.dart';
// RevenueCat (purchases_flutter) is configured inside SubscriptionService during provider initialization.
import 'package:focus_field/providers/subscription_provider.dart';
import 'package:focus_field/utils/responsive_utils.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (required for AdMob integration)
  await Firebase.initializeApp();

  // Optimize for performance
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // RevenueCat configuration deferred to SubscriptionService.initialize()

  runApp(const ProviderScope(child: FocusFieldApp()));
}

/// Widget that locks device orientation based on screen size
/// - Phones/Small Tablets (<720dp): Portrait only (protects ad visibility)
/// - Large Tablets (>=720dp): All orientations allowed
class OrientationLocker extends StatefulWidget {
  final Widget child;

  const OrientationLocker({super.key, required this.child});

  @override
  State<OrientationLocker> createState() => _OrientationLockerState();
}

class _OrientationLockerState extends State<OrientationLocker> with WidgetsBindingObserver {
  double? _lastShortestSide;
  Orientation? _lastOrientation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Force initial update
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateOrientation());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Called when screen size/orientation changes
    _updateOrientation();
  }

  void _updateOrientation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final size = MediaQuery.of(context).size;
      final width = size.width;
      final height = size.height;
      final shortestSide = size.shortestSide;
      final orientation = MediaQuery.of(context).orientation;

      if (kDebugMode) {
        print('📐 OrientationLocker: width=$width, height=$height, shortestSide=$shortestSide, orientation=$orientation, breakpoint=${ScreenBreakpoints.tablet}');
      }

      // Check if orientation changed (reliable trigger for rotation)
      final orientationChanged = _lastOrientation != null && _lastOrientation != orientation;

      // Check if shortest side changed significantly (device rotation or resize)
      final sideChanged = _lastShortestSide != null &&
                         (shortestSide - _lastShortestSide!).abs() > 10;

      // Update if this is first run, orientation changed, or size changed
      if (_lastShortestSide == null || orientationChanged || sideChanged) {
        _lastShortestSide = shortestSide;
        _lastOrientation = orientation;

        // Use shortest side for consistent breakpoint check (works in both orientations)
        // shortestSide = min(width, height) = always the portrait width
        if (shortestSide < ScreenBreakpoints.tablet) {
          // Phones and small tablets: Portrait only (protects ad visibility)
          if (kDebugMode) {
            print('📐 OrientationLocker: Locking to PORTRAIT (shortestSide $shortestSide < ${ScreenBreakpoints.tablet})');
          }
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        } else {
          // Large tablets: Allow all orientations
          if (kDebugMode) {
            print('📐 OrientationLocker: Allowing ALL ORIENTATIONS (shortestSide $shortestSide >= ${ScreenBreakpoints.tablet})');
          }
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        }
      } else {
        if (kDebugMode) {
          print('📐 OrientationLocker: Skipping update - no significant change');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Update orientation on build (handles initial setup and screen changes)
    _updateOrientation();
    return widget.child;
  }
}

class FocusFieldApp extends ConsumerWidget {
  const FocusFieldApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final enableHighContrast = ref.watch(enableHighContrastProvider);
    final textScaleFactor = ref.watch(textScaleFactorProvider);
    // Kick off subscription initialization (non-blocking)
    ref.watch(startupSubscriptionInitProvider);

    // Optional: TEST_LOCALE for i18n verification (passed via --dart-define=TEST_LOCALE=xx)
    const testLocale = String.fromEnvironment('TEST_LOCALE', defaultValue: '');
    final Locale? forcedLocale = testLocale.isNotEmpty ? _parseLocale(testLocale) : null;

    // Build ThemeData based on current selection. For non-system modes, we
    // supply the same ThemeData as both theme and darkTheme so MaterialApp
    // doesn't override (e.g., CyberNeon being replaced by generic dark).
    final themeForCurrent = AppTheme.getThemeForMode(
      currentTheme,
      enableHighContrast: enableHighContrast,
    );
    final lightSystemTheme = AppTheme.getThemeForMode(
      AppThemeMode.light,
      enableHighContrast: enableHighContrast,
    );
    final darkSystemTheme = AppTheme.getThemeForMode(
      AppThemeMode.dark,
      enableHighContrast: enableHighContrast,
    );

    final useSystem = currentTheme == AppThemeMode.system;

    return MaterialApp(
      onGenerateTitle:
          (ctx) => AppLocalizations.of(ctx)?.appTitle ?? 'Focus Field',
      navigatorKey: NavigationService.navigatorKey,
      theme: useSystem ? lightSystemTheme : themeForCurrent,
      darkTheme: useSystem ? darkSystemTheme : themeForCurrent,
      themeMode: useSystem ? ThemeMode.system : currentTheme.themeMode,
      locale: forcedLocale,  // Override locale for testing if TEST_LOCALE provided
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('pt', 'BR'),
        Locale('ja'),
        Locale('zh', 'CN'),  // Simplified Chinese (China mainland)
        Locale('zh'),        // Fallback for generic Chinese
      ],
      // Start with splash screen which transitions to AppInitializer
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomePageElegant(),
      },
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Combine responsive scaling with user accessibility scaling
        final responsiveScale = getTextScale(context);
        final finalScale = textScaleFactor * responsiveScale;

        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(finalScale)),
          child: DramaticBackdrop(
            child: OrientationLocker(child: child!),
          ),
        );
      },
    );
  }
}

/// Parse locale code string to Locale object
/// Supports: en, es, de, fr, ja, pt, pt_BR
Locale? _parseLocale(String localeCode) {
  if (localeCode.isEmpty) return null;

  // Handle pt_BR special case
  if (localeCode == 'pt_BR') {
    return const Locale('pt', 'BR');
  }

  // Single language code (en, es, de, fr, ja, pt)
  return Locale(localeCode);
}
