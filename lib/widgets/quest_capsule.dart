import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/ambient_quest_provider.dart';
import 'package:focus_field/utils/responsive_utils.dart';

/// Motivational daily message card with subtle progress indicators
/// Rotating inspirational messages to encourage users and build confidence
class QuestCapsule extends ConsumerWidget {
  final VoidCallback? onNavigateToActivity;

  const QuestCapsule({super.key, this.onNavigateToActivity});

  /// Extensible list of motivational messages
  /// Add new messages here - they will automatically rotate
  static const List<String> motivationalMessages = [
    'Success is never ending and failure is never final',
    'Progress over perfection - every minute counts',
    'Small steps daily lead to big changes',
    'You\'re building better habits, one session at a time',
    'Consistency beats intensity',
    'Every session is a win, no matter how short',
    'Focus is a muscle - you\'re getting stronger',
    'The journey of a thousand miles begins with a single step',
  ];

  /// Get rotating message
  /// Production: changes once per day
  /// Development: changes every hour for easier testing
  String _getDailyMessage() {
    final now = DateTime.now();

    if (kDebugMode) {
      // Development: change every hour
      final seed = now.day * 24 + now.hour;
      return motivationalMessages[seed % motivationalMessages.length];
    } else {
      // Production: change once per day
      final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
      return motivationalMessages[dayOfYear % motivationalMessages.length];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final questState = ref.watch(questStateProvider);

    if (questState == null) {
      return const SizedBox.shrink();
    }

    final message = _getDailyMessage();

    // Inverse background: lighter in dark mode, darker in light mode
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.9)
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Main row: Message + indicators + button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Trophy motivational icon
              Container(
                width: context.iconSize * 2,
                height: context.iconSize * 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events,
                  size: context.iconSize + 2,
                  color: const Color(0xFFFFD700),
                ),
              ),
              const SizedBox(width: 16),
              // Simple message text
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.95)
                        : Colors.black.withValues(alpha: 0.85),
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(width: 12),
              // Go button
              Material(
                color: theme.brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: onNavigateToActivity,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      'Go',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black.withValues(alpha: 0.8),
                      ),
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
}
