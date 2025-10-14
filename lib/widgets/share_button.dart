import 'package:flutter/material.dart';
import 'package:focus_field/services/share_service.dart';

/// Reusable share button that triggers card sharing.
/// Shows loading state during capture and handles errors gracefully.
class ShareButton extends StatefulWidget {
  final GlobalKey cardKey;
  final String filename;
  final String? shareText;
  final String? subject;
  final IconData icon;
  final String label;
  final Color? color;
  final bool isCompact;

  const ShareButton({
    super.key,
    required this.cardKey,
    required this.filename,
    this.shareText,
    this.subject,
    this.icon = Icons.share,
    this.label = 'Share',
    this.color,
    this.isCompact = false,
  });

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  bool _isSharing = false;

  Future<void> _handleShare() async {
    if (_isSharing) return;

    setState(() => _isSharing = true);

    try {
      final success = await ShareService.instance.shareWidget(
        key: widget.cardKey,
        filename: widget.filename,
        text: widget.shareText,
        subject: widget.subject,
      );

      if (mounted) {
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to share. Please try again.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = widget.color ?? theme.colorScheme.primary;

    if (widget.isCompact) {
      return IconButton(
        onPressed: _isSharing ? null : _handleShare,
        icon: _isSharing
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: effectiveColor,
                ),
              )
            : Icon(widget.icon),
        color: effectiveColor,
        tooltip: widget.label,
      );
    }

    return ElevatedButton.icon(
      onPressed: _isSharing ? null : _handleShare,
      icon: _isSharing
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onPrimary,
              ),
            )
          : Icon(widget.icon),
      label: Text(widget.label),
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveColor,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}

/// Floating action button variant for sharing.
/// Appears prominently on card preview screens.
class ShareFab extends StatefulWidget {
  final GlobalKey cardKey;
  final String filename;
  final String? shareText;
  final String? subject;

  const ShareFab({
    super.key,
    required this.cardKey,
    required this.filename,
    this.shareText,
    this.subject,
  });

  @override
  State<ShareFab> createState() => _ShareFabState();
}

class _ShareFabState extends State<ShareFab> {
  bool _isSharing = false;

  Future<void> _handleShare() async {
    if (_isSharing) return;

    setState(() => _isSharing = true);

    try {
      final success = await ShareService.instance.shareWidget(
        key: widget.cardKey,
        filename: widget.filename,
        text: widget.shareText,
        subject: widget.subject,
      );

      if (mounted && !success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to share. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _isSharing ? null : _handleShare,
      icon: _isSharing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.share),
      label: const Text('Share'),
      backgroundColor: _isSharing
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)
          : Theme.of(context).colorScheme.primary,
    );
  }
}
