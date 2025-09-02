import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silence_score/providers/notification_provider.dart';
import 'package:silence_score/providers/silence_provider.dart';

class NotificationSettingsWidget extends ConsumerStatefulWidget {
  const NotificationSettingsWidget({super.key});

  @override
  ConsumerState<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends ConsumerState<NotificationSettingsWidget> {
  bool _isRequestingPermission = false;

  String _formatTime(int hour, int minute) {
    final time = TimeOfDay(hour: hour, minute: minute);
    return time.format(context);
  }

  // (weekday label helper removed in simplified UI)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notificationService = ref.watch(notificationServiceProvider);
    final settings = ref.watch(settingsNotifierProvider);
    final settingsNotifier = ref.read(settingsNotifierProvider.notifier);

    return settings.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (data) {
        final enableNotifications =
            data['enableNotifications'] as bool? ?? true;
        final enableDailyReminders =
            data['enableDailyReminders'] as bool? ?? false;
        final enableSessionComplete =
            data['enableSessionComplete'] as bool? ?? true;
        final enableAchievementNotifications =
            data['enableAchievementNotifications'] as bool? ?? true;
        final enableWeeklyProgress =
            data['enableWeeklyProgress'] as bool? ?? false;
        final dailyReminderHour = data['dailyReminderHour'] as int?;
        final dailyReminderMinute = data['dailyReminderMinute'] as int?;
        final weeklyWeekday =
            data['weeklySummaryWeekday'] as int? ?? DateTime.monday;
        final weeklyHour = data['weeklySummaryHour'] as int? ?? 9;
        final weeklyMinute = data['weeklySummaryMinute'] as int? ?? 0;

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  children: [
                    Icon(Icons.notifications, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      'Notification Settings',
                      style: theme.textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              if (!notificationService.hasNotificationPermission)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.notifications_off,
                            color: theme.colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Permission required',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enable notifications to receive reminders and celebrate achievements.',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                              _isRequestingPermission
                                  ? null
                                  : _requestPermission,
                          icon:
                              _isRequestingPermission
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(Icons.settings),
                          label: Text(
                            _isRequestingPermission
                                ? 'Requesting...'
                                : 'Enable Notifications',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context: context,
                        title: 'Enable Notifications',
                        subtitle: 'Allow SilenceScore to send notifications',
                        icon: Icons.notifications_active,
                        value: enableNotifications,
                        onChanged:
                            notificationService.hasNotificationPermission
                                ? (v) {
                                  settingsNotifier.updateSetting(
                                    'enableNotifications',
                                    v,
                                  );
                                  notificationService.updateSettings(
                                    notifications: v,
                                  );
                                }
                                : null,
                        isMainToggle: true,
                      ),
                      _buildSettingsTile(
                        context: context,
                        title: 'Smart Daily Reminders',
                        subtitle: 'Smart or chosen time',
                        icon: Icons.schedule,
                        value: enableDailyReminders,
                        onChanged:
                            enableNotifications &&
                                    notificationService
                                        .hasNotificationPermission
                                ? (v) {
                                  settingsNotifier.updateSetting(
                                    'enableDailyReminders',
                                    v,
                                  );
                                  notificationService.updateSettings(
                                    dailyReminders: v,
                                  );
                                  if (v) {
                                    notificationService
                                        .scheduleDailyReminderNotification(
                                          context: context,
                                        );
                                  } else {
                                    notificationService
                                        .cancelScheduledNotifications();
                                  }
                                }
                                : null,
                      ),
                      if (enableDailyReminders &&
                          notificationService.hasNotificationPermission)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Daily Time',
                                    style: theme.textTheme.labelMedium,
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton(
                                    onPressed: () async {
                                      final picked = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                          hour:
                                              dailyReminderHour ??
                                              TimeOfDay.now().hour,
                                          minute:
                                              dailyReminderMinute ??
                                              TimeOfDay.now().minute,
                                        ),
                                      );
                                      if (picked != null) {
                                        settingsNotifier.updateSetting(
                                          'dailyReminderHour',
                                          picked.hour,
                                        );
                                        settingsNotifier.updateSetting(
                                          'dailyReminderMinute',
                                          picked.minute,
                                        );
                                        notificationService.updateSettings(
                                          dailyHour: picked.hour,
                                          dailyMinute: picked.minute,
                                        );
                                        await notificationService
                                            .scheduleDailyReminderNotification(
                                              context: context,
                                            );
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Daily reminder at ${picked.format(context)}',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      dailyReminderHour != null &&
                                              dailyReminderMinute != null
                                          ? _formatTime(
                                            dailyReminderHour,
                                            dailyReminderMinute,
                                          )
                                          : 'Smart (${notificationService.getOptimalReminderTime()?.format(context) ?? 'learning'})',
                                    ),
                                  ),
                                  if (dailyReminderHour != null)
                                    TextButton(
                                      onPressed: () {
                                        settingsNotifier.updateSetting(
                                          'dailyReminderHour',
                                          null,
                                        );
                                        settingsNotifier.updateSetting(
                                          'dailyReminderMinute',
                                          null,
                                        );
                                        notificationService.updateSettings(
                                          dailyHour: null,
                                          dailyMinute: null,
                                        );
                                        notificationService
                                            .scheduleDailyReminderNotification(
                                              context: context,
                                            );
                                      },
                                      child: const Text('Use Smart'),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Choose a fixed time or let SilenceScore learn your pattern.',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      _buildSettingsTile(
                        context: context,
                        title: 'Session Completed',
                        subtitle: 'Celebrate completed sessions',
                        icon: Icons.check_circle,
                        value: enableSessionComplete,
                        onChanged:
                            enableNotifications &&
                                    notificationService
                                        .hasNotificationPermission
                                ? (v) {
                                  settingsNotifier.updateSetting(
                                    'enableSessionComplete',
                                    v,
                                  );
                                  notificationService.updateSettings(
                                    sessionComplete: v,
                                  );
                                }
                                : null,
                      ),
                      _buildSettingsTile(
                        context: context,
                        title: 'Achievement Unlocked',
                        subtitle: 'Milestone notifications',
                        icon: Icons.emoji_events,
                        value: enableAchievementNotifications,
                        onChanged:
                            enableNotifications &&
                                    notificationService
                                        .hasNotificationPermission
                                ? (v) {
                                  settingsNotifier.updateSetting(
                                    'enableAchievementNotifications',
                                    v,
                                  );
                                  notificationService.updateSettings(
                                    achievementNotifications: v,
                                  );
                                }
                                : null,
                      ),
                      _buildSettingsTile(
                        context: context,
                        title: 'Weekly Progress Summary',
                        subtitle: 'Weekly insights (weekday & time)',
                        icon: Icons.insights,
                        value: enableWeeklyProgress,
                        onChanged:
                            enableNotifications &&
                                    notificationService
                                        .hasNotificationPermission
                                ? (v) {
                                  settingsNotifier.updateSetting(
                                    'enableWeeklyProgress',
                                    v,
                                  );
                                  notificationService.updateSettings(
                                    weeklyProgress: v,
                                  );
                                  if (v) {
                                    notificationService
                                        .scheduleWeeklySummaryNotification(
                                          context: context,
                                        );
                                  } else {
                                    notificationService
                                        .cancelScheduledNotifications();
                                  }
                                }
                                : null,
                        isPremium: true,
                      ),
                      if (enableWeeklyProgress &&
                          notificationService.hasNotificationPermission)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: List.generate(7, (index) {
                                  final day = index + 1;
                                  const labels = [
                                    'M',
                                    'T',
                                    'W',
                                    'T',
                                    'F',
                                    'S',
                                    'S',
                                  ];
                                  final selected = weeklyWeekday == day;
                                  return ChoiceChip(
                                    label: Text(labels[index]),
                                    selected: selected,
                                    onSelected: (sel) async {
                                      if (!sel) return;
                                      settingsNotifier.updateSetting(
                                        'weeklySummaryWeekday',
                                        day,
                                      );
                                      notificationService.updateSettings(
                                        weeklyWeekday: day,
                                      );
                                      await notificationService
                                          .scheduleWeeklySummaryNotification(
                                            context: context,
                                          );
                                    },
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Weekly Time',
                                    style: theme.textTheme.labelMedium,
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton(
                                    onPressed: () async {
                                      final picked = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                          hour: weeklyHour,
                                          minute: weeklyMinute,
                                        ),
                                      );
                                      if (picked != null) {
                                        settingsNotifier.updateSetting(
                                          'weeklySummaryHour',
                                          picked.hour,
                                        );
                                        settingsNotifier.updateSetting(
                                          'weeklySummaryMinute',
                                          picked.minute,
                                        );
                                        notificationService.updateSettings(
                                          weeklyHour: picked.hour,
                                          weeklyMinute: picked.minute,
                                        );
                                        await notificationService
                                            .scheduleWeeklySummaryNotification(
                                              context: context,
                                            );
                                      }
                                    },
                                    child: Text(
                                      _formatTime(weeklyHour, weeklyMinute),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (enableNotifications &&
                          notificationService.hasNotificationPermission) ...[
                        Divider(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Notification Preview',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildNotificationPreview(
                          context: context,
                          title: 'Daily Reminder',
                          message: notificationService.getSmartReminderMessage(
                            context,
                          ),
                          icon: Icons.schedule,
                        ),
                        if (enableSessionComplete) ...[
                          const SizedBox(height: 8),
                          _buildNotificationPreview(
                            context: context,
                            title: 'Session Complete',
                            message: notificationService.getCompletionMessage(
                              true,
                              5,
                            ),
                            icon: Icons.check_circle,
                          ),
                        ],
                        if (enableAchievementNotifications) ...[
                          const SizedBox(height: 8),
                          _buildNotificationPreview(
                            context: context,
                            title: 'Achievement',
                            message: notificationService.getAchievementMessage(
                              context,
                              'week_streak',
                            ),
                            icon: Icons.emoji_events,
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool isMainToggle = false,
    bool isPremium = false,
  }) {
    final theme = Theme.of(context);
    final isEnabled = onChanged != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isMainToggle ? 4 : 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isEnabled
                        ? theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        )
                        : theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color:
                    isEnabled
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              isEnabled
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                        ),
                      ),
                      if (isPremium) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.workspace_premium,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          isEnabled
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationPreview({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  message,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isRequestingPermission = true;
    });

    try {
      final notificationService = ref.read(notificationServiceProvider);
      final granted = await notificationService.requestNotificationPermission();

      if (mounted) {
        if (granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text('Notifications enabled successfully!'),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text('Please enable notifications in device settings'),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequestingPermission = false;
        });
      }
    }
  }
}
