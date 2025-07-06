import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/providers/silence_provider.dart';
import 'package:silence_score/providers/theme_provider.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final settingsAsyncValue = ref.watch(settingsNotifierProvider);
    final settingsNotifier = ref.read(settingsNotifierProvider.notifier);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.85, // Limit to 85% of screen height
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DefaultTabController(
        length: 3,
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
                  Text(
                    AppConstants.settingsTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            TabBar(
              tabs: const [
                Tab(
                  icon: Icon(Icons.tune),
                  text: 'Basic',
                ),
                Tab(
                  icon: Icon(Icons.engineering),
                  text: 'Advanced',
                ),
                Tab(
                  icon: Icon(Icons.info),
                  text: 'About',
                ),
              ],
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              indicatorColor: theme.colorScheme.primary,
            ),
            
            // Tab Content
            Flexible(
              child: settingsAsyncValue.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error loading settings: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(settingsNotifierProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (settings) => TabBarView(
                  children: [
                    _buildBasicTab(context, settingsNotifier, settings, ref),
                    _buildAdvancedTab(context, settingsNotifier, settings),
                    _buildAboutTab(context, settings),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSliderSection(
    BuildContext context,
    String label,
    String hint,
    double value,
    double min,
    double max,
    int divisions,
    String unit,
    ValueChanged<double> onChanged,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          hint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '${min.toInt()}$unit',
              style: theme.textTheme.bodySmall,
            ),
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                label: '${value.toInt()}$unit',
                onChanged: onChanged,
              ),
            ),
            Text(
              '${max.toInt()}$unit',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${value.toInt()}$unit',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showResetDialog(
    BuildContext context,
    SettingsNotifier settingsNotifier,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Settings'),
        content: const Text(
          'This will reset all settings and data to their default values. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await settingsNotifier.resetSettings();
      // Also reset silence data
      ref.read(silenceDataNotifierProvider.notifier).resetData();
      
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All settings and data have been reset'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNoiseCalibrationDialog(BuildContext context, SettingsNotifier settingsNotifier) async {
    final theme = Theme.of(context);
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Noise Floor Calibration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This will measure the ambient noise in your environment for 5 seconds to set an optimal threshold.',
            ),
            const SizedBox(height: 16),
            Icon(
              Icons.mic,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Make sure you\'re in a quiet environment before starting.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // TODO: Implement noise calibration
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Noise calibration feature coming soon!'),
                ),
              );
            },
            child: const Text('Start Calibration'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportSessionData(BuildContext context) async {
    // TODO: Implement CSV export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session data export feature coming soon!'),
      ),
    );
  }

  Future<void> _showImportExportDialog(
    BuildContext context,
    SettingsNotifier settingsNotifier,
    Map<String, dynamic> settings,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import/Export Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Export Settings'),
              subtitle: const Text('Save current settings to file'),
              onTap: () {
                Navigator.of(context).pop();
                _exportSettings(context, settings);
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text('Import Settings'),
              subtitle: const Text('Load settings from file'),
              onTap: () {
                Navigator.of(context).pop();
                _importSettings(context, settingsNotifier);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDebugDialog(BuildContext context, Map<String, dynamic> settings) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug Information'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDebugInfo('App Version', settings['appVersion'].toString()),
              _buildDebugInfo('Total Sessions', settings['totalSessions'].toString()),
              _buildDebugInfo('Average Score', settings['averageScore'].toString()),
              _buildDebugInfo('Decibel Threshold', settings['decibelThreshold'].toString()),
              _buildDebugInfo('Session Duration', '${(settings['sessionDuration'] / 60).round()}min'),
              _buildDebugInfo('Sample Interval', '${AppConstants.sampleIntervalMs}ms (system)'),
              _buildDebugInfo('Points Per Minute', '${AppConstants.pointsPerMinute} (system)'),
              _buildDebugInfo('First Launch', (!settings['isFirstLaunch']).toString()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Copy to clipboard
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Debug info copied to clipboard')),
              );
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Future<void> _exportSettings(BuildContext context, Map<String, dynamic> settings) async {
    // TODO: Implement settings export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings export feature coming soon!'),
      ),
    );
  }

  Future<void> _importSettings(BuildContext context, SettingsNotifier settingsNotifier) async {
    // TODO: Implement settings import
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings import feature coming soon!'),
      ),
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    // TODO: Open privacy policy URL
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy policy link coming soon!'),
      ),
    );
  }

  void _openSupport(BuildContext context) {
    // TODO: Open support URL or email
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Support link coming soon!'),
      ),
    );
  }

  void _rateApp(BuildContext context) {
    // TODO: Open app store rating
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('App rating feature coming soon!'),
      ),
    );
  }

  Future<void> _showNotificationDialog(BuildContext context, SettingsNotifier settingsNotifier) async {
    bool enableNotifications = true; // TODO: Get from settings
    bool enableDailyReminders = false; // TODO: Get from settings
    bool enableSessionComplete = true; // TODO: Get from settings
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Notification Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Allow app to send notifications'),
                value: enableNotifications,
                onChanged: (value) {
                  setState(() {
                    enableNotifications = value;
                  });
                  // TODO: Save to settings
                },
              ),
              SwitchListTile(
                title: const Text('Daily Reminders'),
                subtitle: const Text('Remind to practice daily'),
                value: enableDailyReminders,
                onChanged: enableNotifications ? (value) {
                  setState(() {
                    enableDailyReminders = value;
                  });
                  // TODO: Save to settings
                } : null,
              ),
              SwitchListTile(
                title: const Text('Session Complete'),
                subtitle: const Text('Notify when session is complete'),
                value: enableSessionComplete,
                onChanged: enableNotifications ? (value) {
                  setState(() {
                    enableSessionComplete = value;
                  });
                  // TODO: Save to settings
                } : null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification settings saved'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAccessibilityDialog(BuildContext context, SettingsNotifier settingsNotifier) async {
    bool enableVibration = true; // TODO: Get from settings
    bool enableVoiceOver = false; // TODO: Get from settings
    bool enableHighContrast = false; // TODO: Get from settings
    bool enableLargeText = false; // TODO: Get from settings
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Accessibility Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Vibration Feedback'),
                  subtitle: const Text('Vibrate on session events'),
                  value: enableVibration,
                  onChanged: (value) {
                    setState(() {
                      enableVibration = value;
                    });
                    // TODO: Save to settings
                  },
                ),
                SwitchListTile(
                  title: const Text('Voice Announcements'),
                  subtitle: const Text('Announce session progress'),
                  value: enableVoiceOver,
                  onChanged: (value) {
                    setState(() {
                      enableVoiceOver = value;
                    });
                    // TODO: Save to settings
                  },
                ),
                SwitchListTile(
                  title: const Text('High Contrast Mode'),
                  subtitle: const Text('Improve visual accessibility'),
                  value: enableHighContrast,
                  onChanged: (value) {
                    setState(() {
                      enableHighContrast = value;
                    });
                    // TODO: Save to settings
                  },
                ),
                SwitchListTile(
                  title: const Text('Large Text'),
                  subtitle: const Text('Increase text size'),
                  value: enableLargeText,
                  onChanged: (value) {
                    setState(() {
                      enableLargeText = value;
                    });
                    // TODO: Save to settings
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Accessibility settings saved'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentTheme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'App Theme',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Choose your preferred theme',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: AppThemeMode.values.map((themeMode) {
            final isSelected = currentTheme == themeMode;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: themeMode != AppThemeMode.values.last ? 8 : 0,
                ),
                child: Material(
                  color: isSelected 
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => themeNotifier.setTheme(themeMode),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            themeMode.icon,
                            size: 20,
                            color: isSelected
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            themeMode.displayName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: isSelected 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Basic Settings Tab
  Widget _buildBasicTab(BuildContext context, SettingsNotifier settingsNotifier, Map<String, dynamic> settings, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Theme setting
          _buildThemeSection(context, ref),
          
          const SizedBox(height: 20),
          
          // Decibel threshold slider
          _buildCompactSliderSection(
            context,
            AppConstants.decibelThresholdLabel,
            AppConstants.decibelThresholdHint,
            settings['decibelThreshold'] as double,
            20.0,
            60.0,
            40,
            'dB',
            (value) {
              settingsNotifier.updateSetting('decibelThreshold', value);
            },
          ),
          
          const SizedBox(height: 20),
          
          // Session duration slider (in minutes)
          _buildCompactSliderSection(
            context,
            'Session Duration',
            'Set the duration for each silence session',
            (settings['sessionDuration'] as int).toDouble() / 60.0, // Convert seconds to minutes
            1.0,
            60.0,
            59,
            'min',  
            (value) {
              settingsNotifier.updateSetting('sessionDuration', (value * 60).round()); // Convert minutes to seconds
            },
          ),
          
          const SizedBox(height: 24),
          
          // Reset button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await _showResetDialog(context, settingsNotifier, ref);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset All Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Advanced Settings Tab
  Widget _buildAdvancedTab(BuildContext context, SettingsNotifier settingsNotifier, Map<String, dynamic> settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Advanced options in a grid layout
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildAdvancedCard(
                context,
                'Noise Calibration',
                'Calibrate baseline',
                Icons.equalizer,
                () async {
                  await _showNoiseCalibrationDialog(context, settingsNotifier);
                },
              ),
              _buildAdvancedCard(
                context,
                'Export Data',
                'Session history',
                Icons.file_download,
                () async {
                  await _exportSessionData(context);
                },
              ),
              _buildAdvancedCard(
                context,
                'Backup/Restore',
                'Settings backup',
                Icons.settings_backup_restore,
                () async {
                  await _showImportExportDialog(context, settingsNotifier, settings);
                },
              ),
              _buildAdvancedCard(
                context,
                'Debug Info',
                'Technical details',
                Icons.bug_report,
                () async {
                  await _showDebugDialog(context, settings);
                },
              ),
              _buildAdvancedCard(
                context,
                'Notifications',
                'App notifications',
                Icons.notifications,
                () async {
                  await _showNotificationDialog(context, settingsNotifier);
                },
              ),
              _buildAdvancedCard(
                context,
                'Accessibility',
                'Accessibility features',
                Icons.accessibility,
                () async {
                  await _showAccessibilityDialog(context, settingsNotifier);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // About Tab
  Widget _buildAboutTab(BuildContext context, Map<String, dynamic> settings) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'App Information',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInfoRow(context, 'Version', settings['appVersion'] as String),
                  const SizedBox(height: 8),
                  _buildInfoRow(context, 'Total Sessions', settings['totalSessions'].toString()),
                  const SizedBox(height: 8),
                  _buildInfoRow(context, 'Average Score', (settings['averageScore'] as double).toStringAsFixed(1)),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // App Links
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Help & Support',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLinkButton(
                        context,
                        'Privacy Policy',
                        Icons.privacy_tip,
                        () => _openPrivacyPolicy(context),
                      ),
                      _buildLinkButton(
                        context,
                        'Support',
                        Icons.help,
                        () => _openSupport(context),
                      ),
                      _buildLinkButton(
                        context,
                        'Rate App',
                        Icons.star,
                        () => _rateApp(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
