// ignore_for_file: unused_local_variable, dead_code, unused_import, always_use_package_imports
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;
import '../providers/silence_provider.dart';
import '../providers/activity_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
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
    final dayName = _getDayName(now.weekday);
    final monthName = _getMonthName(now.month);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$dayName, ${monthName.toUpperCase()} ${now.day}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentTab == 0 ? 'Summary' : 'Activity',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.settings_outlined,
                    color: theme.colorScheme.onSurfaceVariant),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 8),
        _buildActivityRingsCard(context),
        const SizedBox(height: 20),
        _buildTodaysMissionCard(context),
        const SizedBox(height: 20),
        _buildQuickStatsCard(context),
        const SizedBox(height: 20),
        _buildTrendsCard(context),
      ],
    );
  }

  Widget _buildActivityTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 8),
        _buildActivitySelectorCard(context),
        const SizedBox(height: 20),
        _buildSessionControlCard(context),
        const SizedBox(height: 20),
        _buildRecentSessionsCard(context),
      ],
    );
  }

  Widget _buildActivityRingsCard(BuildContext context) {
    final theme = Theme.of(context);
    final silenceDataAsync = ref.watch(silenceDataNotifierProvider);

    return silenceDataAsync.when(
      data: (data) {
        final focusProgress = (data.totalPoints / 100).clamp(0.0, 1.0);
        final streakProgress = (data.currentStreak / 7).clamp(0.0, 1.0);
        final sessionsProgress = (data.totalSessions / 20).clamp(0.0, 1.0);

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Activity',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // Activity rings
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CustomPaint(
                      painter: _ActivityRingsPainter(
                        focusProgress: focusProgress,
                        streakProgress: streakProgress,
                        sessionsProgress: sessionsProgress,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Stats
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRingLegend(
                          context,
                          'Focus',
                          '${data.totalPoints}/100 MIN',
                          const Color(0xFFFA114F),
                          focusProgress,
                        ),
                        const SizedBox(height: 16),
                        _buildRingLegend(
                          context,
                          'Streak',
                          '${data.currentStreak}/7 DAYS',
                          const Color(0xFFB0FC38),
                          streakProgress,
                        ),
                        const SizedBox(height: 16),
                        _buildRingLegend(
                          context,
                          'Sessions',
                          '${data.totalSessions}/20',
                          const Color(0xFF00D9FF),
                          sessionsProgress,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.8),
            theme.colorScheme.tertiary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.rocket_launch,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Mission',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete 15 minutes of quiet focus',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard(BuildContext context) {
    final theme = Theme.of(context);
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
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
                onPressed: () {},
                child: const Text('Show More'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTrendItem(context, 'Focus Time', '29 MIN/DAY', true, const Color(0xFFB0FC38)),
          const SizedBox(height: 12),
          _buildTrendItem(context, 'Sessions', '4/WEEK', true, const Color(0xFF00D9FF)),
          const SizedBox(height: 12),
          _buildTrendItem(context, 'Average', '7 MIN', false, const Color(0xFFFA114F)),
        ],
      ),
    );
  }

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

  Widget _buildActivitySelectorCard(BuildContext context) {
    final theme = Theme.of(context);
    final activityState = ref.watch(activityTrackingProvider);

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
            'Select Activity',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: activityState.trackedActivities.map((activity) {
              final isSelected = activityState.selectedActivity == activity.type.key;
              return _buildActivityChip(
                context,
                activity.type.icon,
                activity.type.key,
                isSelected,
                activity.progress,
                () => ref.read(activityTrackingProvider.notifier).selectActivity(activity.type.key),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChip(
    BuildContext context,
    String emoji,
    String label,
    bool isSelected,
    double progress,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.2)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
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
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
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

  Widget _buildSessionControlCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
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
      ),
      child: Column(
        children: [
          // Duration selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDurationChip(context, '5', false),
              _buildDurationChip(context, '10', false),
              _buildDurationChip(context, '15', true),
              _buildDurationChip(context, '30', false),
              _buildDurationChip(context, '60', false),
            ],
          ),
          const SizedBox(height: 24),
          // Big start button
          SizedBox(
            width: 180,
            height: 180,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: const CircleBorder(),
                elevation: 8,
                shadowColor: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow_rounded, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    '15:00',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationChip(BuildContext context, String minutes, bool isSelected) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${minutes}m',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: isSelected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
      ),
    );
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
