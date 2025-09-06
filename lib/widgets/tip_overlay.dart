import 'package:flutter/material.dart';
import 'package:silence_score/l10n/app_localizations.dart';

class TipOverlay extends StatelessWidget {
  final String text;
  final String? instructions;
  final bool isPremium;
  final bool isEnabled;
  final VoidCallback onClose;
  final VoidCallback onMute;
  const TipOverlay({
    super.key,
    required this.text,
    this.instructions,
    this.isPremium = false,
    this.isEnabled = true,
    required this.onClose,
    required this.onMute,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  final l10n = AppLocalizations.of(context);
  final bg = theme.colorScheme.surface.withOpacity(0.98);
    final border = theme.colorScheme.outline.withOpacity(0.25);
    return Positioned.fill(
      child: SafeArea(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              constraints: const BoxConstraints(maxWidth: 560),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.14),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        size: 24,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n?.tipsTitle ?? 'Tips',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: onClose,
                        tooltip: 'Close',
                        iconSize: 22,
                      ),
                    ],
                  ),
                  if (isPremium)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          label: Text(
                            l10n?.premiumBadge ?? 'PREMIUM',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    text,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                  if (instructions != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      instructions!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: onMute,
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurfaceVariant,
                          textStyle: theme.textTheme.bodySmall,
                        ),
                        child: Text(isEnabled 
                            ? (l10n?.hideTips ?? 'Hide Tips')
                            : (l10n?.showTips ?? 'Show Tips')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
