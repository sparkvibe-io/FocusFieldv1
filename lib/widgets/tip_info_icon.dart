import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:focus_field/providers/accessibility_provider.dart';
import 'package:focus_field/services/accessibility_service.dart';

class TipInfoIcon extends HookConsumerWidget {
  final VoidCallback onTap;
  final bool hasNewTips;
  final bool isEnabled;

  const TipInfoIcon({
    super.key,
    required this.onTap,
    required this.hasNewTips,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return IconButton(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Stack(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color:
                  isEnabled
                      ? (hasNewTips
                          ? Colors.amber.shade600
                          : theme.colorScheme.onSurface)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            if (hasNewTips && isEnabled)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
      onPressed:
          isEnabled
              ? () {
                ref
                    .read(accessibilityServiceProvider)
                    .vibrateOnEvent(AccessibilityEvent.buttonPress);
                onTap();
              }
              : null,
      tooltip: l10n?.tipInfoTooltip ?? 'Show tip',
    );
  }
}

class TipInfoIconWithAnimation extends HookConsumerWidget {
  final VoidCallback onTap;
  final bool hasNewTips;
  final bool isEnabled;

  const TipInfoIconWithAnimation({
    super.key,
    required this.onTap,
    required this.hasNewTips,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    // Create animation controller with slower, more gentle animation
    final animationController = useAnimationController(
      duration: const Duration(seconds: 3),
    );

    // Start/stop animation based on hasNewTips
    useEffect(() {
      if (hasNewTips && isEnabled) {
        animationController.repeat(reverse: true);
      } else {
        animationController.stop();
        animationController.reset();
      }
      return null;
    }, [hasNewTips, isEnabled]);

    return IconButton(
      icon: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Stack(
            children: [
              // Glow effect background - subtle and theme-adaptive
              if (hasNewTips && isEnabled)
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber.withValues(
                    alpha: 0.2 * (0.5 + 0.5 * animationController.value),
                  ),
                  size: 26, // Slightly larger for glow effect
                ),
              // Main lightbulb icon
              Icon(
                Icons.lightbulb_outline,
                color:
                    isEnabled
                        ? (hasNewTips
                            ? Color.lerp(
                              Colors.amber.shade600,
                              Colors.amber.shade400,
                              animationController.value,
                            )
                            : theme.colorScheme.onSurface)
                        : theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              if (hasNewTips && isEnabled)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color.lerp(
                        theme.colorScheme.error,
                        theme.colorScheme.error.withValues(alpha: 0.5),
                        animationController.value,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      onPressed:
          isEnabled
              ? () {
                ref
                    .read(accessibilityServiceProvider)
                    .vibrateOnEvent(AccessibilityEvent.buttonPress);
                onTap();
              }
              : null,
      tooltip: l10n?.tipInfoTooltip ?? 'Show tip',
    );
  }
}
