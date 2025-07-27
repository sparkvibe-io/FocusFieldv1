import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/models/silence_data.dart';
import 'package:silence_score/models/subscription_tier.dart';
import 'package:silence_score/providers/silence_provider.dart';
import 'package:silence_score/providers/subscription_provider.dart';
import 'package:silence_score/providers/theme_provider.dart';
import 'package:silence_score/services/export_service.dart';
import 'package:silence_score/services/support_service.dart';
import 'package:silence_score/widgets/feature_gate.dart';
import 'package:silence_score/widgets/theme_selector_widget.dart';
import 'package:silence_score/widgets/notification_settings_widget.dart';

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
                    _buildAdvancedTab(context, settingsNotifier, settings, ref),
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

  // Subscription-aware session duration section
  Widget _buildSessionDurationSection(
    BuildContext context, 
    SettingsNotifier settingsNotifier, 
    Map<String, dynamic> settings,
    WidgetRef ref,
  ) {
    final maxSessionMinutes = ref.watch(maxSessionMinutesProvider);
    final currentTier = ref.watch(subscriptionTierStateProvider);
    final currentDurationMinutes = (settings['sessionDuration'] as int) / 60.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Session Duration',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            if (currentTier != SubscriptionTier.free) ...[
              Icon(
                Icons.workspace_premium,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
            // Inline upgrade prompt for free users
            if (currentTier == SubscriptionTier.free && maxSessionMinutes < 60) ...[
              const Spacer(),
              InkWell(
                onTap: () => showPaywall(context, requiredTier: SubscriptionTier.premium),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.upgrade,
                        size: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Upgrade for 60min',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Free: up to $maxSessionMinutes min',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        
        // Slider with subscription limits
        _buildSimpleSliderSection(
          context,
          '',
          currentDurationMinutes.clamp(1.0, maxSessionMinutes.toDouble()),
          1.0,
          maxSessionMinutes.toDouble(),
          maxSessionMinutes - 1,
          'min',
          (value) {
            settingsNotifier.updateSetting('sessionDuration', (value * 60).round());
          },
        ),
        
      ],
    );
  }

  Widget _buildSimpleSliderSection(
    BuildContext context,
    String label,
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
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
        ],
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
    VoidCallback onTap, {
    bool isPremium = false,
    bool hasPremiumAccess = true,
  }) {
    final theme = Theme.of(context);
    final isAccessible = !isPremium || hasPremiumAccess;
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    icon,
                    size: 28,
                    color: isAccessible 
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  if (isPremium && !hasPremiumAccess)
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.lock,
                          size: 10,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isAccessible 
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isAccessible 
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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
    // Check if user has premium access for data export
    if (!context.mounted) return;
    
    final ref = ProviderScope.containerOf(context);
    final hasExportAccess = ref.read(featureAccessProvider('data_export'));
    
    if (!hasExportAccess) {
      showPaywall(
        context,
        requiredTier: SubscriptionTier.premium,
        featureDescription: 'Export your session data as CSV or PDF reports with Premium',
      );
      return;
    }

    // Show export options dialog for premium users
    await _showExportDialog(context);
  }

  Future<void> _showExportDialog(BuildContext context) async {
    final ref = ProviderScope.containerOf(context);
    final silenceDataAsync = ref.read(silenceDataNotifierProvider);
    
    if (!silenceDataAsync.hasValue) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data available to export')),
        );
      }
      return;
    }

    final silenceData = silenceDataAsync.value!;
    
    if (!context.mounted) return;
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text('Export Data'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose export format for your ${silenceData.totalSessions} sessions:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            
            // CSV Export
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('CSV Spreadsheet'),
              subtitle: const Text('Raw data for analysis'),
              onTap: () async {
                Navigator.of(context).pop();
                await _performExport(context, silenceData, ExportFormat.csv);
              },
            ),
            
            // PDF Export  
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('PDF Report'),
              subtitle: const Text('Formatted report with charts'),
              onTap: () async {
                Navigator.of(context).pop();
                await _performExport(context, silenceData, ExportFormat.pdf);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _performExport(BuildContext context, SilenceData silenceData, ExportFormat format) async {
    try {
      // Show loading
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text('Generating ${format.name.toUpperCase()} export...'),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Perform export
      final exportService = ExportService.instance;
      
      switch (format) {
        case ExportFormat.csv:
          await exportService.exportAndShareCSV(silenceData);
          break;
        case ExportFormat.pdf:
          await exportService.exportAndSharePDF(silenceData);
          break;
      }

      // Show success message
      if (context.mounted) {
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
                Text('${format.name.toUpperCase()} export completed!'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Theme.of(context).colorScheme.error,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text('Export failed: ${e.toString()}'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    }
  }



  void _openFAQ(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.quiz),
            SizedBox(width: 8),
            Text('Frequently Asked Questions'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFAQItem(
                'How does SilenceScore work?',
                'SilenceScore uses your device microphone to measure ambient noise levels in real-time. When noise stays below your set threshold, you earn points for maintaining silence.',
              ),
              _buildFAQItem(
                'Is my audio recorded?',
                'No! SilenceScore only measures decibel levels. No audio is recorded, stored, or transmitted.',
              ),
              _buildFAQItem(
                'How do I adjust sensitivity?',
                'Go to Settings > Basic > Decibel Threshold to adjust noise sensitivity between 20-60 dB.',
              ),
              _buildFAQItem(
                'What are the premium features?',
                'Premium includes extended sessions (up to 60 minutes), advanced analytics, data export, and premium themes.',
              ),
              _buildFAQItem(
                'How do notifications work?',
                'Smart notifications learn your habits and remind you at optimal times. They also celebrate achievements and session completions.',
              ),
            ],
          ),
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

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
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
    if (!context.mounted) return;
    
    final ref = ProviderScope.containerOf(context);
    final currentTier = ref.read(subscriptionTierStateProvider);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _SupportBottomSheet(userTier: currentTier),
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


  Future<void> _showAccessibilityDialog(BuildContext context, SettingsNotifier settingsNotifier, Map<String, dynamic> settings) async {
    bool enableVibration = settings['enableVibration'] as bool? ?? true;
    bool enableVoiceOver = settings['enableVoiceOver'] as bool? ?? false;
    bool enableHighContrast = settings['enableHighContrast'] as bool? ?? false;
    bool enableLargeText = settings['enableLargeText'] as bool? ?? false;
    
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
                    settingsNotifier.updateSetting('enableVibration', value);
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
                    settingsNotifier.updateSetting('enableVoiceOver', value);
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
                    settingsNotifier.updateSetting('enableHighContrast', value);
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
                    settingsNotifier.updateSetting('enableLargeText', value);
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
          const ThemeSelectorWidget(),
          
          const SizedBox(height: 20),
          
          // Decibel threshold slider - simplified
          _buildSimpleSliderSection(
            context,
            'Decibel Threshold (max noise level)',
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
          
          // Session duration slider (subscription-aware)
          _buildSessionDurationSection(context, settingsNotifier, settings, ref),
          
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
  Widget _buildAdvancedTab(BuildContext context, SettingsNotifier settingsNotifier, Map<String, dynamic> settings, WidgetRef ref) {
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
                  final hasPremiumAccess = ref.read(premiumAccessProvider);
                  if (hasPremiumAccess) {
                    await _showNoiseCalibrationDialog(context, settingsNotifier);
                  } else {
                    showPaywall(
                      context,
                      requiredTier: SubscriptionTier.premium,
                      featureDescription: 'Unlock advanced noise calibration with your premium subscription',
                    );
                  }
                },
                isPremium: true,
                hasPremiumAccess: ref.watch(premiumAccessProvider),
              ),
              _buildAdvancedCard(
                context,
                'Export Data',
                'Session history',
                Icons.file_download,
                () async {
                  await _exportSessionData(context);
                },
                isPremium: true,
                hasPremiumAccess: ref.watch(premiumAccessProvider),
              ),
              _buildAdvancedCard(
                context,
                'Notifications',
                'Smart reminders & celebrations',
                Icons.notifications,
                () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const NotificationSettingsWidget(),
                  );
                },
              ),
              _buildAdvancedCard(
                context,
                'Accessibility',
                'Accessibility features',
                Icons.accessibility,
                () async {
                  await _showAccessibilityDialog(context, settingsNotifier, settings);
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
                  
                  _buildInfoRow(context, 'Version', AppConstants.appVersion),
                  const SizedBox(height: 8),
                  _buildInfoRow(context, 'Bundle ID', 'io.sparkvibe.silencescore'),
                  const SizedBox(height: 8),
                  _buildInfoRow(context, 'Environment', AppConstants.currentEnvironment),
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
                        'FAQ',
                        Icons.quiz,
                        () => _openFAQ(context),
                      ),
                      _buildLinkButton(
                        context,
                        'Support',
                        Icons.help,
                        () => _openSupport(context),
                      ),
                      _buildLinkButton(
                        context,
                        'Privacy',
                        Icons.privacy_tip,
                        () => _openPrivacyPolicy(context),
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

class _SupportBottomSheet extends StatefulWidget {
  final SubscriptionTier userTier;

  const _SupportBottomSheet({required this.userTier});

  @override
  State<_SupportBottomSheet> createState() => _SupportBottomSheetState();
}

class _SupportBottomSheetState extends State<_SupportBottomSheet> {
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supportService = SupportService.instance;
    final priority = supportService.getSupportPriority(widget.userTier);
    final responseTime = supportService.getSupportResponseTime(priority);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // Header with tier badge
          Row(
            children: [
              Icon(
                Icons.support_agent,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Support',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (widget.userTier != SubscriptionTier.free) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.userTier.displayName.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quick help options at top
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Response Time: $responseTime',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openFAQWebsite(context),
                        icon: const Icon(Icons.quiz, size: 18),
                        label: const Text('FAQ'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openDocumentationWebsite(context),
                        icon: const Icon(Icons.article, size: 18),
                        label: const Text('Docs'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Contact form
          Text(
            'Contact Support',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          // Explanation text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.email,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This will open your default email app with system information pre-filled',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Subject field
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              labelText: 'Subject',
              hintText: 'Brief description of your issue',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.subject),
            ),
          ),

          const SizedBox(height: 12),

          // Description field
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Please provide details about your issue...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.description),
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 20),

          // Submit button
          ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _submitSupportRequest,
            icon: _isSubmitting 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            label: Text(_isSubmitting ? 'Opening Email...' : 'Open Email App'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),

          const SizedBox(height: 16),

        ],
        ),  // closes Column
      ),    // closes SingleChildScrollView  
    );      // closes Container
  }

  Future<void> _submitSupportRequest() async {
    if (_subjectController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in both subject and description'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final supportService = SupportService.instance;
      final deviceInfo = await supportService.getDeviceInfo();
      final priority = supportService.getSupportPriority(widget.userTier);

      final ticket = SupportTicket(
        subject: _subjectController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: priority,
        deviceInfo: deviceInfo,
        userTier: widget.userTier.displayName,
      );

      await supportService.openEmailSupport(ticket);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Email app opened! Add any additional details and send the email.'),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('No email app found. Please contact:'),
                SelectableText(
                  'silencescore@sparkvibe.io',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text('Subject: [STANDARD] ${_subjectController.text}'),
                Text('Issue: ${_descriptionController.text}'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'Copy Email',
              onPressed: () {
                // TODO: Copy email details to clipboard
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _openFAQ(BuildContext context) {
    // TODO: Open FAQ URL or in-app FAQ screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('FAQ coming soon!')),
    );
  }

  Future<void> _openFAQWebsite(BuildContext context) async {
    try {
      final supportService = SupportService.instance;
      await supportService.openFAQ();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open FAQ: $e'),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    }
  }

  Future<void> _openDocumentationWebsite(BuildContext context) async {
    try {
      final supportService = SupportService.instance;
      await supportService.openDocumentation();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open documentation: $e'),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    }
  }
}
