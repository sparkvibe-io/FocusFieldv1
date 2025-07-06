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
import 'package:silence_score/widgets/session_history_graph.dart';
import 'package:silence_score/widgets/compact_points_display.dart';
import 'package:silence_score/widgets/real_time_noise_chart.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final silenceDataAsyncValue = ref.watch(silenceDataNotifierProvider);
    final silenceState = ref.watch(silenceStateProvider);
    final silenceStateNotifier = ref.read(silenceStateProvider.notifier);
    final silenceDataNotifier = ref.read(silenceDataNotifierProvider.notifier);
    final decibelThreshold = ref.watch(decibelThresholdProvider);
    
    // Confetti controller
    final confettiController = useMemoized(() => ConfettiController(duration: const Duration(seconds: 2)));
    
    // Effect to handle confetti when success state changes
    useEffect(() {
      if (silenceState.success == true) {
        confettiController.play();
        // Reset success state after showing confetti
        Future.delayed(const Duration(seconds: 2), () {
          silenceStateNotifier.setSuccess(null);
        });
      }
      return null;
    }, [silenceState.success]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        actions: [
          IconButton(
            icon: Icon(_getThemeIcon(ref)),
            onPressed: () => _toggleTheme(context, ref),
            tooltip: 'Toggle theme',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
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
        // Main content - Use SafeArea and proper constraints
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Session History Graph at top - with flexible height
                Flexible(
                  flex: 2,
                  child: SessionHistoryGraph(
                    sessions: silenceData.recentSessions,
                    totalSessions: silenceData.totalSessions,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Compact Points Display
                CompactPointsDisplay(
                  totalPoints: silenceData.totalPoints,
                  currentStreak: silenceData.currentStreak,
                  bestStreak: silenceData.bestStreak,
                  totalSessions: silenceData.totalSessions,
                ),
                const SizedBox(height: 12),
                
                // Real-time noise chart (always visible) - with flexible height
                Flexible(
                  flex: 2,
                  child: RealTimeNoiseChart(
                    threshold: decibelThreshold,
                    isListening: silenceState.isListening,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Progress ring area - give it more space
                Flexible(
                  flex: 3, // Increased flex to make the ring area larger
                  fit: FlexFit.tight, // Ensures it fills the space
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Define a fixed height for the status message area to ensure it's always visible.
                      const messageAreaHeight = 40.0;

                      // Calculate the available space for the progress ring, reserving space for the message.
                      final availableWidth = constraints.maxWidth;
                      final availableHeight = constraints.maxHeight - messageAreaHeight;
                      
                      // Use the smaller dimension to ensure the ring stays circular and fits.
                      final maxRingSize = math.min(availableWidth, availableHeight);
                      
                      // Use all of the calculated space for the ring.
                      final progressRingSize = maxRingSize;
                      
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Progress Ring centered in the calculated available space
                          SizedBox(
                            width: progressRingSize,
                            height: progressRingSize,
                            child: ProgressRing(
                              progress: silenceState.progress,
                              isListening: silenceState.isListening,
                              sessionDurationSeconds: ref.read(sessionDurationProvider),
                              size: progressRingSize,
                              onTap: () => silenceState.isListening 
                                  ? _stopSilenceDetection(context, silenceStateNotifier, ref)
                                  : _startSilenceDetection(context, silenceStateNotifier, silenceDataNotifier, ref),
                            ),
                          ),
                          
                          // Reserved area for the status message
                          SizedBox(
                            height: messageAreaHeight,
                            child: Center(
                              child: _buildStatusMessage(context, silenceState),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
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

  Widget _buildStatusMessage(BuildContext context, silenceState) {
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly.isAtSameMomentAs(today)) {
      return 'Today at ${_formatTime(date)}';
    } else if (dateOnly.isAtSameMomentAs(yesterday)) {
      return 'Yesterday at ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year} at ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _startSilenceDetection(
    BuildContext context,
    silenceStateNotifier,
    silenceDataNotifier,
    WidgetRef ref,
  ) async {
    final silenceDetector = ref.read(silenceDetectorProvider);
    final sessionDuration = ref.read(sessionDurationProvider);
    final startTime = DateTime.now();
    
    // Clear previous readings for new session
    silenceDetector.clearReadings();
    
    silenceStateNotifier.setListening(true);
    silenceStateNotifier.setProgress(0.0);
    silenceStateNotifier.setSuccess(null);
    silenceStateNotifier.setError(null);
    silenceStateNotifier.setCanStop(true);
    
    await silenceDetector.startListening(
      onProgress: (progress) {
        silenceStateNotifier.setProgress(progress);
      },
      onComplete: (success) async {
        // Only complete if the session wasn't manually stopped
        if (silenceStateNotifier.state.canStop) {
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
        }
      },
      onError: (error) {
        // Only handle error if the session wasn't manually stopped
        if (silenceStateNotifier.state.canStop) {
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
    silenceStateNotifier,
    WidgetRef ref,
  ) {
    final silenceDetector = ref.read(silenceDetectorProvider);
    
    // Stop the detector
    silenceDetector.stopListening();
    
    // Reset the state - session is dropped, not counted
    silenceStateNotifier.stopSession();
    
    // Clear readings so the next session starts fresh
    silenceDetector.clearReadings();
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
    
    themeNotifier.cycleTheme();
    
    // Show brief feedback to user
    final nextTheme = AppThemeMode.values[(currentTheme.index + 1) % AppThemeMode.values.length];
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
