import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/providers/theme_provider.dart';
import 'package:silence_score/providers/accessibility_provider.dart';
import 'package:silence_score/screens/app_initializer.dart';
import 'package:silence_score/theme/app_theme.dart';
import 'package:silence_score/services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Optimize for performance
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  runApp(const ProviderScope(child: SilenceScoreApp()));
}

class SilenceScoreApp extends ConsumerWidget {
  const SilenceScoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final enableHighContrast = ref.watch(enableHighContrastProvider);
    final textScaleFactor = ref.watch(textScaleFactorProvider);
    
    return MaterialApp(
      title: 'Silence Score',
      navigatorKey: NavigationService.navigatorKey,
      theme: AppTheme.getThemeForMode(currentTheme, enableHighContrast: enableHighContrast),
      darkTheme: currentTheme == AppThemeMode.purpleNight 
          ? AppTheme.getThemeForMode(AppThemeMode.purpleNight, enableHighContrast: enableHighContrast)
          : AppTheme.getThemeForMode(AppThemeMode.dark, enableHighContrast: enableHighContrast),
      themeMode: currentTheme.themeMode,
      home: const AppInitializer(),
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