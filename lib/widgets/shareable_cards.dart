import 'package:flutter/material.dart';

/// Card format options for sharing
enum ShareCardFormat {
  square(1080, 1080, 'Square'),     // 1:1 - Universal
  post(1080, 1350, 'Post'),         // 4:5 - Instagram/Twitter posts
  story(1080, 1920, 'Story');       // 9:16 - Instagram Stories

  const ShareCardFormat(this.width, this.height, this.label);
  final double width;
  final double height;
  final String label;
}

/// Collection of beautifully designed shareable cards for social media.
/// Cards support multiple format sizes (Square, Post, Story).
/// 
/// Usage:
/// 1. Wrap card in RepaintBoundary with GlobalKey
/// 2. Use ShareService.shareWidget() to capture and share
/// 
/// Example:
/// ```dart
/// final _cardKey = GlobalKey();
/// RepaintBoundary(
///   key: _cardKey,
///   child: WeeklySummaryCard(...),
/// )
/// await ShareService.instance.shareWidget(key: _cardKey, filename: 'my_week');
/// ```

/// Weekly summary card with gradient background and stats breakdown.
/// 
/// Displays:
/// - Total quiet minutes
/// - Session count
/// - Success rate
/// - Top activity
/// - Week date range
class WeeklySummaryCard extends StatelessWidget {
  final int totalMinutes;
  final int sessionCount;
  final double successRate;
  final String topActivity;
  final String weekRange; // e.g., "Oct 7-13, 2025"
  final Color primaryColor;
  final Color secondaryColor;
  final ShareCardFormat format;

