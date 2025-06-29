import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/screens/home_page.dart';
import 'package:silence_score/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SilenceScoreApp(),
    ),
  );
}

class SilenceScoreApp extends StatelessWidget {
  const SilenceScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
} 