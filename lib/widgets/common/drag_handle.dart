import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';

/// Reusable drag handle widget for bottom sheets
/// Ensures consistent styling across all bottom sheets in the app
class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: Spacing.sm),
      width: UIConstants.dragHandleWidth,
      height: UIConstants.dragHandleHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