  const WeeklySummaryCard({
    super.key,
    required this.totalMinutes,
    required this.sessionCount,
    required this.successRate,
    required this.topActivity,
    required this.weekRange,
    this.primaryColor = const Color(0xFF6366F1), // Indigo
    this.secondaryColor = const Color(0xFF8B5CF6), // Purple
    this.format = ShareCardFormat.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: format.width,
      height: format.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, secondaryColor],
        ),
      ),
      child: SafeArea(
        minimum: const EdgeInsets.all(40.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              
              // Main stat - hero number
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  totalMinutes.toString(),
                  style: const TextStyle(
                    fontSize: 160,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 0.9,
                    letterSpacing: -4,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'QUIET MINUTES',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Secondary stats
              _buildStatRow(
                icon: Icons.format_list_numbered,
                label: 'Sessions',
                value: sessionCount.toString(),
              ),
              const SizedBox(height: 28),
              _buildStatRow(
                icon: Icons.check_circle,
                label: 'Success Rate',
                value: '${successRate.toStringAsFixed(0)}%',
              ),
              const SizedBox(height: 28),
              _buildStatRow(
                icon: Icons.star,
                label: 'Top Activity',
                value: topActivity,
              ),
              
              const Spacer(flex: 2),
              
              // Footer
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    weekRange.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Focus Field',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Achievement card for celebrating milestones.
/// Large number with motivational message.
class AchievementCard extends StatelessWidget {
  final int value;
  final String unit; // e.g., "minutes", "sessions", "days"
  final String achievement; // e.g., "Quiet Minutes Earned"
  final String message; // e.g., "Building deeper focus"
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;
  final ShareCardFormat format;

  const AchievementCard({
    super.key,
    required this.value,
    required this.unit,
    required this.achievement,
    required this.message,
    this.icon = Icons.emoji_events,
    this.backgroundColor = const Color(0xFF1E1E2E),
    this.accentColor = const Color(0xFFB0FC38),
    this.format = ShareCardFormat.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: format.width,
      height: format.height,
      color: backgroundColor,
      child: SafeArea(
        minimum: const EdgeInsets.all(40.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // Icon
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 70,
                  color: accentColor,
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Hero number
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 180,
                        fontWeight: FontWeight.w900,
                        color: accentColor,
                        height: 0.9,
                        letterSpacing: -4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 35, left: 16),
                      child: Text(
                        unit,
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w600,
                          color: accentColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 35),
              
              // Achievement text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  achievement.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white60,
                    height: 1.4,
                  ),
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Footer
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.flash_on,
                      color: accentColor,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Focus Field',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Streak card with fire emoji and days counter.
/// Celebrates consistency and daily practice.
class StreakCard extends StatelessWidget {
  final int streakDays;
  final String streakType; // e.g., "Daily Focus", "Weekly Practice"
  final Color backgroundColor;
  final Color accentColor;

  const StreakCard({
    super.key,
    required this.streakDays,
    this.streakType = 'Daily Focus',
    this.backgroundColor = const Color(0xFF0F0F1E),
    this.accentColor = const Color(0xFFFF6B35),
  });

  @override
  Widget build(BuildContext context) {
    final emoji = _getStreakEmoji(streakDays);
    
    return Container(
      width: 1080,
      height: 1920,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor,
            backgroundColor.withValues(red: 0.2, green: 0.1, blue: 0.1),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Streak emoji
              Text(
                emoji,
                style: const TextStyle(fontSize: 200),
              ),
              
              const SizedBox(height: 40),
              
              // Days counter
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    streakDays.toString(),
                    style: TextStyle(
                      fontSize: 180,
                      fontWeight: FontWeight.w900,
                      color: accentColor,
                      height: 0.9,
                      letterSpacing: -4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30, left: 16),
                    child: Text(
                      'DAYS',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: accentColor.withValues(alpha: 0.7),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Streak type
              Text(
                '$streakType STREAK',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Motivational message
              Text(
                _getStreakMessage(streakDays),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white60,
                  height: 1.4,
                ),
              ),
              
              const Spacer(),
              
              // Progress indicator
              Column(
                children: [
                  Text(
                    'CONSISTENCY IS KEY',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: accentColor.withValues(alpha: 0.8),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 32,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Focus Field',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStreakEmoji(int days) {
    if (days >= 100) return '💎'; // Diamond - legendary
    if (days >= 50) return '👑'; // Crown - king
    if (days >= 30) return '🏆'; // Trophy - champion
    if (days >= 14) return '🔥'; // Fire - hot streak
    if (days >= 7) return '⚡'; // Lightning - powered up
    return '✨'; // Sparkles - getting started
  }

  String _getStreakMessage(int days) {
    if (days >= 100) {
      return 'Legendary dedication!\nYou\'re an inspiration.';
    } else if (days >= 50) {
      return 'Incredible consistency!\nYou\'re crushing it.';
    } else if (days >= 30) {
      return 'One month strong!\nThe habit is locked in.';
    } else if (days >= 14) {
      return 'Two weeks of focus!\nYou\'re building something great.';
    } else if (days >= 7) {
      return 'One week down!\nMomentum is building.';
    } else {
      return 'Every journey starts\nwith a single step.';
    }
  }
}

/// Activity rings card showing circular progress for multiple activities.
/// Similar to Apple Fitness rings but for focus activities.
class ActivityRingsCard extends StatelessWidget {
  final Map<String, double> activityProgress; // activity name -> progress (0-1)
  final int totalMinutes;
  final String dateRange;
  final Color backgroundColor;

  const ActivityRingsCard({
    super.key,
    required this.activityProgress,
    required this.totalMinutes,
    required this.dateRange,
    this.backgroundColor = const Color(0xFF000000),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1080,
      height: 1920,
      color: backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Title
              const Text(
                'ACTIVITY RINGS',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70,
                  letterSpacing: 3,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Rings visualization
              SizedBox(
                width: 600,
                height: 600,
                child: CustomPaint(
                  painter: _ActivityRingsPainter(activityProgress),
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Total minutes
              Column(
                children: [
                  Text(
                    totalMinutes.toString(),
                    style: const TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 0.9,
                    ),
                  ),
                  const Text(
                    'TOTAL MINUTES',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white60,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Activity legend
              ..._buildActivityLegend(),
              
              const Spacer(),
              
              // Footer
              Column(
                children: [
                  Text(
                    dateRange.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white60,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 32,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Focus Field',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActivityLegend() {
    final colors = _getActivityColors();
    return activityProgress.entries.map((entry) {
      final color = colors[entry.key] ?? Colors.grey;
      final percentage = (entry.value * 100).toStringAsFixed(0);
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 180,
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Map<String, Color> _getActivityColors() {
    return {
      'Study': const Color(0xFF8B9DC3),
      'Reading': const Color(0xFF7BA7BC),
      'Meditation': const Color(0xFF86B489),
      'Work': const Color(0xFFC6927E),
      'Other': const Color(0xFFC4A57B),
    };
  }
}

/// Custom painter for activity rings (concentric circles showing progress).
class _ActivityRingsPainter extends CustomPainter {
  final Map<String, double> activityProgress;

  _ActivityRingsPainter(this.activityProgress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final colors = _getActivityColors();
    final sortedActivities = activityProgress.keys.toList();
    
    // Draw rings from outside to inside
    for (var i = 0; i < sortedActivities.length; i++) {
      final activity = sortedActivities[i];
      final progress = activityProgress[activity] ?? 0.0;
      final color = colors[activity] ?? Colors.grey;
      final ringRadius = (size.width / 2) - (i * 80) - 40;
      
      // Background ring (faded)
      final bgPaint = Paint()
        ..color = color.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 40
        ..strokeCap = StrokeCap.round;
      
      canvas.drawCircle(center, ringRadius, bgPaint);
      
      // Progress ring
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 40
        ..strokeCap = StrokeCap.round;
      
      final rect = Rect.fromCircle(center: center, radius: ringRadius);
      final startAngle = -90 * (3.14159 / 180); // Start at top
      final sweepAngle = progress * 2 * 3.14159; // Full circle = 360°
      
      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(_ActivityRingsPainter oldDelegate) =>
      activityProgress != oldDelegate.activityProgress;

  Map<String, Color> _getActivityColors() {
    return {
      'Study': const Color(0xFF8B9DC3),
      'Reading': const Color(0xFF7BA7BC),
      'Meditation': const Color(0xFF86B489),
      'Work': const Color(0xFFC6927E),
      'Other': const Color(0xFFC4A57B),
    };
  }
}

/// Minimal, elegant progress card for daily or weekly sharing.
/// Professional design with subtle colors and generous whitespace.
///
/// Perfect for:
/// - Daily progress updates
/// - Weekly summaries
/// - Professional/work context sharing
class MinimalProgressCard extends StatelessWidget {
  final int totalMinutes;
  final int sessionCount;
  final double successRate;
  final Map<String, int>? activityMinutes; // Map of activity name -> minutes
  final String timeRange; // e.g., "Today" or "Oct 7-13, 2025"
  final String title; // e.g., "Today's Focus" or "Your Weekly Focus"
  final ShareCardFormat format;

  const MinimalProgressCard({
    super.key,
    required this.totalMinutes,
    required this.sessionCount,
    required this.successRate,
    this.activityMinutes,
    required this.timeRange,
    required this.title,
    this.format = ShareCardFormat.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: format.width,
      height: format.height,
      color: const Color(0xFFFAFAFA), // Off-white background
      child: SafeArea(
        minimum: const EdgeInsets.all(40.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: 0.5,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Hero number with unit
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children: [
                    Text(
                      totalMinutes.toString(),
                      style: const TextStyle(
                        fontSize: 140,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6366F1), // Brand indigo
                        height: 1.0,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'minutes',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6366F1).withValues(alpha: 0.6),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Stats grid
              _buildStatsGrid(),
              
              const Spacer(),
              
              // Time range
              Text(
                timeRange,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280), // Gray
                  letterSpacing: 0.5,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Branding
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.flash_on,
                      color: Color(0xFF6366F1),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Focus Field',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = <Widget>[];

    if (sessionCount > 0) {
      stats.add(_StatItem(
        icon: Icons.format_list_numbered_outlined,
        label: 'Sessions',
        value: sessionCount.toString(),
      ));
    }

    if (successRate > 0) {
      stats.add(_StatItem(
        icon: Icons.check_circle_outline,
        label: 'Success',
        value: '${successRate.toStringAsFixed(0)}%',
      ));
    }

    return Column(
      children: [
        // Stats grid (Sessions and Success)
        Wrap(
          spacing: 40,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: stats,
        ),

        // Activity breakdown (if activities exist)
        if (activityMinutes != null && activityMinutes!.isNotEmpty)
          ...[
            const SizedBox(height: 32),
            _buildActivityBreakdown(),
          ],
      ],
    );
  }

  Widget _buildActivityBreakdown() {
    // Filter and sort activities by minutes (descending)
    final activities = activityMinutes!.entries
        .where((entry) => entry.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (activities.isEmpty) return const SizedBox.shrink();

    final topActivity = activities.first;

    return Column(
      children: [
        // Row 1: Star icon + top activity name
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.star,
              color: Color(0xFFFFA000), // Amber for star
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              topActivity.key,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Row 2: Individual activity icons with minutes
        Wrap(
          spacing: 20,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: activities.map((entry) {
            return _buildActivityChip(entry.key, entry.value);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActivityChip(String activityName, int minutes) {
    // Map activity names to Material icons
    IconData icon;
    Color color;

    switch (activityName.toLowerCase()) {
      case 'study':
        icon = Icons.school_outlined;
        color = const Color(0xFF8B9DC3);
        break;
      case 'reading':
        icon = Icons.menu_book_outlined;
        color = const Color(0xFF7BA7BC);
        break;
      case 'meditation':
        icon = Icons.self_improvement_outlined;
        color = const Color(0xFF86B489);
        break;
      case 'work':
        icon = Icons.work_outline;
        color = const Color(0xFFC6927E);
        break;
      default:
        icon = Icons.more_horiz;
        color = const Color(0xFFC4A57B);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            activityName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${minutes}m',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: const Color(0xFF6B7280),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9CA3AF),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
