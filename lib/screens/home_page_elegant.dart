// ignore_for_file: unused_element
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;
import 'dart:async';
import '../providers/silence_provider.dart';
import '../providers/accessibility_provider.dart';
import '../providers/notification_provider.dart';
import '../services/accessibility_service.dart';
import '../models/silence_data.dart';
import '../constants/app_constants.dart';
import '../widgets/inline_noise_panel.dart';
import '../widgets/quest_capsule.dart';
import '../widgets/adaptive_threshold_chip.dart';
import '../widgets/activity_edit_sheet.dart';
import '../widgets/activity_rings_widget.dart';
import '../widgets/adaptive_activity_rings_widget.dart';
import '../widgets/focus_mode_overlay.dart';
import '../providers/theme_provider.dart';
import '../providers/user_preferences_provider.dart';
import '../theme/theme_extensions.dart';
import './trends_sheet.dart';
import './settings_sheet.dart';
import '../providers/subscription_provider.dart';
import 'package:intl/intl.dart';
import '../widgets/share_preview_sheet.dart';
import 'package:confetti/confetti.dart';
// Ambient Quests flags/providers
import 'package:focus_field/constants/ambient_flags.dart';
import 'package:focus_field/providers/ambient_quest_provider.dart';
import 'package:focus_field/models/ambient_models.dart';
import '../services/tip_service.dart';
import '../utils/responsive_utils.dart';
import '../widgets/banner_ad_footer.dart';
// import '../providers/mission_provider.dart';
// import '../models/mission.dart';

/// Elegant home screen inspired by Apple Fitness with modern Material Design
class HomePageElegant extends ConsumerStatefulWidget {
  const HomePageElegant({super.key});

  @override
  ConsumerState<HomePageElegant> createState() => _HomePageElegantState();
}

