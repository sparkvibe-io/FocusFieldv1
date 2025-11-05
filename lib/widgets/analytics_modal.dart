import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/silence_provider.dart';
import '../providers/subscription_provider.dart';
import '../models/subscription_tier.dart';
import '../widgets/feature_gate.dart';
import '../constants/ui_constants.dart';
import 'common/drag_handle.dart';
import 'package:focus_field/l10n/app_localizations.dart';

/// Full-screen analytics modal with free and premium sections
class AnalyticsModal extends ConsumerWidget {
  const AnalyticsModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AnalyticsModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final subscription = ref.watch(subscriptionTierProvider);
    final isPremium = subscription.when(
      data: (tier) => tier != SubscriptionTier.free,
      loading: () => false,
      error: (_, __) => false,
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(UIConstants.bottomSheetBorderRadius),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              const DragHandle(),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.analytics,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.analyticsTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // FREE SECTION: Overview
                    _buildOverviewSection(context, ref),

                    const SizedBox(height: 24),

                    // FREE SECTION: 7-Day Activity Chart
                    _build7DayChart(context, ref),

                    const SizedBox(height: 24),

                    // FREE SECTION: Performance Highlights
                    _buildPerformanceHighlights(context, ref),

                    const SizedBox(height: 24),

                    // FREE SECTION: Activity Progress
                    _buildActivityProgress(context, ref),

                    const SizedBox(height: 24),

                    // PREMIUM SECTION: Advanced Analytics
                    if (isPremium) ...[
                      _buildAdvancedMetrics(context, ref),
                      const SizedBox(height: 24),
                      _buildTrendsChart(context, ref),
                      const SizedBox(height: 24),
                      _buildAIInsights(context, ref),
                    ] else
                      _buildPremiumUpsell(context),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewSection(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final silenceDataAsync = ref.watch(silenceDataNotifierProvider);

    return silenceDataAsync.when(
      data: (data) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.analyticsOverview,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildMetricCard(
                      context,
                      icon: Icons.star,
                      label: l10n.analyticsPoints,
                      value: '${data.totalPoints}',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    _buildMetricCard(
                      context,
                      icon: Icons.local_fire_department,
                      label: l10n.analyticsStreak,
                      value: '${data.currentStreak}',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 12),
                    _buildMetricCard(
                      context,
                      icon: Icons.check_circle,
                      label: l10n.analyticsSessions,
                      value: '${data.totalSessions}',
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build7DayChart(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final silenceDataAsync = ref.watch(silenceDataNotifierProvider);

    return silenceDataAsync.when(
      data: (data) {
        // Get last 7 days of activity
        final last7Days = List.generate(7, (i) {
          final date = DateTime.now().subtract(Duration(days: 6 - i));
          final sessionsOnDay = data.recentSessions.where((s) {
            final sessionDate = s.date;
            return sessionDate.year == date.year &&
                sessionDate.month == date.month &&
                sessionDate.day == date.day &&
                s.completed;
          });
          final pointsOnDay = sessionsOnDay.fold<int>(
            0,
            (sum, session) => sum + (session.duration ~/ 60),
          );
          return pointsOnDay.toDouble();
        });

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.analyticsLast7Days,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 150,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (last7Days.reduce((a, b) => a > b ? a : b) * 1.2)
                          .clamp(10, double.infinity),
                      barGroups:
                          last7Days.asMap().entries.map((entry) {
                            return BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value,
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 20,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                              if (value.toInt() >= 0 &&
                                  value.toInt() < days.length) {
                                return Text(
                                  days[value.toInt()],
                                  style: Theme.of(context).textTheme.labelSmall,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildPerformanceHighlights(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final silenceDataAsync = ref.watch(silenceDataNotifierProvider);

    return silenceDataAsync.when(
      data: (data) {
        final completedSessions =
            data.recentSessions.where((s) => s.completed).length;
        final totalSessions = data.recentSessions.length;
        final successRate =
            totalSessions > 0
                ? ((completedSessions / totalSessions) * 100).toInt()
                : 0;

        final avgDuration =
            completedSessions > 0
                ? data.recentSessions
                        .where((s) => s.completed)
                        .fold<int>(0, (sum, s) => sum + s.duration) ~/
                    completedSessions ~/
                    60
                : 0;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.analyticsPerformanceHighlights,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildHighlightRow(
                  context,
                  l10n.analyticsSuccessRate,
                  '$successRate%',
                  Icons.trending_up,
                ),
                const SizedBox(height: 12),
                _buildHighlightRow(
                  context,
                  l10n.analyticsAvgSession,
                  '$avgDuration min',
                  Icons.timer,
                ),
                const SizedBox(height: 12),
                _buildHighlightRow(
                  context,
                  l10n.analyticsBestStreak,
                  '${data.bestStreak} days',
                  Icons.military_tech,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildHighlightRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityProgress(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // TODO: Wire up real activity tracking provider when available.
    // Temporarily show placeholder to keep build green.
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.analyticsActivityProgress,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.analyticsComingSoon,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedMetrics(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.analyticsAdvancedMetrics,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.analyticsPremiumContent),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsChart(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.analytics30DayTrends,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(l10n.analyticsTrendsChart),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsights(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.analyticsAIInsights,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.analyticsAIComingSoon),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumUpsell(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          showPaywall(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.lock_outline,
                size: 48,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.analyticsUnlock,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Get detailed metrics, 30-day trends, and AI-powered insights',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  showPaywall(context);
                },
                icon: const Icon(Icons.upgrade),
                label: const Text('Upgrade to Premium'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
