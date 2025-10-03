import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:focus_field/constants/app_constants.dart';
import 'package:focus_field/models/silence_data.dart';
import 'package:focus_field/providers/silence_provider.dart';
import 'package:focus_field/providers/theme_provider.dart';
import 'package:focus_field/screens/settings_sheet.dart';
import 'package:focus_field/widgets/progress_ring.dart';
import 'package:focus_field/constants/layout_constants.dart';
import 'package:focus_field/widgets/real_time_noise_chart.dart';
import 'package:focus_field/widgets/error_boundary.dart';
import 'package:focus_field/widgets/audio_safe_widget.dart';
import 'package:focus_field/widgets/permission_dialogs.dart';
import 'package:focus_field/providers/accessibility_provider.dart';
import 'package:focus_field/providers/notification_provider.dart';
import 'package:focus_field/services/accessibility_service.dart';
import 'package:focus_field/providers/subscription_provider.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:focus_field/utils/debug_log.dart';
import 'package:focus_field/theme/theme_extensions.dart';
import 'package:flutter/services.dart';
import 'package:focus_field/widgets/banner_ad_footer.dart';
import 'package:focus_field/widgets/theme_overlays.dart';
import 'package:focus_field/services/tip_service.dart';
import 'package:focus_field/widgets/tip_info_icon.dart';
import 'package:focus_field/providers/tip_info_provider.dart';
import 'package:focus_field/widgets/quick_duration_selector.dart';
import 'package:focus_field/widgets/tabbed_overview_widget.dart';
import 'package:focus_field/widgets/mission_capsule.dart';
import 'package:focus_field/widgets/compact_noise_tile.dart';
import 'package:focus_field/providers/activity_provider.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(
      context,
    ); // may be null during initial test frame
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

      // Initialize tip service to ensure tips are available
      ref.read(tipServiceProvider).initializeOnAppStart();

      // Show automatic tips on app start in development mode
      ref.read(tipServiceProvider).maybeShowOnAppStart(context);

      return null;
    }, [accessibilitySettings, notificationSettings]);

    // Confetti controller
    final confettiController = useMemoized(
      () => ConfettiController(duration: const Duration(seconds: 2)),
    );

    // Effect to handle confetti when success state changes
    useEffect(() {
      if (silenceState.success == true) {
        confettiController.play();
        accessibilityService.vibrateOnEvent(AccessibilityEvent.sessionComplete);
        accessibilityService.announceSessionComplete(true);
        // Tips now only show when user actively clicks the lightbulb icon
        // This provides better user control and prevents unwanted interruptions
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

    final dramatic = Theme.of(context).extension<DramaticThemeStyling>();
    final themeMode = ref.watch(themeProvider);
    final isCyberNeon = themeMode == AppThemeMode.cyberNeon;
    final isMidnightTeal = themeMode == AppThemeMode.midnightTeal;
    final brightness = Theme.of(context).brightness;
    final gradient = dramatic?.appBackgroundGradient;

    return Stack(
      children: [
        // Base gradient / surface
        Container(
          decoration: BoxDecoration(
            gradient: gradient,
            color:
                gradient == null ? Theme.of(context).colorScheme.surface : null,
          ),
        ),
        // Cyber Neon dynamic layer: radial pulse + faint scanlines
        if (isCyberNeon) ...[
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedPulseOverlay(
                color: const Color(0xFF00FFF0).withValues(alpha: 0.12),
                secondary: const Color(0xFFFF2EC4).withValues(alpha: 0.10),
              ),
            ),
          ),
          const Positioned.fill(
            child: IgnorePointer(child: ScanlineOverlay(opacity: 0.07)),
          ),
        ],
        // Midnight Teal: drifting vertical mist + micro particles
        if (isMidnightTeal) ...[
          Positioned.fill(
            child: IgnorePointer(
              child: MistOverlay(
                baseColor: const Color(0xFF00D295).withValues(alpha: 0.12),
                highlightColor: const Color(0xFF43F56A).withValues(alpha: 0.10),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: ParticleDriftOverlay(
                color: const Color(0xFF43F56A).withValues(alpha: 0.30),
              ),
            ),
          ),
        ],
        Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  brightness == Brightness.dark
                      ? Brightness.light
                      : Brightness.dark,
              statusBarBrightness:
                  brightness == Brightness.dark
                      ? Brightness.dark
                      : Brightness.light,
            ),
            leading: Consumer(
              builder: (context, ref, child) {
                final hasNewTipsAsync = ref.watch(hasNewTipsProvider);
                final isEnabledAsync = ref.watch(tipServiceEnabledProvider);

                return TipInfoIconWithAnimation(
                  hasNewTips: hasNewTipsAsync.when(
                    data: (hasNew) => hasNew,
                    loading: () => false,
                    error: (_, __) => false,
                  ),
                  isEnabled: isEnabledAsync.when(
                    data: (enabled) => enabled,
                    loading: () => true, // Default to enabled while loading
                    error: (_, __) => true,
                  ),
                  onTap: () => _showSimpleTip(context, ref),
                );
              },
            ),
            title: Text(
              loc?.appTitle ?? 'Focus Field',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            actions: [
              IconButton(
                icon: Icon(_getThemeIcon(ref)),
                onPressed: () {
                  ref
                      .read(accessibilityServiceProvider)
                      .vibrateOnEvent(AccessibilityEvent.buttonPress);
                  _toggleTheme(context, ref);
                },
                tooltip: loc?.toggleThemeTooltip ?? 'Toggle theme',
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  ref
                      .read(accessibilityServiceProvider)
                      .vibrateOnEvent(AccessibilityEvent.buttonPress);
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
          body: _SubscriptionInitializer(
            child: silenceDataAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          loc?.errorLoadingSettings(error.toString()) ??
                              'Error loading settings: $error',
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed:
                              () => ref.invalidate(silenceDataNotifierProvider),
                          child: Text(loc?.actionRetry ?? 'Retry'),
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
          ),
        ),
      ],
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate available height for content
                final availableHeight = constraints.maxHeight;
                final isSmallScreen =
                    availableHeight <
                    LayoutConstants.smallScreenHeightThreshold;

                final width = constraints.maxWidth;
                final isLarge = width >= LayoutConstants.largeWidth;

                Widget buildRingSection() {
                  return LayoutBuilder(
                    builder: (context, ringConstraints) {
                      final ringSize = LayoutConstants.computeProgressRingSize(
                        ringConstraints.maxWidth,
                        isSmallScreen: isSmallScreen,
                        availableHeight: availableHeight,
                      );
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Quick Duration Selector above the ring
                          if (!silenceState.isListening)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: QuickDurationSelector(
                                durations: const [1, 5, 10, 15, 30, 60, 90, 120], // Removed 20 for single-line layout
                                selectedDurationSeconds: ref.watch(activeSessionDurationProvider),
                                onDurationSelected: (durationSeconds) {
                                  ref.read(activeSessionDurationProvider.notifier)
                                     .state = durationSeconds;
                                },
                                enabled: !silenceState.isListening,
                              ),
                            ),
                          SizedBox(
                            width: ringSize,
                            height: ringSize,
                            child: SafeWidget(
                              context: 'progress_ring',
                              fallback: Container(
                                width: ringSize,
                                height: ringSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainer,
                                ),
                                child: const Center(
                                  child: Icon(Icons.refresh, size: 32),
                                ),
                              ),
                              child: ProgressRing(
                                progress: silenceState.progress,
                                isListening: silenceState.isListening,
                                sessionDurationSeconds: ref.watch(
                                  activeSessionDurationProvider,
                                ),
                                size: ringSize,
                                showSetDuration: true,
                                onTap: () {
                                  ref
                                      .read(accessibilityServiceProvider)
                                      .vibrateOnEvent(
                                        AccessibilityEvent.buttonPress,
                                      );
                                  return silenceState.isListening
                                      ? _stopSilenceDetection(
                                        context,
                                        silenceStateNotifier,
                                        ref,
                                      )
                                      : _startSilenceDetection(
                                        context,
                                        silenceStateNotifier,
                                        silenceDataNotifier,
                                        ref,
                                      );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height:
                                isSmallScreen
                                    ? LayoutConstants.progressStatusHeightSmall
                                    : LayoutConstants
                                        .progressStatusHeightRegular,
                            child: Center(
                              child: _buildStatusMessage(context, silenceState),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }

                Widget buildInfoColumn() {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (AppConstants.featureMissionsUi) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: MissionCapsule(),
                        ),
                        const SizedBox(height: 8),
                        // Activity chips row
                        Consumer(builder: (context, ref, _) {
                          final selected = ref.watch(selectedActivityProvider);
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                for (final a in activityTypes)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: ChoiceChip(
                                      label: Text(a),
                                      selected: a == selected,
                                      onSelected: (_) => ref.read(selectedActivityProvider.notifier).set(a),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                      ],
                      // NEW: Tabbed Overview Widget (combines Practice Overview + Advanced Analytics)
                      TabbedOverviewWidget(silenceData: silenceData),
                      SizedBox(
                        height:
                            isSmallScreen
                                ? LayoutConstants.spacingSmall
                                : LayoutConstants.spacingRegular,
                      ),
                      if (AppConstants.featureMissionsUi && !silenceState.isListening)
                        // Compact tile when not listening: no ambient monitoring; tap to expand modal chart.
                        CompactNoiseTile(
                          threshold: decibelThreshold,
                          isListening: silenceState.isListening,
                          onExpand: () {
                            showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  initialChildSize: 0.6,
                                  minChildSize: 0.4,
                                  maxChildSize: 0.95,
                                  expand: false,
                                  builder: (context, controller) {
                                    return Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Material(
                                        color: Theme.of(context).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(16),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Noise Level',
                                                    style: Theme.of(context).textTheme.titleMedium,
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Close',
                                                    icon: const Icon(Icons.close),
                                                    onPressed: () => Navigator.of(context).pop(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Expanded(
                                                child: AudioSafeWidget(
                                                  debugContext: 'real_time_noise_chart_modal',
                                                  fallback: const SizedBox.shrink(),
                                                  child: RealTimeNoiseChart(
                                                    threshold: decibelThreshold,
                                                    isListening: silenceState.isListening,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        )
                      else
                        SizedBox(
                          height:
                              isSmallScreen
                                  ? LayoutConstants.noiseChartSmallHeight
                                  : (isLarge ? 160 : LayoutConstants.noiseChartRegularHeight),
                          child: AudioSafeWidget(
                            debugContext: 'real_time_noise_chart',
                            fallback: Container(
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
                                    size: isSmallScreen ? 24 : 32,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppLocalizations.of(context)?.audioChartRecovering ?? 'Audio chart recovering…',
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
                      SizedBox(
                        height:
                            isSmallScreen
                                ? LayoutConstants.spacingAfterChartSmall
                                : LayoutConstants.spacingAfterChartRegular,
                      ),
                    ],
                  );
                }

                final showAds = !ref.watch(premiumAccessProvider);

                final content =
                    isLarge
                        ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  buildRingSection(),
                                  if (showAds) ...[
                                    const SizedBox(height: 28),
                                    const FooterBannerAd(),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(flex: 7, child: buildInfoColumn()),
                          ],
                        )
                        : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 16),
                            buildInfoColumn(),
                            buildRingSection(),
                            if (showAds) ...[
                              const SizedBox(height: 28),
                              const FooterBannerAd(),
                            ],
                            SizedBox(
                              height:
                                  isSmallScreen
                                      ? LayoutConstants.bottomPaddingSmall
                                      : LayoutConstants.bottomPaddingRegular,
                            ),
                          ],
                        );

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: availableHeight - 32,
                    ),
                    child: content,
                  ),
                );
              },
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
        (AppLocalizations.of(context)?.statusSuccess) ?? 'Success',
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
        (AppLocalizations.of(context)?.statusFailure) ?? 'Failed',
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
          final pointsEarned =
              success ? (durationInMinutes * AppConstants.pointsPerMinute) : 0;

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

          // Phase 1: mark first micro-goal celebration per day (1 minute)
          if (success && actualDuration >= 60) {
            final missionDayKey = _missionDayKey(DateTime.now());
            final celebrated = await ref.read(firstMicroCelebratedProvider(missionDayKey).future);
            if (!celebrated) {
              // trigger existing confetti
              ref.read(accessibilityServiceProvider).vibrateOnEvent(AccessibilityEvent.sessionComplete);
              // store flag
              await ref.read(firstMicroCelebratedControllerProvider).markCelebrated(missionDayKey);
            }
          }

          // System notification + in-app feedback
          if (notificationService.enableSessionComplete) {
            if (!context.mounted) return;
            notificationService.showSessionComplete(
              context,
              success,
              durationInMinutes,
            );
            final message = notificationService.getCompletionMessage(
              success,
              durationInMinutes,
            );
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
            if (context.mounted) {
              PermissionDialogs.showMicrophoneSettings(context, ref);
            }
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

  // Deprecated _showPermissionDialog removed (centralized in PermissionDialogs)

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
    final availableThemes =
        hasPremiumAccess
            ? AppThemeMode.values
            : [AppThemeMode.system, AppThemeMode.light, AppThemeMode.dark];
    final currentIndex = availableThemes.indexOf(currentTheme);
    final nextIndex =
        currentIndex >= 0 ? (currentIndex + 1) % availableThemes.length : 0;
    final nextTheme = availableThemes[nextIndex];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)?.themeChanged(nextTheme.displayName) ??
              'Theme changed to ${nextTheme.displayName}',
        ),
        duration: const Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
      ),
    );
  }

  void _showSimpleTip(BuildContext context, WidgetRef ref) {
    // Show the current tip (same tip for 5 minutes, even if muted)
    ref.read(tipServiceProvider).showCurrentTip(context);
  }

  String _missionDayKey(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return 'mission_${d.toIso8601String().split('T').first}';
  }
}

// Ensures the SubscriptionService is initialized exactly once early in the widget tree.
class _SubscriptionInitializer extends ConsumerStatefulWidget {
  const _SubscriptionInitializer({required this.child});
  final Widget child;

  @override
  ConsumerState<_SubscriptionInitializer> createState() =>
      _SubscriptionInitializerState();
}

class _SubscriptionInitializerState
    extends ConsumerState<_SubscriptionInitializer> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialize();
  }

  Future<void> _initialize() async {
    if (_started) return;
    _started = true;
    try {
      await ref.read(subscriptionServiceProvider).initialize();
    } catch (e) {
      DebugLog.d('Subscription initialization failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
