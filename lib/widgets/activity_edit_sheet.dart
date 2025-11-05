import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/user_preferences_provider.dart';
import '../providers/ambient_quest_provider.dart';
import '../theme/theme_extensions.dart';
import '../constants/ui_constants.dart';
import 'common/drag_handle.dart';
import 'package:focus_field/l10n/app_localizations.dart';

/// Bottom sheet for editing activity visibility and daily goal
class ActivityEditSheet extends ConsumerStatefulWidget {
  const ActivityEditSheet({super.key});

  @override
  ConsumerState<ActivityEditSheet> createState() => _ActivityEditSheetState();
}

class _ActivityEditSheetState extends ConsumerState<ActivityEditSheet> {
  late int _goalMinutes;
  late Map<String, bool> _profileEnabled;
  late bool _perActivityGoalsEnabled;
  late Map<String, int> _perActivityGoals;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(userPreferencesProvider);
    _goalMinutes = prefs.globalDailyQuietGoalMinutes;
    _perActivityGoalsEnabled = prefs.perActivityGoalsEnabled;

    // Initialize profile enabled map
    _profileEnabled = {
      'study': prefs.enabledProfiles.contains('study'),
      'reading': prefs.enabledProfiles.contains('reading'),
      'meditation': prefs.enabledProfiles.contains('meditation'),
      'other': prefs.enabledProfiles.contains('other'),
    };

