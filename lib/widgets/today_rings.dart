import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/activity_provider.dart';
import 'package:focus_field/models/silence_data.dart';

/// Displays one-day progress rings for the user's selected categories.
/// Phase 1 definition: a category ring is 100% if the user completed at least
/// one micro-session (>=1 minute) today with that category; otherwise 0%.
class TodayRings extends ConsumerWidget {
  final SilenceData data;
  const TodayRings({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For Phase 1 we derive the category set from the current selected activity
    // plus a small preset. In the next step, this will come from onboarding.
    final selected = ref.watch(selectedActivityProvider);
    final categories = <String>{selected, ...activityTypes.take(3)}.toList();

    final today = DateTime.now();
    final dayStart = DateTime(today.year, today.month, today.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    bool hasMicroSession(String category) {
      return data.recentSessions.any((s) {
        final inDay = s.date.isAfter(dayStart) && s.date.isBefore(dayEnd);
        final isMicro = s.completed && s.duration >= 60 && s.duration <= 5 * 60;
        final matches = (s.activity ?? '') == category;
        return inDay && isMicro && matches;
      });
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final c in categories)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: _CategoryRing(
                category: c,
                completed: hasMicroSession(c),
                onTap: () => _showHistoryModal(context, c, data),
              ),
            ),
        ],
      ),
    );
  }

  void _showHistoryModal(BuildContext context, String category, SilenceData data) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$category • History', style: Theme.of(context).textTheme.titleMedium),
                      IconButton(
                        tooltip: 'Close',
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Minimal 7-day summary: filled/unfilled squares
                  Row(
                    children: _build7DaySummary(context, category, data),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _build7DaySummary(BuildContext context, String category, SilenceData data) {
    final now = DateTime.now();
    final items = <Widget>[];
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final ds = DateTime(day.year, day.month, day.day);
      final de = ds.add(const Duration(days: 1));
      final done = data.recentSessions.any((s) {
        final inDay = s.date.isAfter(ds) && s.date.isBefore(de);
        final isMicro = s.completed && s.duration >= 60 && s.duration <= 5 * 60;
        final matches = (s.activity ?? '') == category;
        return inDay && isMicro && matches;
      });
      items.add(Container(
        width: 14,
        height: 14,
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          color: done ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(4),
        ),
      ));
    }
    return items;
  }
}

class _CategoryRing extends StatelessWidget {
  final String category;
  final bool completed;
  final VoidCallback onTap;
  const _CategoryRing({required this.category, required this.completed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final radius = 26.0;
    final color = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: completed ? 1.0 : 0.0,
                  strokeWidth: 6,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.15),
                ),
                Icon(_iconFor(category), size: 20, color: color),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(category, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  IconData _iconFor(String c) {
    switch (c) {
      case 'studying':
        return Icons.school;
      case 'reading':
        return Icons.menu_book;
      case 'work':
        return Icons.work_outline;
      case 'meditation':
        return Icons.self_improvement;
      case 'family':
        return Icons.diversity_3;
      case 'fitness':
        return Icons.fitness_center;
      case 'noise':
        return Icons.graphic_eq;
      default:
        return Icons.circle_outlined;
    }
  }
}
