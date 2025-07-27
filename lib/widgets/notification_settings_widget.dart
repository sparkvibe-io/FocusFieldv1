import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silence_score/providers/notification_provider.dart';
import 'package:silence_score/providers/silence_provider.dart';

class NotificationSettingsWidget extends ConsumerStatefulWidget {
  const NotificationSettingsWidget({super.key});

  @override
  ConsumerState<NotificationSettingsWidget> createState() => _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState extends ConsumerState<NotificationSettingsWidget> {
  bool _isRequestingPermission = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notificationService = ref.watch(notificationServiceProvider);
    final settings = ref.watch(settingsNotifierProvider);
    final settingsNotifier = ref.read(settingsNotifierProvider.notifier);

    return settings.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading settings: $error'),
      ),
      data: (settingsData) {
        final enableNotifications = settingsData['enableNotifications'] as bool? ?? true;
        final enableDailyReminders = settingsData['enableDailyReminders'] as bool? ?? false;
        final enableSessionComplete = settingsData['enableSessionComplete'] as bool? ?? true;
        final enableAchievementNotifications = settingsData['enableAchievementNotifications'] as bool? ?? true;
        final enableWeeklyProgress = settingsData['enableWeeklyProgress'] as bool? ?? false;

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Notification Settings',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Permission status
              if (!notificationService.hasNotificationPermission)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.error.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.notifications_off,
                            color: theme.colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Notification Permission Required',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enable notifications to receive gentle reminders and celebrate your silence achievements.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isRequestingPermission ? null : _requestPermission,
                          icon: _isRequestingPermission
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.settings, size: 16),
                          label: Text(_isRequestingPermission ? 'Requesting...' : 'Enable Notifications'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.onError,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Settings list
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Master toggle
                      _buildSettingsTile(
                        context: context,
                        title: 'Enable Notifications',
                        subtitle: 'Allow SilenceScore to send notifications',
                        icon: Icons.notifications_active,
                        value: enableNotifications,
                        onChanged: notificationService.hasNotificationPermission
                            ? (value) {
                                settingsNotifier.updateSetting('enableNotifications', value);
                                notificationService.updateSettings(notifications: value);
                              }
                            : null,
                        isMainToggle: true,
                      ),

                      const SizedBox(height: 8),

                      // Daily reminders
                      _buildSettingsTile(
                        context: context,
                        title: 'Smart Daily Reminders',
                        subtitle: 'Gentle reminders based on your practice patterns',
                        icon: Icons.schedule,
                        value: enableDailyReminders,
                        onChanged: enableNotifications && notificationService.hasNotificationPermission
                            ? (value) {
                                settingsNotifier.updateSetting('enableDailyReminders', value);
                                notificationService.updateSettings(dailyReminders: value);
                              }
                            : null,
                      ),

                      // Session completion
                      _buildSettingsTile(
                        context: context,
                        title: 'Session Completed',
                        subtitle: 'Celebrate when you complete a silence session',
                        icon: Icons.check_circle,
                        value: enableSessionComplete,
                        onChanged: enableNotifications && notificationService.hasNotificationPermission
                            ? (value) {
                                settingsNotifier.updateSetting('enableSessionComplete', value);
                                notificationService.updateSettings(sessionComplete: value);
                              }
                            : null,
                      ),

                      // Achievement notifications
                      _buildSettingsTile(
                        context: context,
                        title: 'Achievement Unlocked',
                        subtitle: 'Get notified when you reach new milestones',
                        icon: Icons.emoji_events,
                        value: enableAchievementNotifications,
                        onChanged: enableNotifications && notificationService.hasNotificationPermission
                            ? (value) {
                                settingsNotifier.updateSetting('enableAchievementNotifications', value);
                                notificationService.updateSettings(achievementNotifications: value);
                              }
                            : null,
                      ),

                      // Weekly progress (Premium feature)
                      _buildSettingsTile(
                        context: context,
                        title: 'Weekly Progress Summary',
                        subtitle: 'Weekly insights about your silence practice',
                        icon: Icons.insights,
                        value: enableWeeklyProgress,
                        onChanged: enableNotifications && notificationService.hasNotificationPermission
                            ? (value) {
                                settingsNotifier.updateSetting('enableWeeklyProgress', value);
                                notificationService.updateSettings(weeklyProgress: value);
                              }
                            : null,
                        isPremium: true,
                      ),

                      const SizedBox(height: 16),

                      // Preview section
                      if (enableNotifications && notificationService.hasNotificationPermission) ...[
                        Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
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
                          message: notificationService.getSmartReminderMessage(),
                          icon: Icons.schedule,
                        ),
                        
                        if (enableSessionComplete) ...[
                          const SizedBox(height: 8),
                          _buildNotificationPreview(
                            context: context,
                            title: 'Session Complete',
                            message: notificationService.getCompletionMessage(true, 5),
                            icon: Icons.check_circle,
                          ),
                        ],
                        
                        if (enableAchievementNotifications) ...[
                          const SizedBox(height: 8),
                          _buildNotificationPreview(
                            context: context,
                            title: 'Achievement',
                            message: notificationService.getAchievementMessage('week_streak'),
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
                color: isEnabled
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                    : theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isEnabled
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
                          color: isEnabled
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
                      color: isEnabled
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
            ),
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
            child: Icon(
              icon,
              size: 16,
              color: theme.colorScheme.onPrimary,
            ),
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