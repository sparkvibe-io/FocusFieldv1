import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/providers/silence_provider.dart';
import 'package:silence_score/providers/subscription_provider.dart';
import 'package:silence_score/screens/home_page.dart';
import 'package:silence_score/services/silence_detector.dart';

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
      error: (error, stack) => _buildErrorScreen(context, 'Initialization failed: $error', ref),
      data: (storageService) {
        return settingsAsync.when(
          loading: () => _buildLoadingScreen(context, 'Loading settings...'),
          error: (error, stack) => _buildErrorScreen(context, 'Settings loading failed: $error', ref),
          data: (settings) {
            return silenceDataAsync.when(
              loading: () => _buildLoadingScreen(context, 'Loading user data...'),
              error: (error, stack) => _buildErrorScreen(context, 'Data loading failed: $error', ref),
              data: (silenceData) {
                // All data loaded successfully, show main app with permission check
                return _PermissionChecker(child: const HomePage());
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
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
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

  Widget _buildErrorScreen(BuildContext context, String message, WidgetRef ref) {
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
                      builder: (context) => AlertDialog(
                        title: const Text('Reset App Data'),
                        content: const Text(
                          'This will reset all app data and settings to their defaults. '
                          'This action cannot be undone.\n\n'
                          'Do you want to continue?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
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
                        final storageServiceAsync = ref.read(storageServiceProvider);
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
  bool _hasCheckedPermission = false;
  
  @override
  void initState() {
    super.initState();
    _checkPermission();
  }
  
  Future<void> _checkPermission() async {
    // Wait a bit for the UI to settle
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (!mounted) return;
    
    try {
      debugPrint('DEBUG: Starting permission check...');
      final silenceDetector = ref.read(silenceDetectorProvider);
      
      // Check if we already have permission
      final hasPermission = await silenceDetector.hasPermission();
      debugPrint('DEBUG: Initial permission status: $hasPermission');
      
      if (!hasPermission) {
        debugPrint('DEBUG: No permission, requesting...');
        // Request permission proactively
        final permissionGranted = await silenceDetector.requestPermission();
        debugPrint('DEBUG: Permission request result: $permissionGranted');
        
        // If still no permission, show a dialog to guide the user
        if (!permissionGranted && mounted) {
          _showPermissionDialog(context);
        }
      } else {
        debugPrint('DEBUG: Permission already granted');
      }
    } catch (e) {
      // Permission request failed, but don't block the app
      debugPrint('DEBUG: Permission check failed: $e');
      
      // Show error dialog if permission check fails
      if (mounted) {
        _showPermissionDialog(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _hasCheckedPermission = true;
        });
      }
    }
  }
  
  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission Required'),
        content: const Text(
          'Silence Score needs microphone access to measure sound levels and detect silence.\n\n'
          'Without this permission, the app cannot function properly.\n\n'
          'Please tap "Grant Permission" to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Try requesting permission again
              await _retryPermissionRequest();
            },
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _retryPermissionRequest() async {
    try {
      final silenceDetector = ref.read(silenceDetectorProvider);
      final permissionGranted = await silenceDetector.requestPermission();
      debugPrint('DEBUG: Retry permission request result: $permissionGranted');
      
      if (!permissionGranted && mounted) {
        // Show settings dialog if permission is still denied
        _showSettingsDialog(context);
      }
    } catch (e) {
      debugPrint('DEBUG: Retry permission request failed: $e');
      if (mounted) {
        _showSettingsDialog(context);
      }
    }
  }
  
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Microphone permission is required for Silence Score to work.\n\n'
          'Please enable microphone permission in your device settings:\n\n'
          'Settings > Apps > Silence Score > Permissions > Microphone',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final silenceDetector = ref.read(silenceDetectorProvider);
              await silenceDetector.openSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
