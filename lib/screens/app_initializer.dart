import 'package:focus_field/utils/debug_log.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/silence_provider.dart';
import 'package:focus_field/screens/home_page_elegant.dart';
import 'package:focus_field/widgets/error_boundary.dart';
import 'package:focus_field/services/rating_service.dart';
import 'package:focus_field/constants/permission_constants.dart';
import 'package:focus_field/widgets/permission_dialogs.dart';
import 'package:focus_field/services/tip_service.dart';

/// App initialization widget that ensures all data is loaded before showing main UI
class AppInitializer extends ConsumerWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all the async providers we need to initialize
    final storageServiceAsync = ref.watch(storageServiceProvider);
    final settingsAsync = ref.watch(appSettingsProvider);
    final silenceDataAsync = ref.watch(silenceDataNotifierProvider);

    return storageServiceAsync.when(
      loading: () => _buildLoadingScreen(context, 'Initializing app...'),
      error:
          (error, stack) =>
              _buildErrorScreen(context, 'Initialization failed: $error', ref),
      data: (storageService) {
        return settingsAsync.when(
          loading: () => _buildLoadingScreen(context, 'Loading settings...'),
          error:
              (error, stack) => _buildErrorScreen(
                context,
                'Settings loading failed: $error',
                ref,
              ),
          data: (settings) {
            return silenceDataAsync.when(
              loading:
                  () => _buildLoadingScreen(context, 'Loading user data...'),
              error:
                  (error, stack) => _buildErrorScreen(
                    context,
                    'Data loading failed: $error',
                    ref,
                  ),
              data: (silenceData) {
                // Trigger rating prompt logic (non-blocking)
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  try {
                    await RatingService.instance.initLaunch();
                    // silenceData is a SilenceData model
                    if (!context.mounted) return;
                    await RatingService.instance.maybePrompt(
                      context,
                      totalSessions: silenceData.totalSessions,
                      lastSessionDurationSeconds:
                          silenceData.recentSessions.isNotEmpty
                              ? silenceData.recentSessions.first.duration
                              : null,
                    );
                    // Reset tip session state on app start
                    try {
                      await ref.read(tipServiceProvider).resetSessionState();
                    } catch (_) {}
                  } catch (_) {
                    /* ignore rating errors */
                  }
                });
                // Using HomePageElegant - Refined with rocket theme and bottom tabs
                return const SafeWidget(
                  context: 'app_initialization',
                  child: _PermissionChecker(child: HomePageElegant()),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingScreen(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App icon placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.volume_off,
                  size: 40,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 32),

              // Loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),

              // Loading message
              Text(
                message,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                '🤫 Master the Art of Silence',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(
    BuildContext context,
    String message,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.error.withValues(alpha: 0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error icon
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 24),

                // Error message
                Text(
                  'Oops! Something went wrong',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Retry button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Invalidate all providers to retry initialization
                      ref.invalidate(storageServiceProvider);
                      ref.invalidate(appSettingsProvider);
                      ref.invalidate(silenceDataNotifierProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Reset app data button
                TextButton(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Reset App Data'),
                            content: const Text(
                              'This will reset all app data and settings to their defaults. '
                              'This action cannot be undone.\n\n'
                              'Do you want to continue?',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.error,
                                  foregroundColor: theme.colorScheme.onError,
                                ),
                                child: const Text('Reset'),
                              ),
                            ],
                          ),
                    );

                    if (confirmed == true) {
                      try {
                        // Get storage service and reset
                        final storageServiceAsync = ref.read(
                          storageServiceProvider,
                        );
                        if (storageServiceAsync.hasValue) {
                          await storageServiceAsync.value!.resetAllData();
                        }

                        // Invalidate all providers
                        ref.invalidate(storageServiceProvider);
                        ref.invalidate(appSettingsProvider);
                        ref.invalidate(silenceDataNotifierProvider);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('App data has been reset'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to reset data: $e'),
                              backgroundColor: theme.colorScheme.error,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text(
                    'Reset App Data',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget that checks and requests microphone permission when the app starts
class _PermissionChecker extends ConsumerStatefulWidget {
  final Widget child;

  const _PermissionChecker({required this.child});

  @override
  ConsumerState<_PermissionChecker> createState() => _PermissionCheckerState();
}

class _PermissionCheckerState extends ConsumerState<_PermissionChecker> {
  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    // Wait a bit for the UI to settle
    await Future.delayed(
      const Duration(
        milliseconds: PermissionConstants.initialPermissionDelayMs,
      ),
    );

    if (!mounted) return;

    try {
      DebugLog.d('DEBUG: Starting permission check...');

      final silenceDetector = ref.read(silenceDetectorProvider);

      // Check if we already have permission with timeout
      final hasPermission = await silenceDetector.hasPermission().timeout(
        const Duration(seconds: PermissionConstants.permissionCheckTimeoutSec),
        onTimeout: () {
          DebugLog.d('DEBUG: Permission check timed out');
          return false;
        },
      );

      DebugLog.d('DEBUG: Initial permission status: $hasPermission');

      if (!hasPermission && mounted) {
        DebugLog.d('DEBUG: No permission, requesting...');

        // Request permission proactively with timeout
        final permissionGranted = await silenceDetector
            .requestPermission()
            .timeout(
              const Duration(
                seconds: PermissionConstants.permissionRequestTimeoutSec,
              ),
              onTimeout: () {
                DebugLog.d('DEBUG: Permission request timed out');
                return false;
              },
            );

        DebugLog.d('DEBUG: Permission request result: $permissionGranted');

        // If still no permission, show a dialog to guide the user
        if (!permissionGranted && mounted) {
          // Delay showing dialog to avoid overwhelming the user
          await Future.delayed(
            const Duration(
              milliseconds: PermissionConstants.dialogPostRequestDelayMs,
            ),
          );
          if (mounted) {
            await PermissionDialogs.showMicrophoneRationale(context, ref);
          }
        }
      } else if (hasPermission) {
        DebugLog.d('DEBUG: Permission already granted');
      }
    } catch (e) {
      // Permission request failed, but don't block the app
      DebugLog.d('DEBUG: Permission check failed: $e');

      // Only show error dialog if it's a critical failure
      if (mounted && e.toString().contains('permanently')) {
        await PermissionDialogs.showMicrophoneRationale(context, ref);
      }
    } finally {
      // No state flag needed post-refactor; keep hook for future extensions
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
