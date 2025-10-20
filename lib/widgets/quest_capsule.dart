import 'package:flutter/material.dart';
import 'package:focus_field/theme/theme_extensions.dart';
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

    // HERO ELEMENT: Prominent call-to-action card
    // Darker than surroundings in light theme; lighter in dark theme
  final backgroundDecoration = context.ctaCardDecoration;
  // Choose a readable on-color against our darker/lighter CTA background
  // onInverseSurface often works well for prominent cards, but when the theme
  // is light we prefer a slightly darker text to match the reference.
  final bool isDark = theme.brightness == Brightness.dark;
  final foregroundOnCTA = isDark
    ? theme.colorScheme.onSurface // bright text in dark theme CTA
    : theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: backgroundDecoration,
      child: Column(
        children: [
          // Main row: Message + indicators + button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Trophy motivational icon - clean without glow
              Container(
                width: context.iconSize * 2,
                height: context.iconSize * 2,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.08),
                  ),
                ),
                child: Icon(
                  Icons.emoji_events,
                  size: context.iconSize + 2,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              // Simple message text with high contrast
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: foregroundOnCTA,
                    height: 1.25,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(width: 12),
              // Prominent Go button matching sample design
              Material(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                elevation: 2,
                shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.2),
                child: InkWell(
                  onTap: onNavigateToActivity,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      'Go',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimary,
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
