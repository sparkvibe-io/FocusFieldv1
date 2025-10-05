import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/silence_provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/progress_ring.dart';
import '../widgets/banner_ad_footer.dart';

/// Refined home screen with two tabs: Overview/Analytics and Activity
/// Features rocket mission theme with original progress ring design
class HomePageRefined extends ConsumerStatefulWidget {
  const HomePageRefined({super.key});

  @override
  ConsumerState<HomePageRefined> createState() => _HomePageRefinedState();
}

class _HomePageRefinedState extends ConsumerState<HomePageRefined>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Focus Field'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tips_and_updates_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Activity chips (horizontal scroll)
          _buildActivityChips(context),

          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: theme.colorScheme.onPrimaryContainer,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(
                  icon: Icon(Icons.insights_outlined),
                  text: 'Overview',
                ),
                Tab(
                  icon: Icon(Icons.power_settings_new),
                  text: 'Activity',
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(context),
                _buildActivityTab(context),
              ],
            ),
          ),

          // Advertisement (always visible)
          const FooterBannerAd(),
        ],
      ),
    );
  }

  Widget _buildActivityChips(BuildContext context) {
    final theme = Theme.of(context);
    final activityState = ref.watch(activityTrackingProvider);

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: activityState.trackedActivities.length,
        itemBuilder: (context, index) {
          final activity = activityState.trackedActivities[index];
          final isSelected = activity.type.key == activityState.selectedActivity;

          return GestureDetector(
            onTap: () => ref
                .read(activityTrackingProvider.notifier)
                .selectActivity(activity.type.key),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  if (isSelected) const SizedBox(width: 4),
                  Text(
                    activity.type.icon,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    activity.type.key,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    final theme = Theme.of(context);
    final silenceDataAsync = ref.watch(silenceDataNotifierProvider);

    return silenceDataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (data) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Rocket mission capsule
                _buildRocketMissionCapsule(context, data),

                const SizedBox(height: 16),

                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        '${data.totalPoints}',
                        'Points',
                        Icons.stars,
                        theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        '${data.currentStreak}',
                        'Streak',
                        Icons.local_fire_department,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        '${data.totalSessions}',
                        'Sessions',
                        Icons.play_circle_outline,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 7-day activity chart
                _buildWeekChart(context, data),

                const SizedBox(height: 16),

                // Noise level (conditional)
                _buildNoiseLevelCard(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityTab(BuildContext context) {
    final silenceState = ref.watch(silenceStateProvider);
    final sessionDuration = ref.watch(sessionDurationProvider);
    final isListening = silenceState.isListening;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Duration selector
          _buildDurationSelector(context),

          const SizedBox(height: 24),

          // Original progress ring with timer
          Expanded(
            child: Center(
              child: ProgressRing(
                progress: silenceState.progress,
                isListening: isListening,
                size: 280,
                strokeWidth: 20,
                onTap: () {
                  // TODO: Wire to proper session start/stop handlers
                  // For now, just toggle the listening state
                  ref.read(silenceStateProvider.notifier).setListening(!isListening);
                },
                sessionDurationSeconds: sessionDuration * 60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRocketMissionCapsule(BuildContext context, dynamic data) {
    final theme = Theme.of(context);

    // Calculate mission stage based on days (placeholder logic)
    final daysInMission = data.currentStreak; // Using streak as proxy
    final totalDays = 30;
    final progress = (daysInMission / totalDays).clamp(0.0, 1.0);
    final microSessions = data.totalSessions; // Using total sessions as proxy

    String stage = 'Ignition';
    String emoji = '🔥';
    if (daysInMission >= 25) {
      stage = 'Orbit';
      emoji = '🌟';
    } else if (daysInMission >= 15) {
      stage = 'Stage Separation';
      emoji = '⚡';
    } else if (daysInMission >= 8) {
      stage = 'Lift-off';
      emoji = '🚀';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Rocket icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '🚀',
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Mission info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      stage,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Days remaining: ${totalDays - daysInMission} · $microSessions/20 micro‑focus sessions',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
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

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
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
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekChart(BuildContext context, dynamic data) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Last 7 Days',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Simple bar visualization
              Row(
                children: List.generate(7, (index) {
                  final height = (20 + (index * 5.0)).clamp(10.0, 40.0);
                  return Container(
                    width: 6,
                    height: height,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return Text(
                day,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoiseLevelCard(BuildContext context) {
    final theme = Theme.of(context);
    final activityState = ref.watch(activityTrackingProvider);
    final selectedActivityKey = activityState.selectedActivity;
    final selectedActivityType = ActivityType.fromKey(selectedActivityKey);

    // Only show for silence-required activities
    if (!selectedActivityType.requiresSilence) {
      return const SizedBox.shrink();
    }

    // TODO: Wire real decibel data
    const currentDb = 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.graphic_eq_outlined,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Noise level',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${currentDb.toStringAsFixed(1)} dB',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSelector(BuildContext context) {
    final theme = Theme.of(context);
    final durations = [1, 5, 10, 15, 30];
    final selectedDuration = 1; // TODO: Wire to state

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: durations.map((duration) {
        final isSelected = duration == selectedDuration;
        return GestureDetector(
          onTap: () {
            // TODO: Update duration
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Text(
              duration == 1 ? '1' : '$duration',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
