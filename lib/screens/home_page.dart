import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/models/silence_data.dart';
import 'package:silence_score/providers/silence_provider.dart';
import 'package:silence_score/providers/theme_provider.dart';
import 'package:silence_score/screens/settings_sheet.dart';
import 'package:silence_score/widgets/progress_ring.dart';
import 'package:silence_score/widgets/practice_overview_widget.dart';
import 'package:silence_score/widgets/real_time_noise_chart.dart';
import 'package:silence_score/widgets/advanced_analytics_widget.dart';
import 'package:silence_score/widgets/feature_gate.dart';
import 'package:silence_score/widgets/error_boundary.dart';
import 'package:silence_score/widgets/audio_safe_widget.dart';
import 'package:silence_score/providers/subscription_provider.dart';
import 'package:silence_score/providers/accessibility_provider.dart';
import 'package:silence_score/providers/notification_provider.dart';
import 'package:silence_score/services/accessibility_service.dart';
import 'package:silence_score/services/notification_service.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final silenceDataAsyncValue = ref.watch(silenceDataNotifierProvider);
    final silenceState = ref.watch(silenceStateProvider);
    final silenceStateNotifier = ref.read(silenceStateProvider.notifier);
    final silenceDataNotifier = ref.read(silenceDataNotifierProvider.notifier);
    final decibelThreshold = ref.watch(decibelThresholdProvider);
    
    // Accessibility
    final accessibilityService = ref.watch(accessibilityServiceProvider);
    final accessibilitySettings = ref.watch(accessibilitySettingsProvider);
    
    // Notifications
    final notificationService = ref.watch(notificationServiceProvider);
    final notificationSettings = ref.watch(notificationSettingsProvider);
    
    // Initialize services
    useEffect(() {
      accessibilityService.initialize();
      accessibilityService.updateSettings(
        vibration: accessibilitySettings['enableVibration'],
        voiceOver: accessibilitySettings['enableVoiceOver'],
        highContrast: accessibilitySettings['enableHighContrast'],
        largeText: accessibilitySettings['enableLargeText'],
      );
      
      notificationService.initialize();
      notificationService.updateSettings(
        notifications: notificationSettings['enableNotifications'],
        dailyReminders: notificationSettings['enableDailyReminders'],
        sessionComplete: notificationSettings['enableSessionComplete'],
      );
      
      return null;
    }, [accessibilitySettings, notificationSettings]);
    
    // Confetti controller
    final confettiController = useMemoized(() => ConfettiController(duration: const Duration(seconds: 2)));
    
    // Effect to handle confetti when success state changes
    useEffect(() {
      if (silenceState.success == true) {
        confettiController.play();
        accessibilityService.vibrateOnEvent(AccessibilityEvent.sessionComplete);
        accessibilityService.announceSessionComplete(true);
        // Reset success state after showing confetti
        Future.delayed(const Duration(seconds: 2), () {
          silenceStateNotifier.setSuccess(null);
        });
      } else if (silenceState.success == false) {
        accessibilityService.vibrateOnEvent(AccessibilityEvent.sessionFailed);
        accessibilityService.announceSessionComplete(false);
      }
      return null;
    }, [silenceState.success]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        actions: [
          IconButton(
            icon: Icon(_getThemeIcon(ref)),
            onPressed: () {
              ref.read(accessibilityServiceProvider).vibrateOnEvent(AccessibilityEvent.buttonPress);
              _toggleTheme(context, ref);
            },
            tooltip: 'Toggle theme',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ref.read(accessibilityServiceProvider).vibrateOnEvent(AccessibilityEvent.buttonPress);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const SettingsSheet(),
              );
            },
          ),
        ],
      ),
      body: silenceDataAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading data: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(silenceDataNotifierProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (silenceData) {
          return _buildMainContent(
            context,
            silenceData,
            silenceState,
            silenceStateNotifier,
            silenceDataNotifier,
            decibelThreshold,
            confettiController,
            ref,
          );
        },
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    SilenceData silenceData,
    SilenceState silenceState,
    SilenceStateNotifier silenceStateNotifier,
    SilenceDataNotifier silenceDataNotifier,
    double decibelThreshold,
    ConfettiController confettiController,
    WidgetRef ref,
  ) {
    return Stack(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Combined Practice Overview
                PracticeOverviewWidget(silenceData: silenceData),
                const SizedBox(height: 12),

                // Advanced Analytics (Premium, collapsible)
                FeatureGate(
                  featureId: 'advanced_analytics',
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: AdvancedAnalyticsWidget(silenceData: silenceData),
                  ),
                ),

                // Controlled spacing instead of Spacer
                const SizedBox(height: 32),

                // Real-time noise chart with audio crash protection
                SizedBox(
                  height: 120,
                  child: AudioSafeWidget(
                    debugContext: 'real_time_noise_chart',
                    fallback: Container(
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.volume_off,
                            size: 32,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Audio chart recovering...',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    child: RealTimeNoiseChart(
                      threshold: decibelThreshold,
                      isListening: silenceState.isListening,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Progress ring area - give it a prominent size
                LayoutBuilder(
                  builder: (context, constraints) {
                    final size = math.min(constraints.maxWidth * 0.55, 280.0).clamp(200.0, 280.0);
                    return Column(
                      children: [
                        SizedBox(
                          width: size,
                          height: size,
                          child: SafeWidget(
                            context: 'progress_ring',
                            fallback: Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.surfaceContainer,
                              ),
                              child: const Center(
                                child: Icon(Icons.refresh, size: 32),
                              ),
                            ),
                            child: ProgressRing(
                              progress: silenceState.progress,
                              isListening: silenceState.isListening,
                              sessionDurationSeconds: ref.read(sessionDurationProvider),
                              size: size,
                              onTap: () {
                                ref.read(accessibilityServiceProvider).vibrateOnEvent(AccessibilityEvent.buttonPress);
                                return silenceState.isListening
                                    ? _stopSilenceDetection(context, silenceStateNotifier, ref)
                                    : _startSilenceDetection(context, silenceStateNotifier, silenceDataNotifier, ref);
                              },
                            ),
                          ),
                        ),
                        // Reserved area for the status message
                        SizedBox(
                          height: 40,
                          child: Center(
                            child: _buildStatusMessage(context, silenceState),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20), // Some padding at the bottom
              ],
            ),
          ),
        ),
        // Confetti overlay
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirection: math.pi / 2,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusMessage(BuildContext context, SilenceState silenceState) {
    final theme = Theme.of(context);
    
    if (silenceState.error != null) {
      return Text(
        silenceState.error!,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
    
    if (silenceState.success == true) {
      return Text(
        AppConstants.successMessage,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    
    if (silenceState.success == false) {
      return Text(
        AppConstants.failureMessage,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    
    return const SizedBox.shrink();
  }

  Future<void> _startSilenceDetection(
    BuildContext context,
    SilenceStateNotifier silenceStateNotifier,
    SilenceDataNotifier silenceDataNotifier,
    WidgetRef ref,
  ) async {
    final silenceDetector = ref.read(silenceDetectorProvider);
    final sessionDuration = ref.read(sessionDurationProvider);
    final accessibilityService = ref.read(accessibilityServiceProvider);
    final notificationService = ref.read(notificationServiceProvider);
    final startTime = DateTime.now();
    
    // Record session time for notifications
    await notificationService.recordSessionTime(startTime);
    
    // Clear previous readings for new session
    silenceDetector.clearReadings();
    
    silenceStateNotifier.setListening(true);
    silenceStateNotifier.setProgress(0.0);
    silenceStateNotifier.setSuccess(null);
    silenceStateNotifier.setError(null);
    silenceStateNotifier.setCanStop(true);
    
    // Accessibility announcements (only before session)
    accessibilityService.vibrateOnEvent(AccessibilityEvent.sessionStart);
    accessibilityService.announceSessionStart((sessionDuration / 60).round());
    
    await silenceDetector.startListening(
      onProgress: (progress) {
        silenceStateNotifier.setProgress(progress);
        // No voice announcements during session to avoid breaking silence
      },
      onComplete: (success) async {
        // Only complete if the session wasn't manually stopped
        if (ref.read(silenceStateProvider).canStop) {
          silenceStateNotifier.setListening(false);
          silenceStateNotifier.setCanStop(false);
          silenceStateNotifier.setSuccess(success);
          
          // Get session statistics
          final sessionStats = silenceDetector.getSessionStats();
          final endTime = DateTime.now();
          final actualDuration = endTime.difference(startTime).inSeconds;
          
          // Calculate points: 1 point per minute of successful session
          final durationInMinutes = (sessionDuration / 60).round();
          final pointsEarned = success ? (durationInMinutes * AppConstants.pointsPerMinute) : 0;
          
          // Create session record
          final sessionRecord = SessionRecord(
            date: startTime,
            pointsEarned: pointsEarned,
            averageNoise: sessionStats.averageNoise,
            duration: actualDuration,
            completed: success,
          );
          
          // Add session record to data
          await silenceDataNotifier.addSessionRecord(sessionRecord);
          
          // Show session completion notification if enabled
          if (notificationService.enableSessionComplete) {
            final message = notificationService.getCompletionMessage(success, durationInMinutes);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
              ),
              );
            }
          }
        }
      },
      onError: (error) {
        // Only handle error if the session wasn't manually stopped
        if (ref.read(silenceStateProvider).canStop) {
          silenceStateNotifier.setListening(false);
          silenceStateNotifier.setCanStop(false);
          silenceStateNotifier.setError(error);
          
          // Still record the session attempt even if it failed
          final sessionStats = silenceDetector.getSessionStats();
          final endTime = DateTime.now();
          final actualDuration = endTime.difference(startTime).inSeconds;
          
          final sessionRecord = SessionRecord(
            date: startTime,
            pointsEarned: 0,
            averageNoise: sessionStats.averageNoise,
            duration: actualDuration,
            completed: false,
          );
          
          silenceDataNotifier.addSessionRecord(sessionRecord);
          
          // Show dialog with option to open settings if permission is permanently denied
          if (error.contains('Settings > Privacy & Security')) {
            _showPermissionDialog(context, ref);
          }
        }
      },
    );
  }

  void _stopSilenceDetection(
    BuildContext context,
    SilenceStateNotifier silenceStateNotifier,
    WidgetRef ref,
  ) {
    final silenceDetector = ref.read(silenceDetectorProvider);
    final accessibilityService = ref.read(accessibilityServiceProvider);
    
    // Stop the detector
    silenceDetector.stopListening();
    
    // Reset the state - session is dropped, not counted
    silenceStateNotifier.stopSession();
    
    // Clear readings so the next session starts fresh
    silenceDetector.clearReadings();
    
    // Accessibility feedback
    accessibilityService.vibrateOnEvent(AccessibilityEvent.buttonPress);
  }

  void _showPermissionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission Required'),
        content: const Text(
          'Silence Score needs microphone access to measure sound levels. '
          'Please enable microphone permission in your device settings.\n\n'
          'Go to Settings > Privacy & Security > Microphone > Silence Score '
          'and enable the permission.',
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

  IconData _getThemeIcon(WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    return currentTheme.icon;
  }

  void _toggleTheme(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeProvider.notifier);
    final currentTheme = ref.read(themeProvider);
    final hasPremiumAccess = ref.read(premiumAccessProvider);
    
    themeNotifier.cycleTheme(hasPremiumAccess: hasPremiumAccess);
    
    // Show brief feedback to user
    final availableThemes = hasPremiumAccess 
        ? AppThemeMode.values 
        : [AppThemeMode.system, AppThemeMode.light, AppThemeMode.dark];
    final currentIndex = availableThemes.indexOf(currentTheme);
    final nextIndex = currentIndex >= 0 
        ? (currentIndex + 1) % availableThemes.length
        : 0;
    final nextTheme = availableThemes[nextIndex];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Theme: ${nextTheme.displayName}'),
        duration: const Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
      ),
    );
  }
}