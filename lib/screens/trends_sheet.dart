import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/silence_provider.dart';
import 'package:focus_field/models/silence_data.dart';
import 'package:focus_field/widgets/session_heatmap.dart';
import 'package:focus_field/widgets/advanced_analytics_widget.dart';
import 'package:focus_field/widgets/feature_gate.dart';
import 'package:focus_field/models/subscription_tier.dart';
import 'package:focus_field/theme/theme_extensions.dart';
import 'package:focus_field/utils/responsive_utils.dart';
import 'package:intl/intl.dart';
import 'package:focus_field/widgets/share_preview_sheet.dart';
import 'package:focus_field/widgets/weekly_recap_card.dart';
import 'package:focus_field/providers/weekly_recap_provider.dart';

/// Bottom sheet showing insights and analytics.
/// Mirrors Settings sheet style for consistency.
/// Tabs: Basic (7-day trends, stats), Advanced (performance metrics, premium).
class TrendsSheet extends ConsumerStatefulWidget {
  const TrendsSheet({super.key});

  @override
  ConsumerState<TrendsSheet> createState() => _TrendsSheetState();
}

class _TrendsSheetState extends ConsumerState<TrendsSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Shows share options with preview bottom sheet.
  /// Calculates both daily and weekly stats for user to choose.
  void _showShareOptions(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.read(silenceDataNotifierProvider);
    if (!dataAsync.hasValue) return;

    final data = dataAsync.value;
    final sessions = data?.recentSessions ?? [];
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Row(
              children: [
                Icon(Icons.insights, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Insights',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Share button
                IconButton(
                  icon: const Icon(Icons.share),
                  tooltip: 'Share weekly summary',
                  onPressed: () => _showShareOptions(context, ref),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // Tabs with icons (match Settings style)
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.tune), text: 'Basic'),
              Tab(icon: Icon(Icons.engineering), text: 'Advanced'),
            ],
          ),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _TrendsBasicTab(),
                _TrendsAdvancedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendsBasicTab extends ConsumerWidget {
  const _TrendsBasicTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(silenceDataNotifierProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // 7-day stacked bars card (fixed height, minimal)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: context.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Last 7 Days',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Minutes by activity',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Weekly Recap card (fetch latest or generate if missing)
                Consumer(builder: (context, ref, _) {
                  final latestRecapAsync = ref.watch(latestWeeklyRecapProvider);
                  return latestRecapAsync.when(
                    data: (recap) {
                      if (recap != null) {
                        return WeeklyRecapCard(
                          recap: recap,
                        );
                      }
                      // No cached recap, attempt to generate one on the fly (best effort)
                      final genAsync = ref.watch(generateWeeklyRecapProvider(null));
                      return genAsync.when(
                        data: (newRecap) => WeeklyRecapCard(
                          recap: newRecap,
                        ),
                        loading: () => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: context.subtleCardDecoration,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 12),
                              Text('Preparing your weekly recap...', style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        error: (e, st) => const SizedBox.shrink(),
                      );
                    },
                    loading: () => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: context.subtleCardDecoration,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          Text('Loading recap...', style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    error: (e, st) => const SizedBox.shrink(),
                  );
                }),
                const SizedBox(height: 8),
                SizedBox(
                  height: context.chartHeight + 30,
                  child: dataAsync.when(
                    data: (d) => _SevenDayStackedBars(sessions: d.recentSessions),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => Center(
                      child: Text(
                        'No data',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Summary stats
          Row(
            children: [
              _statChip(context, Icons.stacked_line_chart, 'Weekly Total',
                  _weeklyTotalMinutes(dataAsync)),
              const SizedBox(width: 12),
              _statChip(context, Icons.today, 'Best Day',
                  _bestDayLabel(context, dataAsync)),
            ],
          ),
          const SizedBox(height: 16),
          // 12-week activity heatmap
          Container(
            padding: const EdgeInsets.all(12),
            decoration: context.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity Heatmap',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Recent activity',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                dataAsync.when(
                  data: (d) => SessionHeatmap(
                    sessions: d.recentSessions,
                    // Let heatmap determine optimal weeks (8 weeks or current month)
                  ),
                  loading: () => const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        'Unable to load heatmap',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _bestDayLabel(BuildContext context, AsyncValue<dynamic> async) {
    if (!async.hasValue) return '—';
  final sessions = (async.value.recentSessions as List<SessionRecord>?) ?? [];
    if (sessions.isEmpty) return '—';
    // Aggregate minutes per weekday (0..6)
    final Map<int, int> mins = {for (var i = 0; i < 7; i++) i: 0};
    for (final s in sessions) {
      final w = s.date.weekday % 7; // 1..7 -> 1..0 mapping
  mins[w] = mins[w]! + ((s.duration) ~/ 60);
    }
    int bestIdx = 0;
    int bestVal = -1;
    mins.forEach((k, v) {
      if (v > bestVal) {
        bestVal = v;
        bestIdx = k;
      }
    });
    const names = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  return '${names[(bestIdx) % 7]} (${bestVal}m)';
  }

  String _weeklyTotalMinutes(AsyncValue<dynamic> async) {
    if (!async.hasValue) return '—';
    final sessions = (async.value.recentSessions as List<SessionRecord>?) ?? [];
  int total = 0;
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day).subtract(
      const Duration(days: 6),
    );
    for (final s in sessions) {
      if (!s.completed) continue;
      final d = DateTime(s.date.year, s.date.month, s.date.day);
  if (!d.isBefore(start)) total += s.duration;
    }
    return '${total ~/ 60}m';
  }

  Widget _statChip(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: context.subtleCardDecoration,
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.labelSmall),
                  Text(
                    value,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SevenDayStackedBars extends ConsumerWidget {
  final List<SessionRecord> sessions;
  const _SevenDayStackedBars({required this.sessions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    // Prepare last 7 days normalized to midnight
    final days = List.generate(7, (i) {
      final d = today.subtract(Duration(days: 6 - i));
      return DateTime(d.year, d.month, d.day);
    });

    // Aggregate minutes per day per activity
    final List<Map<String, int>> perDay = List.generate(7, (_) => {});
    for (final s in sessions) {
      if (!s.completed) continue;
      final d = DateTime(s.date.year, s.date.month, s.date.day);
      final idx = days.indexOf(d);
      if (idx == -1) continue;
      final mins = (s.duration ~/ 60);
      if (mins <= 0) continue;
      final key = s.activity ?? 'focus';
      perDay[idx][key] = (perDay[idx][key] ?? 0) + mins;
    }

    // Determine max total minutes in any day for scaling
    int maxDay = 1;
    for (final m in perDay) {
      final total = m.values.fold<int>(0, (a, b) => a + b);
      if (total > maxDay) maxDay = total;
    }

    // Build bars
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (i) {
        final map = perDay[i];
        final total = map.values.fold<int>(0, (a, b) => a + b);
        final label = _shortDay(days[i].weekday);
        return Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barMax = constraints.maxHeight - 28; // reserve space for label + spacing
              final barHeight = total == 0 ? 0.0 : (total / maxDay) * barMax;
              // Stable ordering of segments by activity id
              final entries = map.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Bar area with optional target line
                  SizedBox(
                    height: barMax,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Weekly target line (drawn first, behind bars)
                        _buildTargetLine(context, barMax, maxDay),
                        // Baseline tick for empty days
                        if (total == 0)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          )
                        else
                          _buildStackedSegments(
                            context,
                            ref,
                            entries,
                            total,
                            barHeight,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: theme.textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildTargetLine(BuildContext context, double barMax, int maxDay) {
    final theme = Theme.of(context);
    // Default weekly target: 30 minutes per day
    const dailyTargetMinutes = 30;

    if (maxDay < dailyTargetMinutes) {
      // Don't show target line if it would be above the chart
      return const SizedBox.shrink();
    }

    final targetLinePosition = (dailyTargetMinutes / maxDay) * barMax;

    return Positioned(
      left: 0,
      right: 0,
      bottom: targetLinePosition,
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.6),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStackedSegments(
    BuildContext context,
    WidgetRef ref,
    List<MapEntry<String, int>> entries,
    int total,
    double targetHeight,
  ) {
    final theme = Theme.of(context);
    // Convert to positioned segments stacked from bottom
    double accumulated = 0.0;
    final children = <Widget>[];
    for (final e in entries) {
      final h = (e.value / total) * targetHeight;
      final color = _activityColor(context, ref, e.key) ?? theme.colorScheme.primary;
      children.add(Positioned(
        left: 10,
        right: 10,
        bottom: accumulated,
        height: h,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ));
      accumulated += h;
    }
    return Stack(children: children);
  }

  Color? _activityColor(BuildContext context, WidgetRef ref, String activityId) {
    final cs = Theme.of(context).colorScheme;
    return _builtInColor(cs, activityId);
  }

  Color _builtInColor(ColorScheme cs, String key) {
    switch (key.toLowerCase()) {
      case 'work':
        return cs.primary;
      case 'study':
      case 'studying':
        return cs.primary;
      case 'reading':
        return cs.secondary;
      case 'meditation':
        return cs.tertiary;
      case 'fitness':
        return cs.secondaryContainer;
      case 'family':
      case 'other':
        return cs.tertiaryContainer;
      case 'noise':
      case 'focus':
        return cs.primaryContainer;
      default:
        return cs.primary;
    }
  }

  String _shortDay(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(weekday - 1) % 7];
  }
}

class _TrendsAdvancedTab extends ConsumerWidget {
  const _TrendsAdvancedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(silenceDataNotifierProvider);

    return dataAsync.when(
      data: (data) => SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: FeatureGate(
          featureId: 'advanced_analytics',
          requiredTier: SubscriptionTier.premium,
          child: AdvancedAnalyticsWidget(
            silenceData: data,
            showTitle: false, // Hide title since we're already in the Advanced tab
          ),
        ),
      ),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Error loading data',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
