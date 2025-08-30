import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:silence_score/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/providers/theme_provider.dart';
import 'package:silence_score/providers/accessibility_provider.dart';
import 'package:silence_score/screens/splash_screen.dart';
import 'package:silence_score/theme/app_theme.dart';
import 'package:silence_score/services/navigation_service.dart';
// RevenueCat (purchases_flutter) is configured inside SubscriptionService during provider initialization.
import 'package:silence_score/providers/subscription_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Optimize for performance
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // RevenueCat configuration deferred to SubscriptionService.initialize()
  
  runApp(const ProviderScope(child: SilenceScoreApp()));
}

class SilenceScoreApp extends ConsumerWidget {
  const SilenceScoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final enableHighContrast = ref.watch(enableHighContrastProvider);
  final textScaleFactor = ref.watch(textScaleFactorProvider);
  // Kick off subscription initialization (non-blocking)
  ref.watch(startupSubscriptionInitProvider);
    
    return MaterialApp(
  onGenerateTitle: (ctx) => AppLocalizations.of(ctx)?.appTitle ?? 'Silence Score',
      navigatorKey: NavigationService.navigatorKey,
      theme: AppTheme.getThemeForMode(currentTheme, enableHighContrast: enableHighContrast),
      darkTheme: currentTheme == AppThemeMode.purpleNight 
          ? AppTheme.getThemeForMode(AppThemeMode.purpleNight, enableHighContrast: enableHighContrast)
          : AppTheme.getThemeForMode(AppThemeMode.dark, enableHighContrast: enableHighContrast),
      themeMode: currentTheme.themeMode,
      localizationsDelegates: [
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
        Locale('pt','BR'),
        Locale('ja'),
      ],
  // Start with splash screen which transitions to AppInitializer
  home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScaleFactor)),
          child: child!,
        );
      },
    );
  }
} 