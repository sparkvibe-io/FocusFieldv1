import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/activity_chip.dart';
import '../widgets/rocket_mission_capsule.dart';
import '../widgets/analytics_button.dart';
import '../widgets/activity_noise_badge.dart';
import '../widgets/analytics_modal.dart';

/// Preview screen for new design components
/// This demonstrates all new widgets in the proposed layout
class NewDesignPreview extends ConsumerWidget {
  const NewDesignPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('New Design Preview'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Activity chips with progress rings (scrollable)
            const ActivityChipsRow(),

            // 2. Rocket mission capsule
            const RocketMissionCapsule(),

            // 3. Analytics button
            AnalyticsButton(
              onTap: () => AnalyticsModal.show(context),
            ),

            // 4. Activity-aware noise badge (only shows for silence activities)
            ActivityNoiseBadge(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Noise chart modal would open here'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Spacer to push progress ring to bottom
            const Spacer(),

            // 5. Placeholder for progress ring (existing widget)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '15:00',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 6. Placeholder for ad banner
            Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'Ad Banner (468x60)',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
