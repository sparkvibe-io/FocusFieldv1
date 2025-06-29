import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/providers/silence_provider.dart';
import 'package:silence_score/screens/settings_sheet.dart';
import 'package:silence_score/services/silence_detector.dart';
import 'package:silence_score/widgets/progress_ring.dart';
import 'package:silence_score/widgets/score_card.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final silenceData = ref.watch(silenceDataProvider);
    final silenceState = ref.watch(silenceStateProvider);
    final silenceStateNotifier = ref.read(silenceStateProvider.notifier);
    final silenceDataNotifier = ref.read(silenceDataProvider.notifier);
    
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
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const SettingsSheet(),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Score card
                  ScoreCard(
                    totalPoints: silenceData.totalPoints,
                    currentStreak: silenceData.currentStreak,
                    bestStreak: silenceData.bestStreak,
                  ),
                  const SizedBox(height: 48),
                  
                  // Progress ring or welcome message
                  if (silenceState.isListening)
                    ProgressRing(progress: silenceState.progress)
                  else
                    _buildWelcomeSection(context, silenceData),
                  
                  const SizedBox(height: 48),
                  
                  // Start/Stop button
                  _buildActionButton(
                    context,
                    silenceState,
                    silenceStateNotifier,
                    silenceDataNotifier,
                    ref,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Status message
                  _buildStatusMessage(context, silenceState),
                ],
              ),
            ),
          ),
          
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, silenceData) {
    final theme = Theme.of(context);
    
    if (silenceData.totalPoints == 0) {
      return Column(
        children: [
          Icon(
            Icons.volume_off,
            size: 80,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            AppConstants.welcomeMessage,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildActionButton(
    BuildContext context,
    silenceState,
    silenceStateNotifier,
    silenceDataNotifier,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: silenceState.isListening
            ? null // Disable button while listening
            : () => _startSilenceDetection(
                context,
                silenceStateNotifier,
                silenceDataNotifier,
                ref,
              ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: silenceState.isListening
              ? theme.colorScheme.surfaceVariant
              : theme.colorScheme.primary,
          foregroundColor: silenceState.isListening
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onPrimary,
        ),
        child: Text(
          silenceState.isListening
              ? AppConstants.listeningText
              : AppConstants.startButtonText,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusMessage(BuildContext context, silenceState) {
    final theme = Theme.of(context);
    
    if (silenceState.error != null) {
      return Text(
        silenceState.error!,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
        ),
        textAlign: TextAlign.center,
      );
    }
    
    if (silenceState.success == true) {
      return Text(
        AppConstants.successMessage,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    }
    
    if (silenceState.success == false) {
      return Text(
        AppConstants.failureMessage,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.error,
        ),
        textAlign: TextAlign.center,
      );
    }
    
    return const SizedBox.shrink();
  }

  Future<void> _startSilenceDetection(
    BuildContext context,
    silenceStateNotifier,
    silenceDataNotifier,
    WidgetRef ref,
  ) async {
    final silenceDetector = ref.read(silenceDetectorProvider);
    
    silenceStateNotifier.setListening(true);
    silenceStateNotifier.setProgress(0.0);
    silenceStateNotifier.setSuccess(null);
    silenceStateNotifier.setError(null);
    
    await silenceDetector.startListening(
      onProgress: (progress) {
        silenceStateNotifier.setProgress(progress);
      },
      onComplete: (success) async {
        silenceStateNotifier.setListening(false);
        silenceStateNotifier.setSuccess(success);
        
        if (success) {
          await silenceDataNotifier.addPoint();
        }
      },
      onError: (error) {
        silenceStateNotifier.setListening(false);
        silenceStateNotifier.setError(error);
      },
    );
  }
} 