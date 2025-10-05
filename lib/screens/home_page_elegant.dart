// ignore_for_file: unused_element
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;
import '../providers/silence_provider.dart';
import '../providers/activity_provider.dart';
import '../providers/accessibility_provider.dart';
import '../providers/notification_provider.dart';
import '../services/accessibility_service.dart';
import '../models/silence_data.dart';
import '../constants/app_constants.dart';
import '../widgets/inline_noise_panel.dart';
import '../widgets/create_custom_activity_dialog.dart';
import '../providers/theme_provider.dart';
import './trends_sheet.dart';
import '../providers/subscription_provider.dart';
import 'package:confetti/confetti.dart';
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
  // Debounce for theme toggle
  DateTime? _lastThemeToggleTime;
  // Activity tab: selected session duration in minutes
  int _selectedDurationMinutes = 1;
  // Activity list scroll state for the Summary card
  final ScrollController _activityScrollController = ScrollController();
  int _activityPageIndex = 0; // which chunk of 3 items is visible
  static const int _visibleActivityRows = 3;
  // Row height is computed dynamically per build to fill most of the card.
  double _activityRowHeight = 40;
  static const double _activityRowSpacing = 1;
  // Consistent card style like "Last 7 Days"
  static const double _cardRadius = 16.0;
  static const EdgeInsets _cardPadding = EdgeInsets.fromLTRB(12, 10, 12, 12);
  BoxDecoration _cardDecoration(ThemeData theme) => BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      );

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
      final firstIndex = (_activityScrollController.offset / itemExtent)
          .clamp(0, double.infinity)
          .floor();
      final page = firstIndex ~/ _visibleActivityRows;
      if (page != _activityPageIndex) {
        setState(() => _activityPageIndex = page);
      }
    });

  }
  @override
  void dispose() {
    _activityScrollController.dispose();
    _tabController.dispose();
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  // Responsive flags (computed where needed per section)

    // Listen for session completion/failure to trigger confetti and a11y events
    if (!_sessionListenerWired) {
      _sessionListenerWired = true;
      ref.listen<SilenceState>(silenceStateProvider, (previous, next) async {
        if (next.success == true && previous?.success != true) {
          _confetti.play();
          try {
            ref.read(accessibilityServiceProvider).vibrateOnEvent(AccessibilityEvent.sessionComplete);
            ref.read(accessibilityServiceProvider).announceSessionComplete(true);
          } catch (_) {}
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            ref.read(silenceStateProvider.notifier).setSuccess(null);
          }
        } else if (next.success == false && previous?.success != false) {
          try {
            ref.read(accessibilityServiceProvider).vibrateOnEvent(AccessibilityEvent.sessionFailed);
            ref.read(accessibilityServiceProvider).announceSessionComplete(false);
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
                    theme.colorScheme.primary.withValues(alpha: 0.05),
                    theme.colorScheme.surface,
                    theme.colorScheme.surface,
                  ],
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
                // Header
                _buildHeader(context),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildSummaryTab(context),
                      _buildActivityTab(context),
                    ],
                  ),
                ),

                // Bottom navigation bar
                _buildBottomNav(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dayShort = _getDayNameShort(now.weekday);
    final monthShort = _getMonthShortName(now.month);
    final currentTheme = ref.watch(themeProvider);
    final size = MediaQuery.sizeOf(context);
    final isNarrow = size.width < 360;
    final horizontalPad = isNarrow ? 8.0 : 12.0;
    final showInlineDate = _currentTab == 0 && !isNarrow;

    return Container(
      padding: EdgeInsets.fromLTRB(horizontalPad, 8, horizontalPad, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Page title (tab name) with inline date on Summary only
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    _currentTab == 0 ? 'Summary' : 'Activity',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                if (showInlineDate) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '($dayShort, $monthShort ${now.day})',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Actions: (Summary only) date chip, Tips, Theme, Settings
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.lightbulb_outline, color: theme.colorScheme.onSurfaceVariant),
                onPressed: () {},
                tooltip: 'Tips',
              ),
              IconButton(
                icon: Icon(currentTheme.icon, color: theme.colorScheme.onSurfaceVariant),
                onPressed: () => _toggleTheme(context),
                tooltip: 'Theme',
              ),
              IconButton(
                icon: Icon(Icons.settings_outlined, color: theme.colorScheme.onSurfaceVariant),
                onPressed: () {},
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
    if (_lastThemeToggleTime != null && now.difference(_lastThemeToggleTime!) < const Duration(milliseconds: 350)) {
      return;
    }
    _lastThemeToggleTime = now;
    final themeNotifier = ref.read(themeProvider.notifier);
    final hasPremiumAccess = ref.read(premiumAccessProvider);
    final current = ref.read(themeProvider);
    // Subtle haptic feedback
    try {
      ref.read(accessibilityServiceProvider).vibrateOnEvent(AccessibilityEvent.buttonPress);
    } catch (_) {}

    themeNotifier.cycleTheme(hasPremiumAccess: hasPremiumAccess);

    // Feedback: brief snackbar with next theme name
    final availableThemes =
        hasPremiumAccess
            ? AppThemeMode.values
            : [AppThemeMode.system, AppThemeMode.light, AppThemeMode.dark];
    final currentIndex = availableThemes.indexOf(current);
    final nextIndex = currentIndex >= 0 ? (currentIndex + 1) % availableThemes.length : 0;
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

  Widget _buildSummaryTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 6),
        // Activity Progress with real provider integration
        _buildProposedActivityWidget3(context),
        const SizedBox(height: 8),
        // Eye-catching Today's Focus card below Activity
        _buildTodaysMissionCard(context),
        const SizedBox(height: 8),
  // 7-day stacked bars moved to Trends > Show More (Basic tab)
        _buildTrendsCard(context),
        const SizedBox(height: 8),
        _buildAdvertisementPlaceholder(context),
      ],
    );
  }


  Widget _buildActivityTab(BuildContext context) {
    return Column(
      children: [
        // Horizontal activity chips (enclosed in card)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            decoration: _cardDecoration(Theme.of(context)),
            child: _buildHorizontalActivityChips(context),
          ),
        ),

        // Compact per-activity daily goal (Today) just below chips (enclosed in card)
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
          child: Container(
            padding: _cardPadding,
            decoration: _cardDecoration(Theme.of(context)),
            child: _buildDailyGoalCompactInner(context),
          ),
        ),

        // Scrollable content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 6),
              _buildComplementaryPanel(context),
              const SizedBox(height: 8),
              _buildSessionControlCard(context),
              const SizedBox(height: 8),
              _buildAdvertisementPlaceholder(context),
            ],
          ),
        ),
      ],
    );
  }

  // Inner content for Today's 0/1 min row; wrapper card is added by caller
  Widget _buildDailyGoalCompactInner(BuildContext context) {
    final theme = Theme.of(context);
    final activityState = ref.watch(activityTrackingProvider);
    if (activityState.trackedActivities.isEmpty) return const SizedBox.shrink();

    // Find selected activity progress (supports custom IDs like custom_<id>)
    final selectedId = activityState.selectedActivity;
    final progress = activityState.trackedActivities.firstWhere(
      (a) => a.activityId == selectedId,
      orElse: () => activityState.trackedActivities.first,
    );

    final isCustom = progress.isCustom;
    final color = isCustom
        ? progress.customActivity!.color
        : _getActivityColor(progress.type.key);
    final iconData = isCustom
        ? progress.customActivity!.icon
        : _getActivityIcon(progress.type.key);

    final goal = progress.goalMinutes.clamp(1, 1000);
    final done = progress.completedMinutes.clamp(0, goal);
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
                Row(
                  children: [
                    Text(
                      'Today',
                      style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$done/$goal min',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 6,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
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

  Widget _buildHorizontalActivityChips(BuildContext context) {
    final activityState = ref.watch(activityTrackingProvider);
    final showAddButton = activityState.trackedActivities.length < 8;

    return Padding(
      padding: _cardPadding,
      child: SizedBox(
        height: 60,
        child: Row(
        children: [
          // Scrollable activities
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              itemCount: activityState.trackedActivities.length,
              itemBuilder: (context, index) {
                final activity = activityState.trackedActivities[index];
                final isSelected = activity.activityId == activityState.selectedActivity;

                // For custom activities, use Material icon; for built-in, use icon
                final displayWidget = activity.isCustom
                    ? Icon(activity.displayIconData!, size: 18, color: Colors.white)
                    : Icon(_getActivityIcon(activity.type.key), size: 18, color: Colors.white);

                final color = activity.isCustom
                    ? activity.customActivity!.color
                    : _getActivityColor(activity.type.key);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildActivityChipHorizontalCustom(
                    context,
                    displayWidget,
                    _titleCase(activity.displayTitle),
                    isSelected,
                    color,
                    () => ref.read(activityTrackingProvider.notifier).selectActivity(activity.activityId),
                  ),
                );
              },
            ),
          ),
          // Fixed + button on the right
          if (showAddButton)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildAddActivityButton(context),
            ),
        ],
      ),
    ),
    );
  }

  Widget _buildAddActivityButton(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _showAddActivitySheet(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddActivitySheet(BuildContext context) async {
    final theme = Theme.of(context);
    final tracked = ref.read(activityTrackingProvider).trackedActivities.map((a) => a.type).toSet();
    // Exclude 'custom' from available list - custom activities are created separately
    final available = ActivityType.values.where((t) => !tracked.contains(t) && t != ActivityType.custom).toList();
    final isPremium = ref.read(premiumAccessProvider);

    // Bottom sheet picker
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (ctx) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: available.length + 1, // +1 for "Create Custom" option
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
            itemBuilder: (context, index) {
              // "Create Custom" option at the end
              if (index == available.length) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(Icons.add, color: theme.colorScheme.primary, size: 18),
                  ),
                  title: Text(
                    'Create Custom Activity',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _showCreateCustomActivityDialog(context);
                  },
                );
              }

              // Pre-built activities
              final t = available[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getActivityColor(t.key),
                  child: Icon(_getActivityIcon(t.key), color: Colors.white, size: 18),
                ),
                title: Text(_titleCase(t.key)),
                onTap: () async {
                  final ok = await ref.read(activityTrackingProvider.notifier).addActivity(t.key, isPremium: isPremium);
                  if (!context.mounted) return;
                  if (ok) {
                    await ref.read(activityTrackingProvider.notifier).selectActivity(t.key);
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  } else {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Upgrade to Premium to add more activities'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showCreateCustomActivityDialog(BuildContext context) async {
    final customActivity = await showModalBottomSheet<CustomActivity>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const CreateCustomActivitySheet(),
      ),
    );

    if (customActivity == null || !context.mounted) return;

    final isPremium = ref.read(premiumAccessProvider);
    final ok = await ref.read(activityTrackingProvider.notifier).addCustomActivity(
      customActivity,
      isPremium: isPremium,
    );

    if (!context.mounted) return;

    if (ok) {
      await ref.read(activityTrackingProvider.notifier).selectActivity(customActivity.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${customActivity.title} added!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Upgrade to Premium to add more activities'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
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
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 14,
              ),
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
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
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
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
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
    final activityState = ref.watch(activityTrackingProvider);
    final selectedActivity = activityState.selectedActivity;
    final selectedType = ActivityType.fromKey(selectedActivity);
    final threshold = ref.watch(decibelThresholdProvider);
    final silenceState = ref.watch(silenceStateProvider);

    if (selectedType.requiresSilence) {
      // New: inline panel wrapped in a card
      return Container(
        padding: _cardPadding,
        decoration: _cardDecoration(theme),
        child: InlineNoisePanel(
          threshold: threshold,
          isListening: silenceState.isListening,
        ),
      );
    }

    // Non-silence activity: provide a compact helper card
    return Container(
      padding: _cardPadding,
      decoration: _cardDecoration(theme),
      child: Row(
        children: [
          Icon(Icons.track_changes, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Set your duration and track ${_titleCase(selectedType.key)} time. Session history and analytics will appear in Summary.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityProgressWidget(BuildContext context) {
    final theme = Theme.of(context);
    final screen = MediaQuery.sizeOf(context);

    // Provider-driven data
    final activityState = ref.watch(activityTrackingProvider);
    final activities = activityState.trackedActivities;
    final silenceDataAsync = ref.watch(silenceDataNotifierProvider);

    // Fallback placeholder if empty
    final hasItems = activities.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 10),
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
                'Activity',
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Scroll indicators
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: () {
          final pageCount = ((hasItems ? activities.length : 1) / _visibleActivityRows).ceil();
                  return List.generate(pageCount, (index) {
                    final active = index == _activityPageIndex;
                    return Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: active
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                    );
                  });
                }(),
              ),
              const SizedBox(width: 8),
              // Vertically scrollable activities (slightly narrower than before)
              Expanded(
                flex: 3,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Derive a list height proportional to the screen so the
                    // card feels balanced while showing exactly 3 rows.
          final desiredListHeight = (screen.height * 0.195)
            .clamp(112.0, 198.0);
          final computedRowHeight = (
                      desiredListHeight -
                      (_visibleActivityRows - 1) * _activityRowSpacing
          ) / _visibleActivityRows;
          _activityRowHeight = computedRowHeight < 40.0
            ? 40.0
            : computedRowHeight;

                    return SizedBox(
                      height: _visibleActivityRows * _activityRowHeight +
                          (_visibleActivityRows - 1) * _activityRowSpacing,
                      child: ListView.separated(
                        controller: _activityScrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: hasItems ? activities.length : 1,
                        itemBuilder: (context, index) {
                          if (!hasItems) {
                            return SizedBox(
                              height: _activityRowHeight,
                              child: _buildActivityRow(
                                context,
                                Icons.add,
                                'Add Activity',
                                0.0,
                                theme.colorScheme.primary,
                              ),
                            );
                          }
                          final a = activities[index];
                          final key = a.type.key;
                          return SizedBox(
                            height: _activityRowHeight,
                            child: _buildActivityRow(
                              context,
                              _getActivityIcon(key),
                              _titleCase(key),
                              a.progress,
                              _getActivityColor(key),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: _activityRowSpacing),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Stats panel with compact horizontal rows inside a darker nested card
              Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 110,
                    maxWidth: (screen.width * 0.28).clamp(115.0, 150.0),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      // Darker nested background without an explicit border
                      color: Color.alphaBlend(
                        Colors.black.withValues(alpha: 0.25),
                        theme.colorScheme.surfaceContainerHighest,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        silenceDataAsync.when(
                          data: (d) {
                            final points = d.totalPoints;
                            final sessions = d.totalSessions;
                            final streak = d.currentStreak;
                            // Simple targets for proportional rings
                            const pointsTarget = 100.0;
                            const sessionsTarget = 20.0;
                            const streakTarget = 7.0;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildStatRingRow(
                                  context,
                                  Icons.stars,
                                  'Points',
                                  '${points}/${pointsTarget.toInt()}',
                                  '',
                                  (points / pointsTarget).clamp(0.0, 1.0),
                                  const Color(0xFFFA114F),
                                ),
                                const SizedBox(height: 8),
                                _buildStatRingRow(
                                  context,
                                  Icons.local_fire_department,
                                  'Streak',
                                  '${streak}/${streakTarget.toInt()}',
                                  'DAYS',
                                  (streak / streakTarget).clamp(0.0, 1.0),
                                  const Color(0xFFB0FC38),
                                ),
                                const SizedBox(height: 8),
                                _buildStatRingRow(
                                  context,
                                  Icons.play_circle_outline,
                                  'Sessions',
                                  '${sessions}/${sessionsTarget.toInt()}',
                                  '',
                                  (sessions / sessionsTarget).clamp(0.0, 1.0),
                                  const Color(0xFF00D9FF),
                                ),
                              ],
                            );
                          },
                          loading: () => _buildStatRingSkeleton(theme),
                          error: (_, __) => _buildStatRingSkeleton(theme),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
          theme.colorScheme.primary.withValues(alpha: 0.6),
        ),
        const SizedBox(height: 8),
        _buildStatRingRow(
          context,
          Icons.local_fire_department,
          'Streak',
          '—/—',
          'DAYS',
          0.0,
          const Color(0xFFB0FC38),
        ),
        const SizedBox(height: 8),
        _buildStatRingRow(
          context,
          Icons.play_circle_outline,
          'Sessions',
          '—/—',
          '',
          0.0,
          const Color(0xFF00D9FF),
        ),
      ],
    );
  }

  String _titleCase(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

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
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
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
                  final barHeight = 10.0;
                  final radius = Radius.circular(5);
                  final completedWidth = (c.maxWidth * progress).clamp(0.0, c.maxWidth);
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
                            borderRadius: BorderRadius.all(radius),
                          ),
                        ),
                        // Completed portion
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          width: completedWidth,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.all(radius),
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

  Widget _buildCompactActivityRow(ThemeData theme, Map<String, dynamic> activity) {
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
  Widget _buildLargerActivityRow(ThemeData theme, Map<String, dynamic> activity) {
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
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.error,
              color: Colors.white,
              size: 24,
            ),
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
      padding: _cardPadding,
      decoration: _cardDecoration(theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Ring Progress', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 4x2 Grid of circular progress rings with colored icons
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: activities.map((activity) {
              final completed = activity['completed'] as int;
              final target = activity['target'] as int;
              final progress = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;
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
                              valueColor: AlwaysStoppedAnimation<Color>(color.withValues(alpha: 0.2)),
                            ),
                          ),
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 5,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
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
                            child: Icon(activity['icon'] as IconData, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activity['label'] as String,
                      style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 10),
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
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Stacked Bars', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                      color: index == 0
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
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
                      final progress = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;
                      final color = activity['color'] as Color;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                              child: Icon(activity['icon'] as IconData, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        activity['label'] as String,
                                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 11),
                                      ),
                                      Text(
                                        '${completed}m / ${target}m',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
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
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: progress,
                                        child: Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(4),
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
  Widget _buildProposedActivityWidget3(BuildContext context) {
    final theme = Theme.of(context);

    // Provider-driven data
    final activityState = ref.watch(activityTrackingProvider);
    final trackedActivities = activityState.trackedActivities;
    final hasActivities = trackedActivities.isNotEmpty;

    // Convert tracked activities to the format expected by _buildLargerActivityRow
    final activities = trackedActivities.take(3).map((a) {
      // Assuming target is 60 minutes for now (can be made configurable)
      final targetMinutes = 60;
      final completedMinutes = (a.progress * targetMinutes).round();

      // Use custom properties if available, otherwise use built-in type properties
      final icon = a.isCustom ? a.displayIconData : _getActivityIcon(a.type.key);
      final color = a.isCustom ? a.customActivity!.color : _getActivityColor(a.type.key);

      return {
        'icon': icon,
        'label': _titleCase(a.displayTitle),
        'completed': completedMinutes,
        'target': targetMinutes,
        'color': color,
      };
    }).toList();

    // Calculate overall progress from tracked activities
    double overallProgress = 0.0;
    if (trackedActivities.isNotEmpty) {
      double totalProgress = 0.0;
      for (var activity in trackedActivities.take(3)) {
        totalProgress += activity.progress;
      }
      overallProgress = (totalProgress / trackedActivities.take(3).length).clamp(0.0, 1.0);
    }
    final percentageText = '${(overallProgress * 100).toInt()}%';

    // Fallback if no activities
    final displayActivities = hasActivities ? activities : [
      {
        'icon': Icons.add,
        'label': 'Add Activity',
        'completed': 0,
        'target': 60,
        'color': theme.colorScheme.primary,
      }
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Activity Progress', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                      color: index == 0
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
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
                      return _buildLargerActivityRow(theme, displayActivities[index]);
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
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
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
    final overallProgress = totalTarget > 0 ? (totalCompleted / totalTarget).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Activity Progress', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                      color: index == 0
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
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
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
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
    final overallProgress = totalTarget > 0 ? (totalCompleted / totalTarget).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Stacked Bars', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text(
                    '(${totalHours % 1 == 0 ? totalHours.toInt() : totalHours.toStringAsFixed(1)}h/${targetHours.toInt()}h)',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('(3 activities)', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                  children: activities.map((activity) {
                    final completed = activity['completed'] as int;
                    final target = activity['target'] as int;
                    final progress = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;
                    final color = activity['color'] as Color;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                            child: Icon(activity['icon'] as IconData, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      activity['label'] as String,
                                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 11),
                                    ),
                                    Text(
                                      '${completed}m / ${target}m',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
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
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: progress,
                                      child: Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(4),
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
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
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
    final overallProgress = totalTarget > 0 ? (totalCompleted / totalTarget).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Stacked Bars', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text(
                    '(${totalHours % 1 == 0 ? totalHours.toInt() : totalHours.toStringAsFixed(1)}h/${targetHours.toInt()}h)',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('(5 activities)', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                        child: Icon(activity['icon'] as IconData, color: Colors.white, size: 14),
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
                                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 10),
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
              }).toList(),
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
                              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
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
      {'icon': Icons.school_outlined, 'label': 'Study', 'completed': 30, 'target': 60, 'color': const Color(0xFF7F6BB0)},
      {'icon': Icons.menu_book_outlined, 'label': 'Reading', 'completed': 45, 'target': 60, 'color': const Color(0xFF5B9BD5)},
      {'icon': Icons.self_improvement_outlined, 'label': 'Meditation', 'completed': 20, 'target': 20, 'color': const Color(0xFF70AD47)},
      {'icon': Icons.fitness_center_outlined, 'label': 'Gym', 'completed': 15, 'target': 30, 'color': const Color(0xFFFA114F)},
      {'icon': Icons.work_outline, 'label': 'Work', 'completed': 120, 'target': 180, 'color': const Color(0xFFED7D31)},
      {'icon': Icons.directions_run, 'label': 'Running', 'completed': 0, 'target': 30, 'color': const Color(0xFF9B59B6)},
      {'icon': Icons.people_outline, 'label': 'Family', 'completed': 60, 'target': 60, 'color': const Color(0xFFFFC000)},
      {'icon': Icons.volume_off_outlined, 'label': 'Focus', 'completed': 10, 'target': 30, 'color': const Color(0xFF00D9FF)},
    ];
  }

  Widget _buildHorizontalStatsWidget(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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
            const Color(0xFFFA114F),
          ),
          _buildCompactStatItem(
            context,
            Icons.local_fire_department,
            'Streak',
            '1/7 DAYS',
            0.14,
            const Color(0xFFB0FC38),
          ),
          _buildCompactStatItem(
            context,
            Icons.play_circle_outline,
            'Sessions',
            '2/20',
            0.1,
            const Color(0xFF00D9FF),
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
              Icon(
                icon,
                color: color,
                size: 26,
              ),
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
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
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
    final theme = Theme.of(context);
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Text(
          'Advertisement',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
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
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF5B6B7C),
            const Color(0xFF4A5A6A),
          ],
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
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
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

    return Container(
      padding: _cardPadding,
      decoration: _cardDecoration(theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trends',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const TrendsSheet(),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
                child: const Text('Show More'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTrendItem(context, 'Focus Time', '29 MIN/DAY', true, const Color(0xFFB0FC38)),
          const SizedBox(height: 8),
          _buildTrendItem(context, 'Sessions', '4/WEEK', true, const Color(0xFF00D9FF)),
          const SizedBox(height: 8),
          _buildTrendItem(context, 'Average', '7 MIN', false, const Color(0xFFFA114F)),
        ],
      ),
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
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
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
      case 'studying':
        return Icons.school_outlined;
      case 'reading':
        return Icons.menu_book_outlined;
      case 'meditation':
        return Icons.self_improvement_outlined;
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
        return const Color(0xFFED7D31); // Orange
      case 'studying':
        return const Color(0xFF7F6BB0); // Purple
      case 'reading':
        return const Color(0xFF5B9BD5); // Blue
      case 'meditation':
        return const Color(0xFF70AD47); // Green
      case 'fitness':
        return const Color(0xFFFA114F); // Red
      case 'family':
        return const Color(0xFFFFC000); // Yellow
      case 'noise':
        return const Color(0xFF00D9FF); // Cyan
      default:
        return const Color(0xFF5B9BD5); // Default blue
    }
  }

  Widget _buildSessionControlCard(BuildContext context) {
    final theme = Theme.of(context);
    final silenceState = ref.watch(silenceStateProvider);
    final durationSeconds = ref.watch(activeSessionDurationProvider);
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.height < 720;
    final ringSize = isCompact ? 186.0 : 206.0;

    return Container(
      padding: _cardPadding,
      decoration: _cardDecoration(theme),
      child: Column(
        children: [
          // Duration selector (hide while session is running)
          if (!silenceState.isListening) ...[
            SizedBox(
              height: 34,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(width: 6),
                  for (final m in const [1, 5, 10, 15, 30])
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: _buildDurationChip(context, m, _selectedDurationMinutes == m),
                    ),
                  for (final m in const [60, 90, 120])
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: _buildDurationChipPremium(context, m, _selectedDurationMinutes == m),
                    ),
                  const SizedBox(width: 6),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
          // Big glowing progress ring with time and start
          _GlowingProgressRing(
            size: ringSize,
            progress: silenceState.progress,
            isListening: silenceState.isListening,
            timeLabel: _formatTimeForSeconds(durationSeconds),
            onStart: () {
              if (silenceState.isListening) {
                _stopSilenceDetection(context);
              } else {
                _startSilenceDetection(context);
              }
            },
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 18,
            child: Center(child: _buildStatusMessage(context, silenceState)),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationChip(BuildContext context, int minutes, bool isSelected) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() => _selectedDurationMinutes = minutes);
        // propagate to active session duration provider (in seconds)
        ref.read(activeSessionDurationProvider.notifier).state = minutes * 60;
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 4,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          minutes.toString(),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDurationChipPremium(BuildContext context, int minutes, bool isSelected) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() => _selectedDurationMinutes = minutes);
        ref.read(activeSessionDurationProvider.notifier).state = minutes * 60;
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 4,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              minutes == 60
                  ? '1h'
                  : minutes == 90
                      ? '1.5h'
                      : '2h',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.star,
              size: 12,
              color: isSelected ? theme.colorScheme.onPrimary : Colors.amber,
            ),
          ],
        ),
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

    await silenceDetector.startListening(
      onProgress: (progress) {
        silenceStateNotifier.setProgress(progress);
        // Avoid voice during session to keep focus
      },
      onComplete: (success) async {
        if (ref.read(silenceStateProvider).canStop) {
          silenceStateNotifier.setListening(false);
          silenceStateNotifier.setCanStop(false);
          silenceStateNotifier.setSuccess(success);

          final sessionStats = silenceDetector.getSessionStats();
          final endTime = DateTime.now();
          final actualDuration = endTime.difference(startTime).inSeconds;

          final durationInMinutes = (sessionDuration / 60).round();
          final pointsEarned = success
              ? (durationInMinutes * AppConstants.pointsPerMinute)
              : 0;

          final sessionRecord = SessionRecord(
            date: startTime,
            pointsEarned: pointsEarned,
            averageNoise: sessionStats.averageNoise,
            duration: actualDuration,
            completed: success,
            activity: ref.read(selectedActivityProvider),
          );

          await silenceDataNotifier.addSessionRecord(sessionRecord);

          // Phase 1 celebration for first micro-session of the day (>= 60s)
          if (success && actualDuration >= 60) {
            final missionDayKey = _missionDayKey(DateTime.now());
            try {
              final celebrated = await ref
                  .read(firstMicroCelebratedProvider(missionDayKey).future);
              if (!celebrated) {
                ref
                    .read(accessibilityServiceProvider)
                    .vibrateOnEvent(AccessibilityEvent.sessionComplete);
                await ref
                    .read(firstMicroCelebratedControllerProvider)
                    .markCelebrated(missionDayKey);
              }
            } catch (_) {}
          }

          // Update per-activity progress minutes for Today bar
          try {
            final selected = ref.read(selectedActivityProvider);
            final minutes = (actualDuration / 60).round().clamp(0, 480);
            if (minutes > 0) {
              await ref
                  .read(activityTrackingProvider.notifier)
                  .updateProgress(selected, minutes);
            }
          } catch (_) {}

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
        if (ref.read(silenceStateProvider).canStop) {
          silenceStateNotifier.setListening(false);
          silenceStateNotifier.setCanStop(false);
          silenceStateNotifier.setError(error);

          final sessionStats = silenceDetector.getSessionStats();
          final endTime = DateTime.now();
          final actualDuration = endTime.difference(startTime).inSeconds;

          final sessionRecord = SessionRecord(
            date: startTime,
            pointsEarned: 0,
            averageNoise: sessionStats.averageNoise,
            duration: actualDuration,
            completed: false,
            activity: ref.read(selectedActivityProvider),
          );

          silenceDataNotifier.addSessionRecord(sessionRecord);
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
            Tab(
              icon: Icon(Icons.summarize_rounded),
              text: 'Summary',
            ),
            Tab(
              icon: Icon(Icons.track_changes_rounded),
              text: 'Activity',
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
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[month - 1];
  }

  String _getDayNameShort(int weekday) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[weekday - 1];
  }

  String _getMonthShortName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

class _GlowingProgressRing extends StatelessWidget {
  final double size;
  final double progress; // 0..1
  final String timeLabel; // e.g., 01:00 or 1:30:00
  final VoidCallback onStart;
  final bool isListening;

  const _GlowingProgressRing({
    required this.size,
    required this.progress,
    required this.timeLabel,
    required this.onStart,
    required this.isListening,
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
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
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
          // Center content
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
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: isListening
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.all(18),
                  elevation: 3,
                ),
                child: Icon(
                  isListening ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  size: 28,
                ),
              ),
              const SizedBox(height: 6),
              Text(isListening ? 'Stop' : 'Start', style: theme.textTheme.titleMedium),
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

  _RingPainter({required this.color, required this.progress, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - stroke / 2;

    final bgPaint = Paint()
  ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
  ..shader = SweepGradient(colors: [color, color.withValues(alpha: 0.6)], startAngle: 0, endAngle: 6.28318).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // Background ring
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc (start at -90 degrees)
    final startAngle = -3.14159 / 2;
    final sweep = 6.28318 * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweep, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color || oldDelegate.stroke != stroke;
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
    final bgPaint = Paint()
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
          final paint = Paint()
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
    _drawRing(canvas, center, size.width / 2 - strokeWidth / 2, strokeWidth,
        const Color(0xFFFA114F), focusProgress);

    // Middle ring - Streak (Green)
    _drawRing(canvas, center, size.width / 2 - strokeWidth * 2.5, strokeWidth,
        const Color(0xFFB0FC38), streakProgress);

    // Inner ring - Sessions (Cyan)
    _drawRing(canvas, center, size.width / 2 - strokeWidth * 4.5, strokeWidth,
        const Color(0xFF00D9FF), sessionsProgress);
  }

  void _drawRing(Canvas canvas, Offset center, double radius,
      double strokeWidth, Color color, double progress) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Background ring
    canvas.drawCircle(center, radius, paint);

    // Progress ring
    if (progress > 0) {
      final progressPaint = Paint()
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
    final rowHeight = 68.0;
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
                            valueColor: AlwaysStoppedAnimation<Color>(item.color.withValues(alpha: 0.2)),
                          ),
                        ),
                        SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: CircularProgressIndicator(
                            value: item.progress,
                            strokeWidth: 4,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(item.color),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Container(
                          width: circleSize * 0.72,
                          height: circleSize * 0.72,
                          decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
                          child: Icon(item.icon, color: Colors.white, size: circleSize * 0.36),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: spacing),
                  Text(
                    item.label,
                    style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 10),
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
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
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

