import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/providers/theme_provider.dart';
import 'package:silence_score/screens/splash_screen.dart';
import 'package:silence_score/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SilenceScoreApp(),
    ),
  );
}

class SilenceScoreApp extends ConsumerWidget {
  const SilenceScoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode.themeMode,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
} 