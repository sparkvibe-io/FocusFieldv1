import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Compact decibel threshold selector for the noise level widget
class QuickDecibelSelector extends ConsumerWidget {
  final List<double> thresholds;
  final double selectedThreshold;
  final Function(double) onThresholdSelected;
  final bool enabled;

  const QuickDecibelSelector({
    super.key,
    required this.thresholds,
    required this.selectedThreshold,
    required this.onThresholdSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: thresholds.asMap().entries.map((entry) {
        final index = entry.key;
        final threshold = entry.value;

        return Padding(
          padding: EdgeInsets.only(
            left: index > 0 ? 3.0 : 0, // Minimal spacing between buttons
          ),
          child: _buildThresholdChip(context, theme, threshold),
        );
      }).toList(),
    );
  }

  Widget _buildThresholdChip(BuildContext context, ThemeData theme, double threshold) {
    final isSelected = (selectedThreshold - threshold).abs() < 0.1; // Handle double precision

    return GestureDetector(
      onTap: enabled ? () => onThresholdSelected(threshold) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), // Very compact
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8), // Small radius for compact design
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 3,
                    spreadRadius: 0.5,
                  ),
                ]
              : null,
        ),
        child: Text(
          threshold.round().toString(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 11, // Small font for compact design
          ),
        ),
      ),
    );
  }
}