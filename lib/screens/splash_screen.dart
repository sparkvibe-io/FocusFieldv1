import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:silence_score/screens/app_initializer.dart';
import 'package:silence_score/l10n/app_localizations.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Subtle breathing animation for the icon
    final breatheController = useAnimationController(
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    final breathe = useAnimation(
      Tween<double>(begin: 0.92, end: 1.04).animate(
        CurvedAnimation(
          parent: breatheController,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );

    // Fade for text / overall content
    final fadeController = useAnimationController(
      duration: const Duration(milliseconds: 900),
    )..forward();
    final fade = useAnimation(
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: fadeController, curve: Curves.easeInOut),
      ),
    );

    useEffect(() {
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, a, __) => const AppInitializer(),
              transitionsBuilder:
                  (_, a, __, child) => FadeTransition(opacity: a, child: child),
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        }
      });
      return () {
        // Controllers from useAnimationController are disposed automatically by the hook.
        // No manual dispose to prevent double-dispose assertion.
        // Navigation future is harmless if it fires after unmount due to context.mounted guard.
      };
    }, []);

    final bgGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        theme.colorScheme.surfaceVariant.withValues(alpha: 0.4),
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        theme.colorScheme.surface,
      ],
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: Center(
            child: AnimatedOpacity(
              opacity: fade,
              duration: const Duration(milliseconds: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon with soft glass effect
                  Transform.scale(
                    scale: breathe,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.18),
                            theme.colorScheme.primary.withValues(alpha: 0.05),
                          ],
                        ),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.25,
                          ),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.20,
                            ),
                            blurRadius: 22,
                            spreadRadius: 1,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.volume_off_rounded,
                        size: 54,
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.95,
                        ),
                        semanticLabel:
                            AppLocalizations.of(context)!.appIconSemantic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Wordmark
                  Text(
                    AppLocalizations.of(context)!.appTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.95,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.splashTagline,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.75,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation(
                        theme.colorScheme.primary.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
