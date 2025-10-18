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

    // HERO ELEMENT: Bold inverse contrast backgrounds with excellent text visibility
    final isDark = theme.brightness == Brightness.dark;

    // Call-to-action colors: lighter in dark mode, darker in light mode
    final backgroundDecoration = isDark
        ? BoxDecoration(
            // Lighter gradient in dark mode (stands out from darker widgets)
            gradient: LinearGradient(
              colors: [
                const Color(0xFF3D5A5A), // Lighter teal-gray
                const Color(0xFF4A6868), // Even lighter
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          )
        : BoxDecoration(
            // Darker solid color in light mode (like sample image)
            color: const Color(0xFF546E7A), // Medium-dark blue-gray
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          );

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
                  color: isDark
                      ? const Color(0xFF5A7070) // Lighter background in dark mode
                      : const Color(0xFF78909C), // Medium gray-blue in light mode
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events,
                  size: context.iconSize + 2,
                  color: const Color(0xFFFFD700), // Bright gold trophy
                ),
              ),
              const SizedBox(width: 16),
              // Simple message text with high contrast
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // Always white for high contrast
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(width: 12),
              // Prominent Go button matching sample design
              Material(
                color: isDark
                    ? const Color(0xFF607D8B) // Medium gray in dark mode
                    : const Color(0xFFECEFF1), // Very light gray in light mode
                borderRadius: BorderRadius.circular(12),
                elevation: 2,
                shadowColor: Colors.black.withValues(alpha: 0.2),
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
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF37474F), // Dark text on light button
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
