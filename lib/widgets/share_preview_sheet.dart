import 'package:flutter/material.dart';
import 'package:focus_field/widgets/shareable_cards.dart';
import 'package:focus_field/services/share_service.dart';
import 'package:focus_field/constants/ui_constants.dart';
import 'package:focus_field/widgets/common/drag_handle.dart';
import 'package:focus_field/l10n/app_localizations.dart';

/// Time range for progress sharing
enum ShareTimeRange {
  today,
  weekly;

  String getLabel(AppLocalizations l10n) {
    switch (this) {
      case ShareTimeRange.today:
        return l10n.shareTodayLabel;
      case ShareTimeRange.weekly:
        return l10n.shareWeeklyLabel;
    }
  }

  String getTitle(AppLocalizations l10n) {
    switch (this) {
      case ShareTimeRange.today:
        return l10n.shareTodayTitle;
      case ShareTimeRange.weekly:
        return l10n.shareWeeklyTitle;
    }
  }
}

/// Bottom sheet for previewing and customizing shareable cards.
/// Matches Settings/Trends sheet style for consistency.
class SharePreviewSheet extends StatefulWidget {
  final int totalMinutes;
  final int sessionCount;
  final double successRate;
  final Map<String, int>? activityMinutes; // Map of activity name -> minutes
  final String dateRange; // e.g., "Oct 7-13, 2025" or "October 13, 2025"
  final ShareTimeRange initialTimeRange;

  const SharePreviewSheet({
    super.key,
    required this.totalMinutes,
    required this.sessionCount,
    required this.successRate,
    this.activityMinutes,
    required this.dateRange,
    this.initialTimeRange = ShareTimeRange.weekly,
  });

  @override
  State<SharePreviewSheet> createState() => _SharePreviewSheetState();
}

class _SharePreviewSheetState extends State<SharePreviewSheet> {
  late ShareCardFormat _selectedFormat;
  late ShareTimeRange _selectedTimeRange;
  final GlobalKey _cardKey = GlobalKey();
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _selectedFormat = ShareCardFormat.post; // Default to 4:5 ratio
    _selectedTimeRange = widget.initialTimeRange;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final maxHeight =
        MediaQuery.of(context).size.height *
        UIConstants.bottomSheetMaxHeightRatio;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UIConstants.bottomSheetBorderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const DragHandle(),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
            child: Row(
              children: [
                Icon(Icons.share, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  l10n.shareYourProgress,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Time Range Toggle
                  _buildTimeRangeToggle(theme, l10n),

                  const SizedBox(height: 16),

                  // Card Format Selector
                  _buildFormatSelector(theme, l10n),

                  const SizedBox(height: 16),

                  // Card Preview
                  _buildCardPreview(theme, l10n),

                  const SizedBox(height: 16),

                  // Share Button
                  _buildShareButton(theme, l10n),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeToggle(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.shareTimeRange,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<ShareTimeRange>(
          segments:
              ShareTimeRange.values
                  .map(
                    (range) => ButtonSegment<ShareTimeRange>(
                      value: range,
                      label: Text(range.getLabel(l10n)),
                      icon: Icon(
                        range == ShareTimeRange.today
                            ? Icons.today
                            : Icons.date_range,
                      ),
                    ),
                  )
                  .toList(),
          selected: {_selectedTimeRange},
          onSelectionChanged: (Set<ShareTimeRange> selected) {
            setState(() {
              _selectedTimeRange = selected.first;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFormatSelector(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.shareCardSize,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                ShareCardFormat.values.map((format) {
                  final isSelected = _selectedFormat == format;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(format.label),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFormat = format;
                          });
                        }
                      },
                      avatar: Icon(_getFormatIcon(format), size: 18),
                    ),
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getFormatDescription(_selectedFormat, l10n),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCardPreview(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.sharePreview,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text(
              l10n.sharePinchToZoom,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 320, maxWidth: 240),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 2.0,
                  boundaryMargin: const EdgeInsets.all(20),
                  child: RepaintBoundary(
                    key: _cardKey,
                    child: FittedBox(fit: BoxFit.contain, child: _buildCard()),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return MinimalProgressCard(
      totalMinutes: widget.totalMinutes,
      sessionCount: widget.sessionCount,
      successRate: widget.successRate,
      activityMinutes: widget.activityMinutes,
      timeRange: widget.dateRange,
      title: _selectedTimeRange.getTitle(AppLocalizations.of(context)!),
      format: _selectedFormat,
    );
  }

  Widget _buildShareButton(ThemeData theme, AppLocalizations l10n) {
    return FilledButton.icon(
      onPressed: _isSharing ? null : _handleShare,
      icon:
          _isSharing
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : const Icon(Icons.share),
      label: Text(_isSharing ? l10n.shareGenerating : l10n.shareButton),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _handleShare() async {
    setState(() {
      _isSharing = true;
    });

    try {
      // Small delay to ensure card is fully rendered
      await Future.delayed(const Duration(milliseconds: 100));

      final l10n = AppLocalizations.of(context)!;
      await ShareService.instance.shareWidget(
        key: _cardKey,
        filename: 'focus_field_${_selectedTimeRange.getLabel(l10n).toLowerCase()}',
        text: _generateShareText(),
        subject: l10n.shareSubject,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  String _generateShareText() {
    if (_selectedTimeRange == ShareTimeRange.today) {
      return 'Stayed focused for ${widget.totalMinutes} minutes today with Focus Field 🎯';
    } else {
      return 'Completed ${widget.totalMinutes} minutes of focused sessions this week with Focus Field 🎯';
    }
  }

  IconData _getFormatIcon(ShareCardFormat format) {
    switch (format) {
      case ShareCardFormat.square:
        return Icons.crop_square;
      case ShareCardFormat.post:
        return Icons.crop_portrait;
      case ShareCardFormat.story:
        return Icons.crop_3_2;
    }
  }

  String _getFormatDescription(ShareCardFormat format, AppLocalizations l10n) {
    switch (format) {
      case ShareCardFormat.square:
        return l10n.shareFormatSquare;
      case ShareCardFormat.post:
        return l10n.shareFormatPost;
      case ShareCardFormat.story:
        return l10n.shareFormatStory;
    }
  }
}
