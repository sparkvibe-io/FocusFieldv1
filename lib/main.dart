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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optimize for performance
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // RevenueCat configuration deferred to SubscriptionService.initialize()

  runApp(const ProviderScope(child: FocusFieldApp()));
}

/// Widget that locks device orientation based on screen size
/// - Phones/Small Tablets (<840dp): Portrait only (protects ad visibility)
/// - Large Tablets (>=840dp): All orientations allowed
class OrientationLocker extends StatefulWidget {
  final Widget child;

  const OrientationLocker({super.key, required this.child});

  @override
  State<OrientationLocker> createState() => _OrientationLockerState();
}

class _OrientationLockerState extends State<OrientationLocker> with WidgetsBindingObserver {
  double? _lastWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

      final width = MediaQuery.of(context).size.width;

      // Only update if width changed significantly (to avoid unnecessary calls)
      if (_lastWidth != null && (width - _lastWidth!).abs() < 50) {
        return;
      }

      _lastWidth = width;

      // Lock orientation based on screen width
      if (width < ScreenBreakpoints.tablet) {
        // Phones and small tablets: Portrait only (protects ad visibility)
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } else {
        // Large tablets: Allow all orientations
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
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
