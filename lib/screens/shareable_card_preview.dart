import 'package:flutter/material.dart';
import 'package:focus_field/widgets/shareable_cards.dart';
import 'package:focus_field/widgets/share_button.dart';
import 'package:focus_field/services/share_service.dart';
import 'package:focus_field/l10n/app_localizations.dart';

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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.title ?? l10n.shareCardTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ShareButton(
            cardKey: _cardKey,
            filename: widget.filename,
            shareText: widget.shareText,
            subject: widget.subject,
            isCompact: true,
            color: theme.colorScheme.onSurface,
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
    final l10n = AppLocalizations.of(context)!;
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
                l10n.shareYourWeek,
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
            title: l10n.shareStyleGradient,
            description: l10n.shareStyleGradientDesc,
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
                    title: l10n.shareWeeklySummary,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          _buildCardOption(
            context,
            title: l10n.shareStyleAchievement,
            description: l10n.shareStyleAchievementDesc,
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
                      achievement: l10n.shareQuietMinutesWeek,
                      message: l10n.shareAchievementMessage,
                    ),
                    filename: 'focus_field_achievement_${DateTime.now().millisecondsSinceEpoch}',
                    shareText: ShareService.instance.generateAchievementText(
                      achievement: 'I earned $totalMinutes quiet minutes this week',
                      value: totalMinutes,
                    ),
                    title: l10n.shareAchievementCard,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Text-only option
          _buildCardOption(
            context,
            title: l10n.shareTextOnly,
            description: l10n.shareTextOnlyDesc,
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
  final l10n = AppLocalizations.of(context)!;
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
                l10n.shareYourStreak,
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
            title: Text(l10n.shareAsCard),
            subtitle: Text(l10n.shareAsCardDesc),
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
                    title: l10n.shareStreakCard,
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
            title: Text(l10n.shareAsText),
            subtitle: Text(l10n.shareAsTextDesc),
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
