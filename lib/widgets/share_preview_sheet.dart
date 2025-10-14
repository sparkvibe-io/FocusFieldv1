import 'package:flutter/material.dart';
import 'package:focus_field/widgets/shareable_cards.dart';
import 'package:focus_field/services/share_service.dart';
import 'package:flutter/rendering.dart';

/// Time range for progress sharing
enum ShareTimeRange {
  today('Today', 'Today\'s Focus'),
  weekly('Weekly', 'Your Weekly Focus');

  const ShareTimeRange(this.label, this.title);
  final String label;
  final String title;
}

/// Bottom sheet for previewing and customizing shareable cards.
/// Matches Settings/Trends sheet style for consistency.
class SharePreviewSheet extends StatefulWidget {
  final int totalMinutes;
  final int sessionCount;
  final double successRate;
  final String? topActivity;
  final String dateRange; // e.g., "Oct 7-13, 2025" or "October 13, 2025"
  final ShareTimeRange initialTimeRange;

  const SharePreviewSheet({
    super.key,
    required this.totalMinutes,
    required this.sessionCount,
    required this.successRate,
    this.topActivity,
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
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
            child: Row(
              children: [
                Icon(Icons.share, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Share Your Progress',
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

          Divider(height: 1, color: theme.colorScheme.outline.withOpacity(0.2)),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Time Range Toggle
                  _buildTimeRangeToggle(theme),
                  
                  const SizedBox(height: 16),

                  // Card Format Selector
                  _buildFormatSelector(theme),

                  const SizedBox(height: 16),

                  // Card Preview
                  _buildCardPreview(theme),

                  const SizedBox(height: 16),

                  // Share Button
                  _buildShareButton(theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeToggle(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Range',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<ShareTimeRange>(
          segments: ShareTimeRange.values
              .map(
                (range) => ButtonSegment<ShareTimeRange>(
                  value: range,
                  label: Text(range.label),
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

  Widget _buildFormatSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Size',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ShareCardFormat.values.map((format) {
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
                  avatar: Icon(
                    _getFormatIcon(format),
                    size: 18,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getFormatDescription(_selectedFormat),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCardPreview(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Preview',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text(
              'Pinch to zoom',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 320,
              maxWidth: 240,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: _buildCard(),
                    ),
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
      topActivity: widget.topActivity,
      timeRange: widget.dateRange,
      title: _selectedTimeRange.title,
      format: _selectedFormat,
    );
  }

  Widget _buildShareButton(ThemeData theme) {
    return FilledButton.icon(
      onPressed: _isSharing ? null : _handleShare,
      icon: _isSharing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.share),
      label: Text(_isSharing ? 'Generating...' : 'Share'),
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

      await ShareService.instance.shareWidget(
        key: _cardKey,
        filename: 'focus_field_${_selectedTimeRange.label.toLowerCase()}',
        text: _generateShareText(),
        subject: 'My Focus Field Progress',
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

  String _getFormatDescription(ShareCardFormat format) {
    switch (format) {
      case ShareCardFormat.square:
        return '1:1 ratio • Universal compatibility';
      case ShareCardFormat.post:
        return '4:5 ratio • Instagram/Twitter posts';
      case ShareCardFormat.story:
        return '9:16 ratio • Instagram Stories';
    }
  }
}