    // Initialize per-activity goals (default to global goal if not set)
    _perActivityGoals = {
      'study': prefs.perActivityGoals?['study'] ?? _goalMinutes,
      'reading': prefs.perActivityGoals?['reading'] ?? _goalMinutes,
      'meditation': prefs.perActivityGoals?['meditation'] ?? _goalMinutes,
      'other': prefs.perActivityGoals?['other'] ?? _goalMinutes,
    };
  }

  int get _totalMinutes {
    if (!_perActivityGoalsEnabled) {
      // Global mode: the goal is the TOTAL daily goal shared across all activities
      return _goalMinutes;
    }
    // Per-activity mode: sum individual goals
    return _profileEnabled.entries
        .where((e) => e.value)
        .fold<int>(0, (sum, e) => sum + (_perActivityGoals[e.key] ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final maxHeight = MediaQuery.of(context).size.height * UIConstants.bottomSheetMaxHeightRatio;
    const maxTotalMinutes = 1080; // 18 hours total budget

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: context.elevatedCardDecoration.copyWith(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UIConstants.bottomSheetBorderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const DragHandle(),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 8,
                bottom: MediaQuery.of(context).viewInsets.bottom + 8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.activityEditTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Single recommendation for all goals
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_outlined,
                size: 14,
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.activityRecommendation,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          _buildProfileToggle(
            context,
            'study',
            Icons.school_outlined,
            l10n.onboardingActivityStudyTitle,
            _profileEnabled['study']!,
            const Color(0xFF7F6BB0),
          ),
          SizedBox(height: _perActivityGoalsEnabled ? 6 : 3),
          _buildProfileToggle(
            context,
            'reading',
            Icons.menu_book_outlined,
            l10n.onboardingActivityReadingTitle,
            _profileEnabled['reading']!,
            const Color(0xFF5B9BD5),
          ),
          SizedBox(height: _perActivityGoalsEnabled ? 6 : 3),
          _buildProfileToggle(
            context,
            'meditation',
            Icons.self_improvement_outlined,
            l10n.onboardingActivityMeditationTitle,
            _profileEnabled['meditation']!,
            const Color(0xFF70AD47),
          ),
          SizedBox(height: _perActivityGoalsEnabled ? 6 : 3),
          _buildProfileToggle(
            context,
            'other',
            Icons.star_outline,
            l10n.onboardingActivityOtherTitle,
            _profileEnabled['other']!,
            const Color(0xFFFFC000),
          ),

          const SizedBox(height: 4),
          const Divider(),
          const SizedBox(height: 4),

          // Goals Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.activityDailyGoals,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.activityTotalHours((_totalMinutes / 60).toStringAsFixed(1)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _totalMinutes > maxTotalMinutes
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: _totalMinutes > maxTotalMinutes
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    l10n.activityPerActivity,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Switch(
                    value: _perActivityGoalsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _perActivityGoalsEnabled = value;
                        if (!value) {
                          _perActivityGoals['study'] = _goalMinutes;
                          _perActivityGoals['reading'] = _goalMinutes;
                          _perActivityGoals['meditation'] = _goalMinutes;
                          _perActivityGoals['other'] = _goalMinutes;
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Budget warning
          if (_totalMinutes > maxTotalMinutes)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: theme.colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.activityExceedsLimit,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Global Goal (shown when per-activity is disabled)
          if (!_perActivityGoalsEnabled) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.activityGoalLabel,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.activityGoalDescription,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '1min',
                        style: theme.textTheme.bodySmall,
                      ),
                      Expanded(
                        child: Slider(
                          value: _goalMinutes.toDouble(),
                          min: 1,
                          max: 1080,
                          divisions: 1079,
                          label: _goalMinutes >= 60
                              ? '${(_goalMinutes / 60).toStringAsFixed(1)}h'
                              : '${_goalMinutes}min',
                          onChanged: (value) {
                            setState(() {
                              _goalMinutes = value.round();
                            });
                          },
                        ),
                      ),
                      Text(
                        '18h',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.activityCurrentGoal(_goalMinutes >= 60 ? '${(_goalMinutes / 60).toStringAsFixed(1)}h' : '${_goalMinutes}min'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 4),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _save,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(l10n.activitySaveChanges),
              ),
            ),
          ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileToggle(
    BuildContext context,
    String profileId,
    IconData icon,
    String label,
    bool enabled,
    Color iconColor,
  ) {
    final theme = Theme.of(context);
    final enabledCount = _profileEnabled.values.where((e) => e).length;
    final canDisable = enabledCount > 1;
    final goalMinutes = _perActivityGoals[profileId] ?? 10;

    return Container(
      decoration: BoxDecoration(
        color: enabled
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled
              ? iconColor.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Header row with icon, label, and toggle
          InkWell(
            onTap: canDisable || !enabled
                ? () {
                    setState(() {
                      _profileEnabled[profileId] = !_profileEnabled[profileId]!;
                    });
                  }
                : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Icon(icon, color: iconColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: enabled ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  // Show goal minutes when per-activity is enabled
                  if (_perActivityGoalsEnabled && enabled)
                    Text(
                      '$goalMinutes min (${(goalMinutes / 60).toStringAsFixed(1)}h)',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                  if (_perActivityGoalsEnabled && enabled)
                    const SizedBox(width: 8),
                  Switch(
                    value: enabled,
                    onChanged: canDisable || !enabled
                        ? (value) {
                            setState(() {
                              _profileEnabled[profileId] = value;
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),

          // Slider (shown when per-activity goals enabled and activity is enabled)
          if (_perActivityGoalsEnabled && enabled)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Transform.translate(
                offset: const Offset(0, -12),
                child: Transform.scale(
                  scaleY: 0.85,
                  child: Slider(
                    value: goalMinutes.toDouble().clamp(1, 1080),
                    min: 1,
                    max: 1080,
                    divisions: 1079,
                    label: '$goalMinutes min (${(goalMinutes / 60).toStringAsFixed(1)}h)',
                    onChanged: (value) {
                      setState(() {
                        _perActivityGoals[profileId] = value.round();
                      });
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    // Validate: At least one activity must be enabled
    final enabledList = _profileEnabled.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    if (enabledList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorActivityRequired),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate total budget
    if (_totalMinutes > 1080) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorGoalExceeds),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await ref.read(userPreferencesProvider.notifier).setEnabledProfiles(enabledList);
    await ref.read(userPreferencesProvider.notifier).setGlobalDailyGoal(_goalMinutes);

    // Save per-activity goals settings
    await ref.read(userPreferencesProvider.notifier).setPerActivityGoalsEnabled(_perActivityGoalsEnabled);
    if (_perActivityGoalsEnabled) {
      await ref.read(userPreferencesProvider.notifier).setPerActivityGoals(_perActivityGoals);
    }

    // Update quest state with appropriate goal
    // If per-activity is enabled, use sum of enabled activities; otherwise use global
    if (_perActivityGoalsEnabled) {
      final totalGoal = enabledList.fold<int>(
        0,
        (sum, profileId) => sum + (_perActivityGoals[profileId] ?? 10),
      );
      await ref.read(questStateProvider.notifier).updateGoal(totalGoal);
    } else {
      await ref.read(questStateProvider.notifier).updateGoal(_goalMinutes);
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.messageSaved),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

