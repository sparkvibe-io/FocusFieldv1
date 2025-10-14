import 'package:flutter/material.dart';
import 'package:focus_field/widgets/shareable_cards.dart';
import 'package:focus_field/widgets/share_button.dart';
import 'package:focus_field/services/share_service.dart';

/// Screen that displays a shareable card in preview mode.
/// Users can see what they're about to share before sharing it.
/// 
/// Usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => ShareableCardPreview(
///       card: WeeklySummaryCard(...),
///       filename: 'my_week',
///       shareText: 'Check out my weekly focus stats!',
///     ),
///   ),
/// );
/// ```
class ShareableCardPreview extends StatefulWidget {
  final Widget card;
  final String filename;
  final String? shareText;
  final String? subject;
  final String? title;

  const ShareableCardPreview({
    super.key,
    required this.card,
    required this.filename,
    this.shareText,
    this.subject,
    this.title,
  });

  @override
  State<ShareableCardPreview> createState() => _ShareableCardPreviewState();
}

class _ShareableCardPreviewState extends State<ShareableCardPreview> {
  final GlobalKey _cardKey = GlobalKey();
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title ?? 'Share Card'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ShareButton(
            cardKey: _cardKey,
            filename: widget.filename,
            shareText: widget.shareText,
            subject: widget.subject,
            isCompact: true,
            color: Colors.white,
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.2,
          maxScale: 2.0,
          child: RepaintBoundary(
            key: _cardKey,
            child: widget.card,
          ),
        ),
      ),
      floatingActionButton: ShareFab(
        cardKey: _cardKey,
        filename: widget.filename,
        shareText: widget.shareText,
        subject: widget.subject,
      ),
    );
  }
}

/// Bottom sheet that shows share options for weekly summary.
/// Allows user to choose between different card styles.
class WeeklySummaryShareSheet extends StatelessWidget {
  final int totalMinutes;
  final int sessionCount;
  final double successRate;
  final String topActivity;
  final String weekRange;

  const WeeklySummaryShareSheet({
    super.key,
    required this.totalMinutes,
    required this.sessionCount,
    required this.successRate,
    required this.topActivity,
    required this.weekRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.share, size: 28),
              const SizedBox(width: 12),
              Text(
                'Share Your Week',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Card style options
          _buildCardOption(
            context,
            title: 'Gradient Style',
            description: 'Bold gradient with large numbers',
            icon: Icons.gradient,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShareableCardPreview(
                    card: WeeklySummaryCard(
                      totalMinutes: totalMinutes,
                      sessionCount: sessionCount,
                      successRate: successRate,
                      topActivity: topActivity,
                      weekRange: weekRange,
                    ),
                    filename: 'focus_field_week_${DateTime.now().millisecondsSinceEpoch}',
                    shareText: ShareService.instance.generateWeeklySummaryText(
                      totalMinutes: totalMinutes,
                      sessionCount: sessionCount,
                      successRate: successRate,
                    ),
                    title: 'Weekly Summary',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          _buildCardOption(
            context,
            title: 'Achievement Style',
            description: 'Focus on total quiet minutes',
            icon: Icons.emoji_events,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShareableCardPreview(
                    card: AchievementCard(
                      value: totalMinutes,
                      unit: 'minutes',
                      achievement: 'Quiet Minutes This Week',
                      message: 'Building deeper focus,\none session at a time',
                    ),
                    filename: 'focus_field_achievement_${DateTime.now().millisecondsSinceEpoch}',
                    shareText: ShareService.instance.generateAchievementText(
                      achievement: 'I earned $totalMinutes quiet minutes this week',
                      value: totalMinutes,
                    ),
                    title: 'Achievement Card',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Text-only option
          _buildCardOption(
            context,
            title: 'Text Only',
            description: 'Share as plain text (no image)',
            icon: Icons.text_fields,
            onTap: () async {
              Navigator.pop(context);
              final text = ShareService.instance.generateWeeklySummaryText(
                totalMinutes: totalMinutes,
                sessionCount: sessionCount,
                successRate: successRate,
              );
              await ShareService.instance.shareText(text: text);
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCardOption(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show weekly summary share sheet.
void showWeeklySummaryShare(
  BuildContext context, {
  required int totalMinutes,
  required int sessionCount,
  required double successRate,
  required String topActivity,
  required String weekRange,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => WeeklySummaryShareSheet(
      totalMinutes: totalMinutes,
      sessionCount: sessionCount,
      successRate: successRate,
      topActivity: topActivity,
      weekRange: weekRange,
    ),
  );
}

/// Helper function to show streak share options.
void showStreakShare(
  BuildContext context, {
  required int streakDays,
  String streakType = 'Daily Focus',
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.local_fire_department, size: 28),
              const SizedBox(width: 12),
              Text(
                'Share Your Streak',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Share as card
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.image,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: const Text('Share as Card'),
            subtitle: const Text('Beautiful visual card'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShareableCardPreview(
                    card: StreakCard(
                      streakDays: streakDays,
                      streakType: streakType,
                    ),
                    filename: 'focus_field_streak_${DateTime.now().millisecondsSinceEpoch}',
                    shareText: ShareService.instance.generateStreakText(
                      streakDays: streakDays,
                    ),
                    title: 'Streak Card',
                  ),
                ),
              );
            },
          ),
          const Divider(),

          // Share as text
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.text_fields,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            title: const Text('Share as Text'),
            subtitle: const Text('Simple text message'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              Navigator.pop(context);
              final text = ShareService.instance.generateStreakText(
                streakDays: streakDays,
              );
              await ShareService.instance.shareText(text: text);
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}