class _HomePageElegantState extends ConsumerState<HomePageElegant>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;
  late final ConfettiController _confetti;
  bool _sessionListenerWired = false;
  bool _focusModeActive = false;
  // Debounce for theme toggle
  DateTime? _lastThemeToggleTime;
  // Sessions tab: selected session duration in minutes
  int _selectedDurationMinutes = 1;
  // Live calm tracking handled by liveCalmPercentProvider
  StreamSubscription<double>? _noiseSub;
  // Ambient Quests: 1Hz tick subscription for AmbientSessionEngine
  StreamSubscription<double>? _ambientTickSub;
  // Activity list scroll state for the Summary card
  final ScrollController _activityScrollController = ScrollController();
  int _activityPageIndex = 0; // which chunk of 3 items is visible
  static const int _visibleActivityRows = 3;
  // Row height is computed dynamically per build to fill most of the card.
  final double _activityRowHeight = 40;
  static const double _activityRowSpacing = 1;
  // Consistent card style like "Last 7 Days"
  // Note: _cardRadius was unused; card decoration now comes from context.cardDecoration

  // Responsive card padding based on screen size
  EdgeInsets _getCardPadding(BuildContext context) {
    final padding = context.cardPadding;
    return EdgeInsets.fromLTRB(padding, padding - 2, padding, padding);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });

    // Listen to the activity list scroll to update the left indicator dots
    _activityScrollController.addListener(() {
      final itemExtent = _activityRowHeight + _activityRowSpacing;
      // Index of the first fully/partially visible item
      final firstIndex =
          (_activityScrollController.offset / itemExtent)
              .clamp(0, double.infinity)
              .floor();
      final page = firstIndex ~/ _visibleActivityRows;
      if (page != _activityPageIndex) {
        setState(() => _activityPageIndex = page);
      }
    });

    // No local counters needed; liveCalmPercentProvider computes from stream.
  }

  @override
  void dispose() {
    try {
      _noiseSub?.cancel();
    } catch (_) {}
    try {
      _ambientTickSub?.cancel();
    } catch (_) {}
    _activityScrollController.dispose();
    _tabController.dispose();
    _confetti.dispose();
    super.dispose();
  }

  /// Shows share options with preview bottom sheet.
  /// Calculates both daily and weekly stats for user to choose.
  void _showShareOptions(BuildContext context, WidgetRef ref, SilenceData data) {
    final sessions = data.recentSessions;
    final now = DateTime.now();
    
    // Calculate weekly stats
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    int weeklyMinutes = 0;
    int weeklySessions = 0;
    int weeklySuccessCount = 0;
    final weeklyActivityMinutes = <String, int>{};
    
    // Calculate today's stats
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    
    int dailyMinutes = 0;
    int dailySessions = 0;
    int dailySuccessCount = 0;
    final dailyActivityMinutes = <String, int>{};
    
    for (final session in sessions) {
      // Weekly calculation
      if (session.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          session.date.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        weeklyMinutes += session.duration ~/ 60;
        weeklySessions++;
        if (session.completed) weeklySuccessCount++;
        
        final activity = session.activity ?? 'Other';
        weeklyActivityMinutes[activity] = (weeklyActivityMinutes[activity] ?? 0) + (session.duration ~/ 60);
      }
      
      // Daily calculation
      if (session.date.isAfter(todayStart) && session.date.isBefore(todayEnd)) {
        dailyMinutes += session.duration ~/ 60;
        dailySessions++;
        if (session.completed) dailySuccessCount++;
        
        final activity = session.activity ?? 'Other';
        dailyActivityMinutes[activity] = (dailyActivityMinutes[activity] ?? 0) + (session.duration ~/ 60);
      }
    }
    
    final weeklySuccessRate = weeklySessions > 0 ? (weeklySuccessCount / weeklySessions * 100) : 0.0;

    final dailySuccessRate = dailySessions > 0 ? (dailySuccessCount / dailySessions * 100) : 0.0;

    final formatter = DateFormat('MMM d');
    final weekRange = '${formatter.format(startOfWeek)} - ${formatter.format(endOfWeek)}, ${now.year}';
    final dateFormatter = DateFormat('MMMM d, y');
    final todayRange = dateFormatter.format(now);

    // Determine initial time range based on available data
    final initialTimeRange = dailyMinutes > 0
        ? ShareTimeRange.today
        : ShareTimeRange.weekly;

    // Use today's data if available, otherwise weekly
    final displayMinutes = dailyMinutes > 0 ? dailyMinutes : weeklyMinutes;
    final displaySessions = dailyMinutes > 0 ? dailySessions : weeklySessions;
    final displaySuccessRate = dailyMinutes > 0 ? dailySuccessRate : weeklySuccessRate;
    final displayActivityMinutes = dailyMinutes > 0 ? dailyActivityMinutes : weeklyActivityMinutes;
    final displayDateRange = dailyMinutes > 0 ? todayRange : weekRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SharePreviewSheet(
        totalMinutes: displayMinutes,
        sessionCount: displaySessions,
        successRate: displaySuccessRate,
        activityMinutes: displayActivityMinutes,
        dateRange: displayDateRange,
        initialTimeRange: initialTimeRange,
      ),
    );
  }

  // Helper to get responsive scale factor based on screen size
  double _getScaleFactor(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    const baseWidth = 360.0; // Base design width (standard phone)
    final currentWidth = size.width;

    // Scale between 1.0 (small phones) and 1.8 (large tablets)
    final scale = (currentWidth / baseWidth).clamp(1.0, 1.8);
    return scale;
  }

  // Helper to get responsive padding based on screen size
  double _getResponsivePadding(BuildContext context, double basePadding) {
    final scale = _getScaleFactor(context);
    return basePadding * scale;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final orientation = MediaQuery.orientationOf(context);

    // Detect tablet landscape: width >= 840 (large tablet) and landscape orientation
    // Matches our orientation locking policy (landscape only allowed on ≥840dp devices)
    final isTabletLandscape =
        size.width >= 840 && orientation == Orientation.landscape;

    // Listen for session completion/failure to trigger confetti and a11y events
    if (!_sessionListenerWired) {
      _sessionListenerWired = true;
      ref.listen<SilenceState>(silenceStateProvider, (previous, next) async {
        // Live calm counters handled centrally; nothing to reset here.
        if (next.success == true && previous?.success != true) {
          // Respect reduce motion preference
          final reduceMotion =
              MediaQuery.maybeOf(context)?.disableAnimations ?? false;
          if (!reduceMotion) {
            _confetti.play();
          }
          try {
            ref
                .read(accessibilityServiceProvider)
                .vibrateOnEvent(AccessibilityEvent.sessionComplete);
            ref
                .read(accessibilityServiceProvider)
                .announceSessionComplete(true);
          } catch (_) {}
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            ref.read(silenceStateProvider.notifier).setSuccess(null);
          }
        } else if (next.success == false && previous?.success != false) {
          try {
            ref
                .read(accessibilityServiceProvider)
                .vibrateOnEvent(AccessibilityEvent.sessionFailed);
            ref
                .read(accessibilityServiceProvider)
                .announceSessionComplete(false);
          } catch (_) {}
        }
      });
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(
                      0xFF8B9DC3,
                    ).withValues(alpha: 0.08), // Soft blue-gray
                    const Color(
                      0xFF86B489,
                    ).withValues(alpha: 0.04), // Sage green
                    theme.colorScheme.surface,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
          ),
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirection: math.pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
            ),
          ),

          // Main content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header - hide when Focus Mode is active
                if (!_focusModeActive)
                  _buildHeader(context, isTabletLandscape: isTabletLandscape),

                // Tab content - show side-by-side in tablet landscape
                Expanded(
                  child:
                      isTabletLandscape
                          ? _buildTabletLandscapeLayout(context)
                          : TabBarView(
                            controller: _tabController,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _buildSummaryTab(context),
                              _buildSessionsTab(context),
                            ],
                          ),
                ),

                // Bottom navigation bar - hide in tablet landscape and Focus Mode
                if (!isTabletLandscape && !_focusModeActive) _buildBottomNav(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {bool isTabletLandscape = false}) {
    final theme = Theme.of(context);
    final currentTheme = ref.watch(themeProvider);
    final horizontalPad = _getResponsivePadding(context, 12);
    final showSummaryHeader = _currentTab == 0 || isTabletLandscape;
    final userPrefs = ref.watch(userPreferencesProvider);

    final Widget headerContent;
    if (showSummaryHeader) {
      final questState = ref.watch(questStateProvider);
      final goalMinutes =
          questState?.goalQuietMinutes ?? userPrefs.globalDailyQuietGoalMinutes;
      final calmPercent = ((questState?.requiredScore ?? 0.7) * 100).round();
      final titleText =
          isTabletLandscape ? 'Your Focus Dashboard' : 'Focus minutes today';

      headerContent = KeyedSubtree(
        key: ValueKey('summary-${isTabletLandscape ? 'tablet' : 'phone'}'),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                titleText,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                'Goal: $goalMinutes min • Calm ≥$calmPercent%',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    } else {
      final enabledNames = userPrefs.enabledProfiles
          .map((id) => _capitalizeFirst(id))
          .join(' • ');
      headerContent = KeyedSubtree(
        key: const ValueKey('sessions-header'),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pick your mode',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                enabledNames.isEmpty
                    ? 'Study • Reading • Meditation'
                    : enabledNames,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }
    // Inline date label not shown in the current design; removed to reduce warnings

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Functional headline with subtitle
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: headerContent,
            ),
          ),
          // Actions: (Summary only) date chip, Tips, Theme, Settings
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.lightbulb_outline,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: () async {
                  final tipService = ref.read(tipServiceProvider);
                  await tipService.showCurrentTip(context);
                },
                tooltip: 'Tips',
              ),
              IconButton(
                icon: Icon(
                  currentTheme.icon,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: () => _toggleTheme(context),
                tooltip: 'Theme',
              ),
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  // Subtle haptic for accessibility
                  try {
                    ref
                        .read(accessibilityServiceProvider)
                        .vibrateOnEvent(AccessibilityEvent.buttonPress);
                  } catch (_) {}
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const SettingsSheet(),
                  );
                },
                tooltip: 'Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleTheme(BuildContext context) {
    // Debounce rapid taps to avoid cycling too fast and stacking snackbars
    final now = DateTime.now();
    if (_lastThemeToggleTime != null &&
        now.difference(_lastThemeToggleTime!) <
            const Duration(milliseconds: 350)) {
      return;
    }
    _lastThemeToggleTime = now;
    final themeNotifier = ref.read(themeProvider.notifier);
    final hasPremiumAccess = ref.read(premiumAccessProvider);
    final current = ref.read(themeProvider);
    // Subtle haptic feedback
    try {
      ref
          .read(accessibilityServiceProvider)
          .vibrateOnEvent(AccessibilityEvent.buttonPress);
    } catch (_) {}

    themeNotifier.cycleTheme(hasPremiumAccess: hasPremiumAccess);

    // Feedback: brief snackbar with next theme name
    final availableThemes =
        hasPremiumAccess
            ? AppThemeMode.values
            : [AppThemeMode.system, AppThemeMode.light, AppThemeMode.dark];
    final currentIndex = availableThemes.indexOf(current);
    final nextIndex =
        currentIndex >= 0 ? (currentIndex + 1) % availableThemes.length : 0;
    final nextTheme = availableThemes[nextIndex];
    // Avoid stacking snackbars
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Theme changed to ${nextTheme.displayName}'),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 90, left: 16, right: 16),
      ),
    );
  }

  Widget _buildSummaryTab(BuildContext context, {bool showAd = true}) {
    final horizontalPad = _getResponsivePadding(context, 12);
    final bottomPad = _getResponsivePadding(context, 100);
    final spacing = _getResponsivePadding(context, 8);

    return ListView(
      padding: EdgeInsets.fromLTRB(horizontalPad, 0, horizontalPad, bottomPad),
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(height: spacing),
        // Activity Progress - Adaptive circular rings with real data
        const AdaptiveActivityRingsWidget(),
        SizedBox(height: spacing),
        // Ambient Quest capsule (flag-gated); falls back to legacy card if disabled
        if (AmbientFlags.quests)
          _buildAmbientQuestCapsule(context)
        else
          _buildTodaysMissionCard(context),
        SizedBox(height: spacing),
        // 7-day stacked bars moved to Trends > Show More (Basic tab)
        _buildTrendsCard(context),
        SizedBox(height: spacing),
        if (showAd) _buildAdvertisementPlaceholder(context),
      ],
    );
  }

  Widget _buildSessionsTab(BuildContext context, {bool showAd = true}) {
    final horizontalPad = _getResponsivePadding(context, 12);
    final verticalPad = _getResponsivePadding(context, 8);
    final bottomPad = _getResponsivePadding(context, 100);
    final spacing = _getResponsivePadding(context, 8);

    final sessionContent = ListView(
      padding: EdgeInsets.fromLTRB(
        horizontalPad,
        verticalPad,
        horizontalPad,
        bottomPad,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        // Merged: Activity chips + Today progress in single card
        Builder(
          builder: (context) {
            final theme = Theme.of(context);
            final isDark = theme.brightness == Brightness.dark;
            final tintColor = theme.colorScheme.secondary; // Use theme secondary color
            final baseDecoration = context.cardDecoration;

            return Container(
              decoration: baseDecoration.copyWith(
                color: isDark
                    ? Color.alphaBlend(
                        tintColor.withValues(alpha: 0.18),
                        theme.colorScheme.surfaceContainerHighest,
                      )
                    : Color.alphaBlend(
                        tintColor.withValues(alpha: 0.12),
                        theme.colorScheme.surfaceContainerHighest,
                      ),
              ),
              child: Column(
            children: [
              _buildHorizontalActivityChips(context),
              const Divider(height: 1),
              Padding(
                padding: _getCardPadding(context),
                child: _buildDailyGoalCompactInner(context),
              ),
            ],
          ),
            );
          },
        ),

        // Adaptive threshold suggestion (shows after 3 wins)
        const AdaptiveThresholdChip(),

        SizedBox(height: spacing),
        _buildComplementaryPanel(context),
        SizedBox(height: spacing),
        _buildSessionControlCard(context),
        SizedBox(height: spacing),
        if (showAd) _buildAdvertisementPlaceholder(context),
      ],
    );

    // Show Focus Mode overlay if active
    if (_focusModeActive) {
      final silenceState = ref.watch(silenceStateProvider);
      final durationSeconds = ref.watch(activeSessionDurationProvider);

      return Stack(
        children: [
          sessionContent,
          FocusModeOverlay(
            progress: silenceState.progress,
            remainingSeconds: durationSeconds - (silenceState.progress * durationSeconds).toInt(),
            isPaused: silenceState.isPaused,
            onPause: () {
              // Toggle pause state
              ref.read(silenceStateProvider.notifier).togglePause();
            },
            onStop: () {
              setState(() => _focusModeActive = false);
              _stopSilenceDetection(context);
            },
            onExit: () {
              setState(() => _focusModeActive = false);
            },
          ),
        ],
      );
    }

    return sessionContent;
  }

  /// Tablet landscape layout: shows Today tab on left + Sessions tab on right
  Widget _buildTabletLandscapeLayout(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left panel: Today tab (no ad in landscape mode)
        Expanded(
          child: Column(
            children: [
              // Today tab header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Today',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Today tab content (with ad at bottom)
              Expanded(child: _buildSummaryTab(context, showAd: true)),
            ],
          ),
        ),

        // Vertical divider
        Container(width: 1, color: theme.colorScheme.outlineVariant),

        // Right panel: Sessions tab
        Expanded(
          child: Column(
            children: [
              // Sessions tab header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sessions',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Sessions tab content (no ad in landscape mode)
              Expanded(child: _buildSessionsTab(context, showAd: false)),
            ],
          ),
        ),
      ],
    );
  }

  // Inner content for Today's 0/1 min row; wrapper card is added by caller
  Widget _buildDailyGoalCompactInner(BuildContext context) {
    final theme = Theme.of(context);
    final activeProfile = ref.watch(activeProfileProvider);
    final questState = ref.watch(questStateProvider);
    final userPrefs = ref.watch(userPreferencesProvider);

    // P0: Show quest progress for the active profile
    final color = _getActivityColor(activeProfile.id);
    final iconData = _getActivityIcon(activeProfile.id);

    // Determine if we're in per-activity or global goal mode
    final isPerActivityMode = userPrefs.perActivityGoalsEnabled && userPrefs.perActivityGoals != null;

    // Get progress and goal based on mode
    final int done;
    final int goal;
    final String labelText;

    if (isPerActivityMode) {
      // Per-activity mode: show individual activity progress
      // Always show actual minutes tracked (even when freeze token used)
      final actualMinutes = _getCompletedMinutesForActivity(activeProfile.id, questState);
      final activityGoal = userPrefs.perActivityGoals![activeProfile.id] ?? userPrefs.globalDailyQuietGoalMinutes;
      done = actualMinutes; // Always show actual progress
      goal = activityGoal;
      labelText = '${_getActivityName(activeProfile.id)} Today $done/$goal min';
    } else {
      // Global mode: show total progress across all activities
      // If freeze token used, keep progress locked at goal value (100%)
      done = (questState?.freezeTokenUsedToday ?? false)
          ? (questState?.goalQuietMinutes ?? 0)
          : (questState?.progressQuietMinutes ?? 0);
      goal = userPrefs.globalDailyQuietGoalMinutes;
      labelText = 'Total Today $done/$goal min, choose any activity';
    }

    final ratio = goal == 0 ? 0.0 : (done / goal).clamp(0.0, 1.0);

    // subtle encouragement (visual glow previously used)

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Leading activity icon
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        // Title + X/Y + slim progress
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                labelText,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.6),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Percent chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withValues(alpha: 0.45)),
          ),
          child: Text(
            '${(ratio * 100).round()}%',
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  /// Ambient Quests: Display all 4 activity profiles in circular chips
  Widget _buildHorizontalActivityChips(BuildContext context) {
    final profiles = ref.watch(defaultProfilesProvider);
    final selectedId = ref.watch(selectedProfileIdProvider);
    final userPrefs = ref.watch(userPreferencesProvider);
    final theme = Theme.of(context);

    // Filter profiles to show only enabled ones
    final enabledProfiles =
        profiles
            .where((profile) => userPrefs.enabledProfiles.contains(profile.id))
            .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            enabledProfiles.map((profile) {
              final isSelected = profile.id == selectedId;
              final color = _getActivityColor(profile.id);
              final icon = _getActivityIcon(profile.id);

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap:
                        () => ref
                            .read(selectedProfileIdProvider.notifier)
                            .setProfile(profile.id),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? color.withValues(alpha: 0.15)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            isSelected
                                ? Border.all(color: color, width: 2)
                                : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Circular icon container
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: Colors.white, size: 28),
                          ),
                          const SizedBox(height: 6),
                          // Label
                          Text(
                            profile.name,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                              color:
                                  isSelected
                                      ? color
                                      : theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  // Legacy activity add button and dialogs removed (P0 scope: 4 fixed activity profiles)

  Widget _buildActivityChipHorizontal(
    BuildContext context,
    IconData icon,
    String label,
    bool isSelected,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom version that accepts a Widget for icon/emoji support
  Widget _buildActivityChipHorizontalCustom(
    BuildContext context,
    Widget iconWidget,
    String label,
    bool isSelected,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Center(child: iconWidget),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _buildActivitySuggestion replaced by _buildComplementaryPanel

  Widget _buildComplementaryPanel(BuildContext context) {
    final theme = Theme.of(context);
    final activeProfile = ref.watch(activeProfileProvider);
    final threshold = ref.watch(decibelThresholdProvider);
    final silenceState = ref.watch(silenceStateProvider);

    if (activeProfile.usesNoise) {
      // InlineNoisePanel has its own container styling
      return InlineNoisePanel(
        threshold: threshold,
        isListening: silenceState.isListening,
      );
    }

    // Non-silence activity: provide a compact helper card
    return Container(
      padding: _getCardPadding(context),
      decoration: context.cardDecoration,
      child: Row(
        children: [
          Icon(Icons.track_changes, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Set your duration and track your time. Session history and analytics will appear in Summary.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRingSkeleton(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatRingRow(
          context,
          Icons.stars,
          'Points',
          '—/—',
          '',
          0.0,
          const Color(0xFF5B9BD5), // Blue - colorblind safe
        ),
        const SizedBox(height: 8),
        _buildStatRingRow(
          context,
          Icons.local_fire_department,
          'Streak',
          '—/—',
          'DAYS',
          0.0,
          const Color(0xFFFF9500), // Orange - distinguishable for colorblind
        ),
        const SizedBox(height: 8),
        _buildStatRingRow(
          context,
          Icons.play_circle_outline,
          'Sessions',
          '—/—',
          '',
          0.0,
          const Color(0xFF34C759), // Green - colorblind safe
        ),
      ],
    );
  }

  String _titleCase(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  String _capitalizeFirst(String s) => _titleCase(s);

  // Compact stat row: circular indicator with icon + text to the right
  Widget _buildStatRingRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    String unit,
    double progress,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 4,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color.withValues(alpha: 0.15),
                  ),
                ),
              ),
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    value,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  if (unit.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityRow(
    BuildContext context,
    IconData icon,
    String label,
    double progress,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              LayoutBuilder(
                builder: (context, c) {
                  const barHeight = 10.0;
                  const radius = Radius.circular(5);
                  final completedWidth = (c.maxWidth * progress).clamp(
                    0.0,
                    c.maxWidth,
                  );
                  return SizedBox(
                    height: barHeight,
                    child: Stack(
                      children: [
                        // Full remaining track
                        Container(
                          width: c.maxWidth,
                          decoration: BoxDecoration(
                            color: Color.alphaBlend(
                              Colors.black.withValues(alpha: 0.45),
                              theme.colorScheme.surfaceContainerHighest,
                            ),
                            borderRadius: const BorderRadius.all(radius),
                          ),
                        ),
                        // Completed portion
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          width: completedWidth,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.all(radius),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactActivityRow(
    ThemeData theme,
    Map<String, dynamic> activity,
  ) {
    final completed = activity['completed'] as int;
    final target = activity['target'] as int;
    final progress = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;
    final color = activity['color'] as Color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(
              activity['icon'] as IconData,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity['label'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${completed}m',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: color.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Larger activity row for Activity Progress widget (3 activities visible)
  Widget _buildLargerActivityRow(
    ThemeData theme,
    Map<String, dynamic> activity,
  ) {
    final completed = activity['completed'] as int;
    final target = activity['target'] as int;
    final progress = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;
    final color = activity['color'] as Color;
    final icon = activity['icon'] as IconData?;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon ?? Icons.error, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity['label'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${completed}m',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: color.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PROPOSED 3: Circular Ring Icons in Grid
  Widget _buildCircularRingActivityWidget(BuildContext context) {
    final theme = Theme.of(context);
    final activities = _getActivitiesData();

    int totalCompleted = 0;
    int totalTarget = 0;
    for (var activity in activities) {
      totalCompleted += activity['completed'] as int;
      totalTarget += activity['target'] as int;
    }
    final totalHours = (totalCompleted / 60.0);
    final targetHours = (totalTarget / 60.0);

    return Container(
      padding: _getCardPadding(context),
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Ring Progress',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${totalHours % 1 == 0 ? totalHours.toInt() : totalHours.toStringAsFixed(1)}h/${targetHours.toInt()}h)',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 4x2 Grid of circular progress rings with colored icons
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                activities.map((activity) {
                  final completed = activity['completed'] as int;
                  final target = activity['target'] as int;
                  final progress =
                      target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;
                  final color = activity['color'] as Color;

                  return SizedBox(
                    width: 70,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 56,
                                height: 56,
                                child: CircularProgressIndicator(
                                  value: 1.0,
                                  strokeWidth: 5,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    color.withValues(alpha: 0.2),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 56,
                                height: 56,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 5,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    color,
                                  ),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  activity['icon'] as IconData,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          activity['label'] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  // PROPOSED 4: Stacked Bars with Vertical Scroll
  Widget _buildSingleRingActivityWidget(BuildContext context) {
    final theme = Theme.of(context);
    final activities = _getActivitiesData();

    int totalCompleted = 0;
    int totalTarget = 0;
    for (var activity in activities) {
      totalCompleted += activity['completed'] as int;
      totalTarget += activity['target'] as int;
    }
    final totalHours = (totalCompleted / 60.0);
    final targetHours = (totalTarget / 60.0);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Stacked Bars',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${totalHours % 1 == 0 ? totalHours.toInt() : totalHours.toStringAsFixed(1)}h/${targetHours.toInt()}h)',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Scrollable bars showing 4 at a time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scroll indicators on left
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  (activities.length / 4).ceil(),
                  (index) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color:
                          index == 0
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(
                                alpha: 0.3,
                              ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Scrollable list
              Expanded(
                child: SizedBox(
                  height: 160,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      final completed = activity['completed'] as int;
                      final target = activity['target'] as int;
                      final progress =
                          target > 0
                              ? (completed / target).clamp(0.0, 1.0)
                              : 0.0;
                      final color = activity['color'] as Color;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                activity['icon'] as IconData,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        activity['label'] as String,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                      ),
                                      Text(
                                        '${completed}m / ${target}m',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color:
                                                  theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                              fontSize: 10,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: progress,
                                        child: Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PROPOSED 1-3: Activity Progress with 3 activities + overall circle
  // Legacy activity widget removed (P0: using Quest Capsule)
  Widget _buildProposedActivityWidget3(BuildContext context) {
    final theme = Theme.of(context);

    // Show only enabled quest profiles with per-activity progress
    final profiles = ref.watch(defaultProfilesProvider);
    final prefs = ref.watch(userPreferencesProvider);
    final questState = ref.watch(questStateProvider);

    final goalMinutes = prefs.globalDailyQuietGoalMinutes;

    // Filter profiles based on user preferences
    final enabledProfiles =
        profiles.where((profile) {
          return prefs.enabledProfiles.contains(profile.id);
        }).toList();

    // Build activity list from enabled profiles with per-activity data
    final activities =
        enabledProfiles.map((profile) {
          final icon = _getActivityIcon(profile.id);
          final color = _getActivityColor(profile.id);

          // Get per-activity minutes based on profile ID
          int completedMinutes = 0;
          if (questState != null) {
            switch (profile.id) {
              case 'study':
                completedMinutes = questState.studyMinutes;
                break;
              case 'reading':
                completedMinutes = questState.readingMinutes;
                break;
              case 'meditation':
                completedMinutes = questState.meditationMinutes;
                break;
            }
          }

          return {
            'icon': icon,
            'label': _titleCase(profile.name),
            'completed': completedMinutes,
            'target': goalMinutes,
            'color': color,
          };
        }).toList();

    // Calculate overall progress from quest state (sum of all activities)
    final totalMinutes = questState?.progressQuietMinutes ?? 0;
    final overallProgress =
        goalMinutes > 0 ? (totalMinutes / goalMinutes).clamp(0.0, 1.0) : 0.0;
    final percentageText = '${(overallProgress * 100).toInt()}%';

    final displayActivities = activities;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Session Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const ActivityEditSheet(),
                  );
                },
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Scroll indicators - left center
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  (displayActivities.length / 3).ceil().clamp(1, 10),
                  (index) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color:
                          index == 0
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(
                                alpha: 0.3,
                              ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Vertical carousel with activities - larger icons
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 180,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: displayActivities.length,
                    itemBuilder: (context, index) {
                      return _buildLargerActivityRow(
                        theme,
                        displayActivities[index],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Overall progress circle - showing percentage
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 10,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: CircularProgressIndicator(
                        value: overallProgress,
                        strokeWidth: 10,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          percentageText,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          'Overall',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // NEW: Activity Rings Widget - Circular progress rings (1-4 activities)
  // Test version with adaptive layouts based on enabled activities count
  Widget _buildActivityRingsWidgetTest(BuildContext context) {
    final theme = Theme.of(context);

    // Show only enabled quest profiles with per-activity progress
    final profiles = ref.watch(defaultProfilesProvider);
    final prefs = ref.watch(userPreferencesProvider);
    final questState = ref.watch(questStateProvider);

    final goalMinutes = prefs.globalDailyQuietGoalMinutes;

    // Filter profiles based on user preferences (includes "other" now)
    final enabledProfiles =
        profiles.where((profile) {
          return prefs.enabledProfiles.contains(profile.id);
        }).toList();

    // Build activity list from enabled profiles with per-activity data
    final activities =
        enabledProfiles.map((profile) {
          final icon = _getActivityIcon(profile.id);
          final color = _getActivityColor(profile.id);

          // Get per-activity minutes based on profile ID
          int completedMinutes = 0;
          if (questState != null) {
            switch (profile.id) {
              case 'study':
                completedMinutes = questState.studyMinutes;
                break;
              case 'reading':
                completedMinutes = questState.readingMinutes;
                break;
              case 'meditation':
                completedMinutes = questState.meditationMinutes;
                break;
              case 'other':
                completedMinutes = questState.otherMinutes;
                break;
            }
          }

          return {
            'icon': icon,
            'label': _titleCase(profile.name),
            'completed': completedMinutes,
            'target': goalMinutes,
            'color': color,
          };
        }).toList();

    // Calculate overall progress from quest state (sum of all activities)
    final totalMinutes = questState?.progressQuietMinutes ?? 0;
    final overallProgress =
        goalMinutes > 0 ? (totalMinutes / goalMinutes).clamp(0.0, 1.0) : 0.0;
    final percentageText = '${(overallProgress * 100).toInt()}%';

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and edit button
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ring Progress (${goalMinutes}min/${goalMinutes}min)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const ActivityEditSheet(),
                    );
                  },
                  icon: const Icon(Icons.tune, size: 16),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Activity rings widget
          ActivityRingsWidget(
            activities: activities,
            overallProgress: overallProgress,
            overallPercentageText: percentageText,
            goalMinutes: goalMinutes,
          ),
        ],
      ),
    );
  }

  // PROPOSED 1-5: Activity Progress with 5 activities + overall circle
  Widget _buildProposedActivityWidget5(BuildContext context) {
    final theme = Theme.of(context);
    final activities = _getActivitiesData().take(5).toList();

    int totalCompleted = 0;
    int totalTarget = 0;
    for (var activity in activities) {
      totalCompleted += activity['completed'] as int;
      totalTarget += activity['target'] as int;
    }
    final totalHours = (totalCompleted / 60.0);
    final targetHours = (totalTarget / 60.0);
    final overallProgress =
        totalTarget > 0 ? (totalCompleted / totalTarget).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Session Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scroll indicators
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  (activities.length / 4).ceil().clamp(1, 10),
                  (index) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color:
                          index == 0
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(
                                alpha: 0.3,
                              ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Vertical carousel with activities
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 120,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return _buildCompactActivityRow(theme, activities[index]);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Overall progress circle
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 8,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: overallProgress,
                        strokeWidth: 8,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${totalHours % 1 == 0 ? totalHours.toInt() : totalHours.toStringAsFixed(1)}h',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${targetHours.toInt()}h',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PROPOSED 4-3: Stacked Bars with 3 activities + progress circle
  Widget _buildSingleRingActivityWidget3(BuildContext context) {
    final theme = Theme.of(context);
    final activities = _getActivitiesData().take(3).toList();

    int totalCompleted = 0;
    int totalTarget = 0;
    for (var activity in activities) {
      totalCompleted += activity['completed'] as int;
      totalTarget += activity['target'] as int;
    }
    final totalHours = (totalCompleted / 60.0);
    final targetHours = (totalTarget / 60.0);
    final overallProgress =
        totalTarget > 0 ? (totalCompleted / totalTarget).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Stacked Bars',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${totalHours % 1 == 0 ? totalHours.toInt() : totalHours.toStringAsFixed(1)}h/${targetHours.toInt()}h)',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(3 activities)',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Activity bars
              Expanded(
                flex: 3,
                child: Column(
                  children:
                      activities.map((activity) {
                        final completed = activity['completed'] as int;
                        final target = activity['target'] as int;
                        final progress =
                            target > 0
                                ? (completed / target).clamp(0.0, 1.0)
                                : 0.0;
                        final color = activity['color'] as Color;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  activity['icon'] as IconData,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          activity['label'] as String,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11,
                                              ),
                                        ),
                                        Text(
                                          '${completed}m / ${target}m',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color:
                                                    theme
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                fontSize: 10,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Stack(
                                      children: [
                                        Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: color.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: progress,
                                          child: Container(
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(width: 12),
              // Overall progress circle
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 7,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: overallProgress,
                        strokeWidth: 7,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(overallProgress * 100).toInt()}%',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Overall',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PROPOSED 4-5: Stacked Bars with 5 activities + progress arc
  Widget _buildSingleRingActivityWidget5(BuildContext context) {
    final theme = Theme.of(context);
    final activities = _getActivitiesData().take(5).toList();

    int totalCompleted = 0;
    int totalTarget = 0;
    for (var activity in activities) {
      totalCompleted += activity['completed'] as int;
      totalTarget += activity['target'] as int;
    }
    final totalHours = (totalCompleted / 60.0);
    final targetHours = (totalTarget / 60.0);
    final overallProgress =
        totalTarget > 0 ? (totalCompleted / totalTarget).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Stacked Bars',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${totalHours % 1 == 0 ? totalHours.toInt() : totalHours.toStringAsFixed(1)}h/${targetHours.toInt()}h)',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(5 activities)',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              // All 5 activities
              ...activities.map((activity) {
                final completed = activity['completed'] as int;
                final target = activity['target'] as int;
                final progress =
                    target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;
                final color = activity['color'] as Color;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          activity['icon'] as IconData,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  activity['label'] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '${completed}m / ${target}m',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Stack(
                              children: [
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: progress,
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 6),
              // Overall progress bar at bottom
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              value: overallProgress,
                              strokeWidth: 4,
                              backgroundColor: theme.colorScheme.primary
                                  .withValues(alpha: 0.15),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Text(
                            '${(overallProgress * 100).toInt()}%',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overall Progress',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${totalCompleted}m / ${totalTarget}m completed',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getActivitiesData() {
    return [
      {
        'icon': Icons.school_outlined,
        'label': 'Study',
        'completed': 30,
        'target': 60,
        'color': const Color(0xFF7F6BB0),
      },
      {
        'icon': Icons.menu_book_outlined,
        'label': 'Reading',
        'completed': 45,
        'target': 60,
        'color': const Color(0xFF5B9BD5),
      },
      {
        'icon': Icons.self_improvement_outlined,
        'label': 'Meditation',
        'completed': 20,
        'target': 20,
        'color': const Color(0xFF70AD47),
      },
      {
        'icon': Icons.fitness_center_outlined,
        'label': 'Gym',
        'completed': 15,
        'target': 30,
        'color': const Color(0xFFFA114F),
      },
      {
        'icon': Icons.work_outline,
        'label': 'Work',
        'completed': 120,
        'target': 180,
        'color': const Color(0xFFED7D31),
      },
      {
        'icon': Icons.directions_run,
        'label': 'Running',
        'completed': 0,
        'target': 30,
        'color': const Color(0xFF9B59B6),
      },
      {
        'icon': Icons.people_outline,
        'label': 'Family',
        'completed': 60,
        'target': 60,
        'color': const Color(0xFFFFC000),
      },
      {
        'icon': Icons.volume_off_outlined,
        'label': 'Focus',
        'completed': 10,
        'target': 30,
        'color': const Color(0xFF00D9FF),
      },
    ];
  }

  Widget _buildHorizontalStatsWidget(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Inverse background: brighter in dark mode, darker in light mode
    final backgroundColor =
        isDark
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.9)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCompactStatItem(
            context,
            Icons.stars,
            'Focus',
            '1/100 MIN',
            0.01,
            const Color(0xFF5B9BD5), // Blue - colorblind safe
          ),
          _buildCompactStatItem(
            context,
            Icons.local_fire_department,
            'Streak',
            '1/7 DAYS',
            0.14,
            const Color(0xFFFF9500), // Orange - distinguishable for colorblind
          ),
          _buildCompactStatItem(
            context,
            Icons.play_circle_outline,
            'Sessions',
            '2/20',
            0.1,
            const Color(0xFF34C759), // Green - colorblind safe
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    double progress,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Smaller circular ring
        SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background ring
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 4,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color.withValues(alpha: 0.15),
                  ),
                ),
              ),
              // Progress ring
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Icon - increased size to almost touch edges
              Icon(icon, color: color, size: 26),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Title and value to the right
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdvertisementPlaceholder(BuildContext context) {
    // Don't show ads for premium users
    final hasPremiumAccess = ref.read(premiumAccessProvider);
    if (hasPremiumAccess) {
      return const SizedBox.shrink();
    }

    // Show real Google Mobile Ads banner for free users
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: FooterBannerAd(),
    );
  }

  Widget _buildRingLegend(
    BuildContext context,
    String label,
    String value,
    Color color,
    double progress,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysMissionCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5B6B7C), Color(0xFF4A5A6A)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.rocket_launch,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Goals',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Complete 15 min of Focus',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => _tabController.animateTo(1),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Start',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Ultra-minimal quest capsule: just progress bar, numbers, streak, and freeze token (if relevant)
  Widget _buildAmbientQuestCapsule(BuildContext context) {
    return QuestCapsule(
      onNavigateToActivity: () => _tabController.animateTo(1),
    );
  }

  Widget _buildQuickStatsCard(BuildContext context) {
    final silenceDataAsync = ref.watch(silenceDataNotifierProvider);

    return silenceDataAsync.when(
      data: (data) {
        return Row(
          children: [
            Expanded(
              child: _buildStatTile(
                context,
                'Points',
                data.totalPoints.toString(),
                Icons.star_rounded,
                Colors.amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatTile(
                context,
                'Streak',
                '${data.currentStreak}',
                Icons.local_fire_department_rounded,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatTile(
                context,
                'Sessions',
                '${data.totalSessions}',
                Icons.timelapse_rounded,
                Colors.blue,
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatTile(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsCard(BuildContext context) {
    final theme = Theme.of(context);
    final silenceDataAsync = ref.watch(silenceDataNotifierProvider);

    return silenceDataAsync.when(
      data: (data) {
        if (data.recentSessions.isEmpty) {
          // Show empty state with motivating placeholder and tertiary color tint
          final isDark = theme.brightness == Brightness.dark;
          final tintColor = theme.colorScheme.tertiary; // Use theme tertiary color
          final baseDecoration = context.cardDecoration;

          return Container(
            padding: _getCardPadding(context),
            decoration: baseDecoration.copyWith(
              color: isDark
                  ? Color.alphaBlend(
                      tintColor.withValues(alpha: 0.18), // Brighter for optimistic feel
                      theme.colorScheme.surfaceContainerHighest,
                    )
                  : Color.alphaBlend(
                      tintColor.withValues(alpha: 0.12), // Brighter for optimistic feel
                      theme.colorScheme.surfaceContainerHighest,
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Insights',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.insights,
                      size: 20,
                      color: tintColor, // Vibrant color to match card tint
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 48,
                        color: tintColor.withValues(alpha: 0.6), // Vibrant color
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Complete your first session',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Start tracking your focus time, session patterns,\nand ambient score trends',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }

        final now = DateTime.now();
        final sevenDaysAgo = now.subtract(const Duration(days: 7));

        final sessionsLast7Days =
            data.recentSessions
                .where((s) => s.date.isAfter(sevenDaysAgo))
                .toList();

        final quietSessionsLast7Days =
            sessionsLast7Days.where((s) => s.ambientScore != null).toList();

        final totalAmbientScore = quietSessionsLast7Days.fold<double>(
          0,
          (prev, s) => prev + s.ambientScore!,
        );
        final avgAmbientScore =
            quietSessionsLast7Days.isNotEmpty
                ? (totalAmbientScore / quietSessionsLast7Days.length) * 100
                : 0;

        final totalDurationLast7DaysInSeconds = sessionsLast7Days.fold<int>(
          0,
          (prev, s) => prev + s.duration,
        );

        // Calculate actual active days (days with at least one session)
        final activeDays = sessionsLast7Days
            .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
            .toSet()
            .length;

        // Use actual active days for more accurate and encouraging average
        // Minimum of 1 day to avoid division by zero
        final daysToAverage = activeDays > 0 ? activeDays : 1;
        final avgDailyFocusTimeInMinutes =
            (totalDurationLast7DaysInSeconds / daysToAverage) / 60;

        final sessionsPerWeek = sessionsLast7Days.length;

        final totalRecentDurationInSeconds = data.recentSessions.fold<int>(
          0,
          (prev, s) => prev + s.duration,
        );
        final avgSessionDurationInMinutes =
            data.recentSessions.isNotEmpty
                ? (totalRecentDurationInSeconds / data.recentSessions.length) /
                    60
                : 0;

        // Dummy trend direction for now
        final focusTimeTrendUp = avgDailyFocusTimeInMinutes > 15;
        final sessionsTrendUp = sessionsPerWeek > 3;
        final avgDurationTrendUp = avgSessionDurationInMinutes > 5;
        final ambientScoreTrendUp = avgAmbientScore > 75;

        // Insights card with tertiary color tint for visual personality
        final isDark = theme.brightness == Brightness.dark;
        final tintColor = theme.colorScheme.tertiary; // Use theme tertiary color
        final baseDecoration = context.cardDecoration;

        return Container(
          padding: _getCardPadding(context),
          decoration: baseDecoration.copyWith(
            color: isDark
                ? Color.alphaBlend(
                    tintColor.withValues(alpha: 0.18), // Brighter for optimistic feel
                    theme.colorScheme.surfaceContainerHighest,
                  )
                : Color.alphaBlend(
                    tintColor.withValues(alpha: 0.12), // Brighter for optimistic feel
                    theme.colorScheme.surfaceContainerHighest,
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Insights',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          size: 20,
                          color: theme.colorScheme.secondary, // Vibrant cyan
                        ),
                        tooltip: 'Share your progress',
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        onPressed: () => _showShareOptions(context, ref, data),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.show_chart,
                          size: 20,
                          color: tintColor, // Vibrant color to match card
                        ),
                        tooltip: 'View detailed insights',
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const TrendsSheet(),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildTrendItem(
                context,
                'Focus Time',
                // Show at least 1 min if there's any activity (be encouraging!)
                '${avgDailyFocusTimeInMinutes >= 0.5 ? avgDailyFocusTimeInMinutes.round() : (sessionsLast7Days.isNotEmpty ? 1 : 0)} min/day',
                focusTimeTrendUp,
                const Color(0xFFB0FC38),
              ),
              const SizedBox(height: 8),
              _buildTrendItem(
                context,
                'Sessions',
                '$sessionsPerWeek/week',
                sessionsTrendUp,
                const Color(0xFF00D9FF),
              ),
              const SizedBox(height: 8),
              _buildTrendItem(
                context,
                'Average',
                // Show at least 1 min if there are any sessions (be encouraging!)
                '${avgSessionDurationInMinutes >= 0.5 ? avgSessionDurationInMinutes.round() : (data.recentSessions.isNotEmpty ? 1 : 0)} min',
                avgDurationTrendUp,
                const Color(0xFFFA114F),
              ),
              const SizedBox(height: 8),
              _buildTrendItem(
                context,
                'Ambient Score',
                // Show at least 1% if there's any quiet session data (be encouraging!)
                '${avgAmbientScore >= 0.5 ? avgAmbientScore.round() : (quietSessionsLast7Days.isNotEmpty ? 1 : 0)}%/week',
                ambientScoreTrendUp,
                Colors.purple.shade300,
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  // Local helper to render a compact trend row used in the Summary > Trends card
  Widget _buildTrendItem(
    BuildContext context,
    String label,
    String value,
    bool isUp,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          isUp ? Icons.trending_up : Icons.trending_down,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // Simple Trends page moved to a bottom sheet (TrendsSheet). This block retained for context comments only.
  // TrendsPage moved to bottom as a top-level widget

  IconData _getActivityIcon(String activityKey) {
    switch (activityKey.toLowerCase()) {
      case 'work':
        return Icons.work_outline;
      case 'study':
      case 'studying':
        return Icons.school_outlined;
      case 'reading':
        return Icons.menu_book_outlined;
      case 'meditation':
        return Icons.self_improvement_outlined;
      case 'other':
        return Icons.star_outline;
      case 'fitness':
        return Icons.fitness_center_outlined;
      case 'family':
        return Icons.people_outline;
      case 'noise':
        return Icons.volume_off_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  Color _getActivityColor(String activityKey) {
    switch (activityKey.toLowerCase()) {
      case 'work':
        return const Color(0xFFEF5350); // Material Red 400 - Bright, bold
      case 'study':
      case 'studying':
        return const Color(0xFF2196F3); // Material Blue 500 - Bright, energetic
      case 'reading':
        return const Color(0xFF9C27B0); // Material Purple 500 - Rich, deep
      case 'meditation':
        return const Color(0xFF4CAF50); // Material Green 500 - Fresh, vibrant
      case 'other':
        return const Color(0xFFFF9800); // Material Orange 500 - Warm, bold
      case 'fitness':
        return const Color(0xFFFA114F); // Material Pink-Red - Energetic
      case 'family':
        return const Color(0xFF9B59B6); // Material Purple - Warm, inviting
      case 'noise':
        return const Color(0xFF00BCD4); // Material Cyan 500 - Bright, clear
      default:
        return const Color(0xFF2196F3); // Material Blue 500 - Default vibrant
    }
  }

  /// Get completed minutes for a specific activity profile
  int _getCompletedMinutesForActivity(String profileId, QuestState? questState) {
    if (questState == null) return 0;

    switch (profileId) {
      case 'study':
        return questState.studyMinutes;
      case 'reading':
        return questState.readingMinutes;
      case 'meditation':
        return questState.meditationMinutes;
      case 'other':
        return questState.otherMinutes;
      default:
        return 0;
    }
  }

  /// Get display name for activity profile
  String _getActivityName(String profileId) {
    switch (profileId) {
      case 'study':
        return 'Study';
      case 'reading':
        return 'Reading';
      case 'meditation':
        return 'Meditation';
      case 'other':
        return 'Other';
      default:
        return 'Activity';
    }
  }

  Widget _buildSessionControlCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final silenceState = ref.watch(silenceStateProvider);
    final durationSeconds = ref.watch(activeSessionDurationProvider);
    // Ambient score subtitle shown for quiet-required activities when enabled
    String? ambientSubtitle;
    double? calmPercent;
    if (AmbientFlags.ambientScore) {
      final activeProfile = ref.watch(activeProfileProvider);
      if (activeProfile.usesNoise) {
        final liveCalm = ref.watch(liveCalmPercentProvider);
        if (silenceState.isListening && (liveCalm != null)) {
          ambientSubtitle = l10n.calmPercent(liveCalm.round());
          calmPercent = liveCalm; // Pass to progress ring for top-right display
        } else {
          ambientSubtitle = l10n.calmLabel;
        }
      }
    }
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.height < 720;
    // Responsive ring size: adjusts for phones/tablets automatically
    final baseRingSize = context.progressRingSize;
    final ringSize = isCompact ? baseRingSize * 0.9 : baseRingSize;

    // Check if Focus Mode is enabled
    final userPrefs = ref.watch(userPreferencesProvider);
    final showFocusMode = userPrefs.focusModeEnabled;

    return Container(
      padding: _getCardPadding(context),
      decoration: context.cardDecoration,
      child: Column(
        children: [
          // Top row: Duration selector (when NOT listening) OR Control buttons (when listening)
          if (!silenceState.isListening)
            // Duration selector chips
            SizedBox(
              height: 34,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(width: 6),
                  for (final m in const [1, 5, 10, 30])
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: _buildDurationChip(
                        context,
                        m,
                        _selectedDurationMinutes == m,
                      ),
                    ),
                  for (final m in const [60, 90, 120, 240])
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: _buildDurationChipPremium(
                        context,
                        m,
                        _selectedDurationMinutes == m,
                      ),
                    ),
                  const SizedBox(width: 6),
                ],
              ),
            )
          else
            // Control buttons row (when session is running)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  // Left side: Focus Mode, Pause, Stop buttons
                  // Show Focus Mode button when it's DISABLED in settings (so user can manually activate)
                  if (!showFocusMode)
                    _buildTopButton(
                      context,
                      label: 'Focus Mode',
                      onTap: () => setState(() => _focusModeActive = true),
                      backgroundColor: theme.colorScheme.primaryContainer,
                      textColor: theme.colorScheme.onPrimaryContainer,
                    ),
                  if (!showFocusMode) const SizedBox(width: 6),
                  _buildTopButton(
                    context,
                    label: silenceState.isPaused ? 'Resume' : 'Pause',
                    icon: silenceState.isPaused ? Icons.play_arrow : Icons.pause,
                    onLongPress: () => ref.read(silenceStateProvider.notifier).togglePause(),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    textColor: theme.colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 6),
                  _buildTopButton(
                    context,
                    label: 'Stop',
                    icon: Icons.stop,
                    onLongPress: () => _stopSilenceDetection(context),
                    backgroundColor: theme.colorScheme.errorContainer,
                    textColor: theme.colorScheme.onErrorContainer,
                  ),
                  const Spacer(),
                  // Right side: Ambient % (plain text, no background)
                  if (calmPercent != null)
                    Text(
                      'Ambient: ${calmPercent!.round()}%',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          // Big glowing progress ring with time and start
          _GlowingProgressRing(
            size: ringSize,
            progress: silenceState.progress,
            isListening: silenceState.isListening,
            timeLabel: _formatTimeForSeconds(durationSeconds),
            // Never show subtitle (user requested no "Calm" text)
            subtitleText: null,
            onStart: () {
              if (silenceState.isListening) {
                _stopSilenceDetection(context);
              } else {
                _startSilenceDetection(context);
                // Auto-activate Focus Mode if enabled in settings
                if (showFocusMode) {
                  setState(() => _focusModeActive = true);
                }
              }
            },
          ),
          const SizedBox(height: 6),
          // Status message below ring
          SizedBox(
            height: 18,
            child: Center(child: _buildStatusMessage(context, silenceState)),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusModeButton(BuildContext context) {
    final userPrefs = ref.watch(userPreferencesProvider);
    final theme = Theme.of(context);

    // Only show if Focus Mode is enabled in preferences
    if (!userPrefs.focusModeEnabled) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextButton.icon(
        onPressed: () {
          setState(() => _focusModeActive = true);
        },
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        icon: const Icon(Icons.bedtime_outlined, size: 18),
        label: const Text(
          'Focus Mode',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildDurationChip(
    BuildContext context,
    int minutes,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () {
        setState(() => _selectedDurationMinutes = minutes);
        // propagate to active session duration provider (in seconds)
        ref.read(activeSessionDurationProvider.notifier).state = minutes * 60;
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        '${minutes}m',
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildDurationChipPremium(
    BuildContext context,
    int minutes,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    String label;
    if (minutes == 60) {
      label = '1hr';
    } else if (minutes == 90) {
      label = '1.5hr';
    } else if (minutes == 120) {
      label = '2hr';
    } else {
      label = '4hr';
    }

    return TextButton.icon(
      onPressed: () {
        setState(() => _selectedDurationMinutes = minutes);
        ref.read(activeSessionDurationProvider.notifier).state = minutes * 60;
      },
      icon: Icon(
        Icons.star,
        size: 14,
        color: isSelected ? theme.colorScheme.primary : Colors.amber,
      ),
      label: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  String _formatTimeForSeconds(int seconds) {
    if (seconds >= 3600) {
      final h = seconds ~/ 3600;
      final m = (seconds % 3600) ~/ 60;
      return '$h:${m.toString().padLeft(2, '0')}:00';
    }
    final m = (seconds ~/ 60).clamp(0, 59);
    return '${m.toString().padLeft(2, '0')}:00';
  }

  /// Helper to build top control buttons (Focus Mode, Pause, Stop)
  Widget _buildTopButton(
    BuildContext context, {
    required String label,
    IconData? icon,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    required Color backgroundColor,
    required Color textColor,
  }) {
    final button = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4), // Rectangular buttons with slight rounding
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onLongPress != null) {
      return GestureDetector(
        onLongPress: onLongPress,
        child: button,
      );
    } else if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: button,
      );
    }
    return button;
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    if (silenceState.success == true) {
      return Text(
        'Success',
        style: theme.textTheme.bodySmall?.copyWith(
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
        'Failed',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _startSilenceDetection(BuildContext context) async {
    final silenceStateNotifier = ref.read(silenceStateProvider.notifier);
    final silenceDataNotifier = ref.read(silenceDataNotifierProvider.notifier);
    final silenceDetector = ref.read(silenceDetectorProvider);
    final sessionDuration = ref.read(sessionDurationProvider);
    final accessibilityService = ref.read(accessibilityServiceProvider);
    final notificationService = ref.read(notificationServiceProvider);
    final startTime = DateTime.now();
    // Ambient Quests: start engine and set up 1Hz ticks
    final activeProfile = ref.read(activeProfileProvider);
    final usesNoise = activeProfile.usesNoise;
    final plannedSeconds = sessionDuration;
    try {
      await ref
          .read(ambientSessionEngineProvider.notifier)
          .start(plannedSeconds: plannedSeconds, usesNoise: usesNoise);
    } catch (_) {}

    // Compact Today’s Focus card — Title + Body (icon, message+status, CTA) + Progress
    await notificationService.recordSessionTime(startTime);

    // Reset readings
    silenceDetector.clearReadings();

    // Initialize state
    silenceStateNotifier.setListening(true);
    silenceStateNotifier.setProgress(0.0);
    silenceStateNotifier.setSuccess(null);
    silenceStateNotifier.setError(null);
    silenceStateNotifier.setCanStop(true);

    // Accessibility feedback
    accessibilityService.vibrateOnEvent(AccessibilityEvent.sessionStart);
    accessibilityService.announceSessionStart((sessionDuration / 60).round());

    // Show ongoing notification right before starting listening
    try {
      await ref
          .read(notificationServiceProvider)
          .showOngoingSession(
            title: 'Deep Focus',
            body: 'Stay focused. Leaving the app may end the session.',
            progress: 0,
          );
    } catch (_) {}

    // Start 1Hz ambient ticks using RealTimeNoiseController
    try {
      _ambientTickSub?.cancel();
      final noiseController = ref.read(realTimeNoiseControllerProvider);
      _ambientTickSub = noiseController.stream.listen((db) {
        try {
          // Only tick if not paused
          final currentState = ref.read(silenceStateProvider);
          if (!currentState.isPaused) {
            final threshold = ref.read(decibelThresholdProvider).round();
            ref
                .read(ambientSessionEngineProvider.notifier)
                .tick(
                  usesNoise: usesNoise,
                  currentDb: db,
                  thresholdDb: threshold,
                  deltaSeconds: 1,
                );
          }
        } catch (_) {}
      });
    } catch (_) {}

    await silenceDetector.startListening(
      onProgress: (progress) {
        // Only update progress if not paused
        final currentState = ref.read(silenceStateProvider);
        if (!currentState.isPaused) {
          silenceStateNotifier.setProgress(progress);
          // Update ongoing notification progress (coarse)
          try {
            final pct = (progress * 100).clamp(0, 100).round();
            ref
                .read(notificationServiceProvider)
                .updateOngoingSession(
                  title: 'Deep Focus',
                  body: 'Session in progress',
                  progress: pct,
                );
          } catch (_) {}
        }
        // Avoid voice during session to keep focus
      },
      onComplete: (legacySuccess) async {
        if (ref.read(silenceStateProvider).canStop) {
          silenceStateNotifier.setListening(false);
          silenceStateNotifier.setCanStop(false);

          final sessionStats = silenceDetector.getSessionStats();
          final endTime = DateTime.now();
          final actualDuration = endTime.difference(startTime).inSeconds;

          // NEW: Use Ambient Score for success determination (consolidated system)
          final ambientState = ref.read(ambientSessionEngineProvider);
          final ambientScore = ambientState.ambientScore;
          final quietSeconds = ambientState.quietSeconds;
          final success = ambientScore >= 0.70; // 70% calm threshold

          silenceStateNotifier.setSuccess(success);

          // NEW: Proportional points based on quiet minutes (compassionate credit)
          final creditedMinutes = success ? (quietSeconds ~/ 60) : 0;
          final pointsEarned = creditedMinutes * AppConstants.pointsPerMinute;

          final sessionRecord = SessionRecord(
            date: startTime,
            pointsEarned: pointsEarned,
            averageNoise: sessionStats.averageNoise,
            duration: actualDuration,
            completed: success,
            activity: ref.read(selectedProfileIdProvider),
            ambientScore: ambientScore, // Store ambient score for analytics
          );

          await silenceDataNotifier.addSessionRecord(sessionRecord);

          // Ambient Quests: end engine to persist session + update quests
          try {
            await ref
                .read(ambientSessionEngineProvider.notifier)
                .end(
                  reason: success ? 'completed' : 'ended',
                  plannedSeconds: sessionDuration,
                );
          } catch (_) {}

          // Stop ticking subscription
          try {
            await _ambientTickSub?.cancel();
          } catch (_) {}
          _ambientTickSub = null;

          // Phase 1 celebration for first micro-session of the day (>= 60s)
          // Legacy mission celebration removed (P0 uses Quest system instead)
          if (success && actualDuration >= 60) {
            try {
              ref
                  .read(accessibilityServiceProvider)
                  .vibrateOnEvent(AccessibilityEvent.sessionComplete);
            } catch (_) {}
          }

          // Update per-activity progress minutes for Today bar
          // P0: Quest progress is automatically updated via ambient engine
          // Legacy activity tracking removed

          if (notificationService.enableSessionComplete) {
            if (!context.mounted) return;
            notificationService.showSessionComplete(
              context,
              success,
              creditedMinutes, // Use credited minutes for notifications
            );
            final message = notificationService.getCompletionMessage(
              success,
              creditedMinutes, // Use credited minutes for notifications
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
          try {
            await ref.read(notificationServiceProvider).cancelOngoingSession();
          } catch (_) {}
        }
      },
      onError: (error) async {
        if (ref.read(silenceStateProvider).canStop) {
          silenceStateNotifier.setListening(false);
          silenceStateNotifier.setCanStop(false);
          silenceStateNotifier.setError(error);

          final sessionStats = silenceDetector.getSessionStats();
          final endTime = DateTime.now();
          final actualDuration = endTime.difference(startTime).inSeconds;

          // Get ambient score for error sessions too (for analytics)
          final ambientState = ref.read(ambientSessionEngineProvider);
          final ambientScore = ambientState.ambientScore;

          final sessionRecord = SessionRecord(
            date: startTime,
            pointsEarned: 0, // Error sessions earn 0 points
            averageNoise: sessionStats.averageNoise,
            duration: actualDuration,
            completed: false,
            activity: ref.read(selectedProfileIdProvider),
            ambientScore: ambientScore, // Store ambient score even for errors
          );

          silenceDataNotifier.addSessionRecord(sessionRecord);
          // Stop ambient engine tick without persisting a session record
          try {
            await _ambientTickSub?.cancel();
          } catch (_) {}
          _ambientTickSub = null;
          try {
            ref.read(notificationServiceProvider).cancelOngoingSession();
          } catch (_) {}
        }
      },
    );
  }

  void _stopSilenceDetection(BuildContext context) {
    final silenceDetector = ref.read(silenceDetectorProvider);
    final silenceStateNotifier = ref.read(silenceStateProvider.notifier);
    final accessibilityService = ref.read(accessibilityServiceProvider);

    silenceDetector.stopListening();
    silenceStateNotifier.stopSession();
    silenceDetector.clearReadings();
    accessibilityService.vibrateOnEvent(AccessibilityEvent.buttonPress);
    // End ambient engine if running (user-initiated stop)
    try {
      final plannedSeconds = ref.read(sessionDurationProvider);
      ref
          .read(ambientSessionEngineProvider.notifier)
          .end(reason: 'stopped', plannedSeconds: plannedSeconds);
    } catch (_) {}
    try {
      _ambientTickSub?.cancel();
    } catch (_) {}
    _ambientTickSub = null;
    try {
      ref.read(notificationServiceProvider).cancelOngoingSession();
    } catch (_) {}
  }

  String _missionDayKey(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return 'mission_${d.toIso8601String().split('T').first}';
  }

  Widget _buildRecentSessionsCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Sessions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No recent sessions',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(icon: Icon(Icons.today_rounded), text: 'Today'),
            Tab(
              icon: Icon(Icons.play_circle_outline_rounded),
              text: 'Sessions',
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[month - 1];
  }

  String _getDayNameShort(int weekday) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[weekday - 1];
  }

  String _getMonthShortName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

class _GlowingProgressRing extends StatelessWidget {
  final double size;
  final double progress; // 0..1
  final String timeLabel; // e.g., 01:00 or 1:30:00
  final VoidCallback onStart;
  final bool isListening;
  final String? subtitleText;

  const _GlowingProgressRing({
    required this.size,
    required this.progress,
    required this.timeLabel,
    required this.onStart,
    required this.isListening,
    this.subtitleText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ringColor = theme.colorScheme.primary;
    final glowColor = ringColor.withValues(alpha: 0.35);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer soft glow
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: glowColor, blurRadius: 60, spreadRadius: 10),
              ],
            ),
          ),
          // Background circle
          Container(
            width: size * 0.92,
            height: size * 0.92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.25,
              ),
            ),
          ),
          // Progress arc
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                return CustomPaint(
                  painter: _RingPainter(
                    color: ringColor,
                    progress: value,
                    stroke: 14,
                  ),
                );
              },
            ),
          ),

          // Center content (simplified - controls moved to top row)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeLabel,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Show subtitle only when NOT listening
              if (!isListening && subtitleText != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitleText!,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              // Show Start button only when NOT listening
              if (!isListening) ...[
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.all(18),
                    elevation: 3,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Start',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final Color color;
  final double progress;
  final double stroke;

  _RingPainter({
    required this.color,
    required this.progress,
    required this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - stroke / 2;

    final bgPaint =
        Paint()
          ..color = color.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round;

    final fgPaint =
        Paint()
          ..shader = SweepGradient(
            colors: [color, color.withValues(alpha: 0.6)],
            startAngle: 0,
            endAngle: 6.28318,
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round;

    // Background ring
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc (start at -90 degrees)
    const startAngle = -3.14159 / 2;
    final sweep = 6.28318 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.stroke != stroke;
}

/// Custom painter for multi-segment ring
class _MultiSegmentRingPainter extends CustomPainter {
  final List<Map<String, dynamic>> activities;
  final int totalTarget;

  _MultiSegmentRingPainter({
    required this.activities,
    required this.totalTarget,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 16.0;

    // Draw background ring
    final bgPaint =
        Paint()
          ..color = Colors.grey.withValues(alpha: 0.2)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw segments for each activity
    double startAngle = -math.pi / 2; // Start at top
    for (var activity in activities) {
      final completed = activity['completed'] as int;
      final target = activity['target'] as int;
      final color = activity['color'] as Color;

      if (target > 0 && totalTarget > 0) {
        final segmentAngle = (2 * math.pi * target) / totalTarget;
        final progressAngle = (segmentAngle * completed) / target;

        if (completed > 0) {
          final paint =
              Paint()
                ..color = color
                ..strokeWidth = strokeWidth
                ..style = PaintingStyle.stroke
                ..strokeCap = StrokeCap.round;

          canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius),
            startAngle,
            progressAngle,
            false,
            paint,
          );
        }

        startAngle += segmentAngle;
      }
    }
  }

  @override
  bool shouldRepaint(_MultiSegmentRingPainter oldDelegate) => true;
}

/// Custom painter for Apple-style activity rings
class _ActivityRingsPainter extends CustomPainter {
  final double focusProgress;
  final double streakProgress;
  final double sessionsProgress;

  _ActivityRingsPainter({
    required this.focusProgress,
    required this.streakProgress,
    required this.sessionsProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 14.0;

    // Outer ring - Focus (Red)
    _drawRing(
      canvas,
      center,
      size.width / 2 - strokeWidth / 2,
      strokeWidth,
      const Color(0xFFFA114F),
      focusProgress,
    );

    // Middle ring - Streak (Green)
    _drawRing(
      canvas,
      center,
      size.width / 2 - strokeWidth * 2.5,
      strokeWidth,
      const Color(0xFFB0FC38),
      streakProgress,
    );

    // Inner ring - Sessions (Cyan)
    _drawRing(
      canvas,
      center,
      size.width / 2 - strokeWidth * 4.5,
      strokeWidth,
      const Color(0xFF00D9FF),
      sessionsProgress,
    );
  }

  void _drawRing(
    Canvas canvas,
    Offset center,
    double radius,
    double strokeWidth,
    Color color,
    double progress,
  ) {
    final paint =
        Paint()
          ..color = color.withValues(alpha: 0.2)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Background ring
    canvas.drawCircle(center, radius, paint);

    // Progress ring
    if (progress > 0) {
      final progressPaint =
          Paint()
            ..color = color
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ActivityRingsPainter oldDelegate) {
    return oldDelegate.focusProgress != focusProgress ||
        oldDelegate.streakProgress != streakProgress ||
        oldDelegate.sessionsProgress != sessionsProgress;
  }
}

class _MockIcon {
  final IconData icon;
  final String label;
  final Color color;
  final double progress; // 0..1
  const _MockIcon(this.icon, this.label, this.color, this.progress);
}

class _ScrollableIconGrid extends StatelessWidget {
  final List<_MockIcon> icons; // expect 7 items for mock
  const _ScrollableIconGrid({required this.icons});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Two columns, vertical scroll; height shows two full rows
    // Slightly shorter per-row target; actual tile height is governed by childAspectRatio below.
    const rowHeight = 68.0;
    return SizedBox(
      height: rowHeight * 2 + 4, // two rows visible
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        // Use a smaller aspect ratio (w/h) to allow more vertical space per tile,
        // avoiding label overflow on compact widths.
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.2,
        ),
        itemCount: icons.length,
        itemBuilder: (context, index) {
          final item = icons[index];
          return LayoutBuilder(
            builder: (context, constraints) {
              final h = constraints.maxHeight;
              // Reserve space for label and spacing; size the circle to fit what's left.
              const labelHeight = 12.0; // approx for labelSmall
              const spacing = 3.0;
              final circleSize = (h - labelHeight - spacing).clamp(28.0, 56.0);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: circleSize,
                    height: circleSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 4,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              item.color.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: CircularProgressIndicator(
                            value: item.progress,
                            strokeWidth: 4,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              item.color,
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Container(
                          width: circleSize * 0.72,
                          height: circleSize * 0.72,
                          decoration: BoxDecoration(
                            color: item.color,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.icon,
                            color: Colors.white,
                            size: circleSize * 0.36,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: spacing),
                  Text(
                    item.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _OverallRing extends StatelessWidget {
  final double percent; // 0..1
  const _OverallRing({required this.percent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 12,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary.withValues(alpha: 0.15),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CircularProgressIndicator(
            value: percent.clamp(0.0, 1.0),
            strokeWidth: 12,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(percent * 100).round()}%',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
              'Overall',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Stages chips removed for now to keep the card compact
