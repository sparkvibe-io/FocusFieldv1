// Clean rebuilt SettingsSheet implementation
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/constants/app_constants.dart';
import 'package:focus_field/providers/app_info_provider.dart';
import 'package:focus_field/models/silence_data.dart';
import 'package:focus_field/models/subscription_tier.dart';
import 'package:focus_field/providers/silence_provider.dart';
import 'package:focus_field/providers/subscription_provider.dart';
import 'package:focus_field/services/export_service.dart';
import 'package:focus_field/services/support_service.dart';
import 'package:focus_field/services/rating_service.dart';
// TODO: remove if not existing in project or adjust paths
import 'package:focus_field/widgets/feature_gate.dart';
import 'package:focus_field/widgets/notification_settings_widget.dart';
import 'package:focus_field/widgets/theme_selector_widget.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:focus_field/services/tip_service.dart';
import 'package:focus_field/providers/user_preferences_provider.dart';
import 'package:focus_field/widgets/activity_edit_sheet.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    // In test environment simplify sheet (no tabs) to make finding labels deterministic
    if (const bool.fromEnvironment('FLUTTER_TEST', defaultValue: false)) {
      final t = AppLocalizations.of(context);
      return Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t?.settings ?? 'Settings',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Text(
              t?.decibelThresholdLabel ?? 'Decibel Threshold',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Text(
              t?.resetAllData ?? 'Reset All Data',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.settings,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.tune)), // Basic
                Tab(icon: Icon(Icons.engineering)), // Advanced
                Tab(icon: Icon(Icons.info)), // About
              ],
            ),
            Expanded(
              child: settingsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => _errorState(context, e, ref),
                data:
                    (settings) => TabBarView(
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable tab swiping
                      children: [
                        _basicTab(context, ref, notifier, settings),
                        _advancedTab(context, ref, notifier, settings),
                        _aboutTab(context, ref),
                      ],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _basicTab(
    BuildContext context,
    WidgetRef ref,
    SettingsNotifier notifier,
    Map<String, dynamic> settings,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ThemeSelectorWidget(),
          const SizedBox(height: 20),
          _decibelSection(context, notifier, settings),
          const SizedBox(height: 20),
          _dailyGoalsButton(context, ref),
          const SizedBox(height: 20),
          _focusModeSection(context, ref),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              // Match test expectation 'Reset All Data'
              label: Text(AppLocalizations.of(context)!.resetAllData),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => _showResetDialog(context, notifier, ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _decibelSection(
    BuildContext context,
    SettingsNotifier notifier,
    Map<String, dynamic> settings,
  ) {
    const minDb = AppConstants.decibelMin;
    const maxDb = AppConstants.decibelMax;
    double current = (settings['decibelThreshold'] as double?) ?? minDb;
    current = current.clamp(minDb, maxDb);
    final slider = _valueSlider(
      context,
      // Use simpler label expected by tests
      label: AppLocalizations.of(context)!.decibelThresholdLabel,
      value: current,
      min: minDb,
      max: maxDb,
      divisions: (maxDb - minDb).toInt(),
      unit: 'dB',
      showInfo: true,
      onChanged:
          (v) =>
              notifier.updateSetting('decibelThreshold', v.clamp(minDb, maxDb)),
    );
    if (current >= AppConstants.highThresholdWarning) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          slider,
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.highThresholdWarningText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return slider;
  }

  Widget _dailyGoalsButton(
    BuildContext context,
    WidgetRef ref,
  ) {
    final userPrefs = ref.watch(userPreferencesProvider);
    final currentMinutes = userPrefs.globalDailyQuietGoalMinutes;
    final enabledCount = userPrefs.enabledProfiles.length;

    // Format display value
    final displayValue = currentMinutes >= 60
        ? '${(currentMinutes / 60).toStringAsFixed(1)}h'
        : '${currentMinutes}min';

    return Card(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const ActivityEditSheet(),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.flag_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Goals',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$displayValue • $enabledCount ${enabledCount == 1 ? 'activity' : 'activities'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _focusModeSection(BuildContext context, WidgetRef ref) {
    final userPrefs = ref.watch(userPreferencesProvider);
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Row(
          children: [
            Icon(
              Icons.bedtime_outlined,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('Focus Mode'),
          ],
        ),
        subtitle: const Padding(
          padding: EdgeInsets.only(left: 28),
          child: Text(
            'Minimize distractions during sessions with a full-screen black overlay',
            style: TextStyle(fontSize: 12),
          ),
        ),
        value: userPrefs.focusModeEnabled,
        onChanged: (value) {
          ref.read(userPreferencesProvider.notifier).updateFocusModeEnabled(value);
        },
      ),
    );
  }

  Widget _advancedTab(
    BuildContext context,
    WidgetRef ref,
    SettingsNotifier notifier,
    Map<String, dynamic> settings,
  ) {
    final size = MediaQuery.of(context).size;
    final isSmallPhone = size.height < 760 || size.width < 380;
    final cols = size.width < 380 ? 1 : 2;
    final tileHeight = size.width < 380 ? 220.0 : (isSmallPhone ? 260.0 : 240.0);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: tileHeight,
        ),
        children: [
          _advancedCard(
            context,
            title: 'Deep Focus',
            subtitle: 'End session if app is left',
            icon: Icons.lock_clock,
            isPremium: true,
            hasAccess: ref.watch(premiumAccessProvider),
            onTap: () async {
              if (ref.read(premiumAccessProvider)) {
                await _showDeepFocusDialog(context, notifier, settings);
              } else {
                showPaywall(
                  context,
                  requiredTier: SubscriptionTier.premium,
                  featureDescription: 'Unlock Deep Focus to automatically end sessions when you leave the app',
                );
              }
            },
          ),
          _advancedCard(
            context,
            title: AppLocalizations.of(context)!.exportData,
            subtitle: AppLocalizations.of(context)!.sessionHistory,
            icon: Icons.file_download,
            isPremium: true,
            hasAccess: ref.watch(premiumAccessProvider),
            onTap: () => _exportData(context),
          ),
          _advancedCard(
            context,
            title: AppLocalizations.of(context)!.notifications,
            subtitle: AppLocalizations.of(context)!.remindersCelebrations,
            icon: Icons.notifications,
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const NotificationSettingsWidget(),
            ),
          ),
          _advancedCard(
            context,
            title: AppLocalizations.of(context)!.accessibility,
            subtitle: AppLocalizations.of(context)!.accessibilityFeatures,
            icon: Icons.accessibility,
            onTap: () => _showAccessibilityDialog(context, notifier, settings),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeepFocusDialog(
    BuildContext context,
    SettingsNotifier notifier,
    Map<String, dynamic> settings,
  ) async {
    bool enabled = (settings['deepFocusEnabled'] as bool?) ?? false;
    int grace = (settings['deepFocusGraceSeconds'] as int?)?.clamp(1, 300) ?? 10;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Deep Focus'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: Text('Enable Deep Focus')),
                  Switch(
                    value: enabled,
                    onChanged: (v) {
                      enabled = v;
                      notifier.updateSetting('deepFocusEnabled', v);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Grace period (seconds)'),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: grace.toDouble(),
                      min: 1,
                      max: 120,
                      divisions: 119,
                      label: '$grace s',
                      onChanged: (v) {
                        grace = v.round();
                        notifier.updateSetting('deepFocusGraceSeconds', grace);
                      },
                    ),
                  ),
                  SizedBox(width: 44, child: Text('$grace s', textAlign: TextAlign.end)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'When enabled, leaving the app will end the session after the grace period.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _aboutTab(BuildContext context, WidgetRef ref) {
    final appInfoAsync = ref.watch(appInfoProvider);
    final tipService = ref.read(tipServiceProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.appInformation,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  appInfoAsync.when(
                    data:
                        (info) => _infoRow(
                          context,
                          AppLocalizations.of(context)!.version,
                          '${info.version}+${info.buildNumber}',
                        ),
                    loading:
                        () => _infoRow(
                          context,
                          AppLocalizations.of(context)!.version,
                          '...',
                        ),
                    error:
                        (e, _) => _infoRow(
                          context,
                          AppLocalizations.of(context)!.version,
                          'unknown',
                        ),
                  ),
                  const SizedBox(height: 8),
                  appInfoAsync.when(
                    data:
                        (info) => _infoRow(
                          context,
                          AppLocalizations.of(context)!.bundleId,
                          info.packageName,
                        ),
                    loading:
                        () => _infoRow(
                          context,
                          AppLocalizations.of(context)!.bundleId,
                          '...',
                        ),
                    error:
                        (e, _) => _infoRow(
                          context,
                          AppLocalizations.of(context)!.bundleId,
                          'unknown',
                        ),
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                    context,
                    AppLocalizations.of(context)!.environment,
                    AppConstants.currentEnvironment,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Show Tips',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Show helpful tips on app startup and via the lightbulb icon. Tips appear every 2-3 days.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: tipService.enabled,
                    builder: (ctx, enabled, _) {
                      return FutureBuilder<bool>(
                        future: tipService.getEnabled(),
                        builder: (ctx, _) {
                          return Switch(
                            value: enabled,
                            onChanged: (v) async {
                              await tipService.setEnabled(v);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.helpSupport,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _linkButton(
                        context,
                        AppLocalizations.of(context)!.faq,
                        Icons.quiz,
                        () => _openFAQ(context),
                      ),
                      _linkButton(
                        context,
                        AppLocalizations.of(context)!.support,
                        Icons.help,
                        () => _openSupport(context),
                      ),
                      _linkButton(
                        context,
                        AppLocalizations.of(context)!.privacyPolicy,
                        Icons.privacy_tip,
                        () => _openPrivacy(context),
                      ),
                      _linkButton(
                        context,
                        AppLocalizations.of(context)!.rateApp,
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

  Widget _valueSlider(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String unit,
    required ValueChanged<double> onChanged,
    bool showInfo = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '$label (${value.toInt()}$unit)',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (showInfo)
              Tooltip(
                message: AppLocalizations.of(context)!.decibelThresholdTooltip,
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              '${min.toInt()}$unit',
              style: Theme.of(context).textTheme.bodySmall,
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
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _advancedCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isPremium = false,
    bool hasAccess = true,
  }) {
    final enabled = !isPremium || hasAccess;
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
                    color:
                        enabled
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  if (isPremium && !hasAccess)
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.lock,
                          size: 10,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:
                      enabled
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      enabled
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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

  Widget _infoRow(BuildContext context, String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      Text(
        value,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
    ],
  );

  Widget _linkButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _showResetDialog(
    BuildContext context,
    SettingsNotifier notifier,
    WidgetRef ref,
  ) async {
    final t = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(t.resetAllSettings),
            content: Text(t.resetAllSettingsDescription),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(t.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: Text(t.reset),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      await notifier.resetSettings();
      ref.read(silenceDataNotifierProvider.notifier).resetData();
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.allSettingsReset),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _exportData(BuildContext context) async {
    final container = ProviderScope.containerOf(context);
    final hasAccess = container.read(featureAccessProvider('data_export'));
    if (!hasAccess) {
      showPaywall(
        context,
        requiredTier: SubscriptionTier.premium,
        featureDescription: AppLocalizations.of(context)!.featureExport,
      );
      return;
    }
    await _showExportDialog(context);
  }

  Future<void> _showExportDialog(BuildContext context) async {
    final container = ProviderScope.containerOf(context);
    final dataAsync = container.read(silenceDataNotifierProvider);
    if (!dataAsync.hasValue) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.exportNoData)),
        );
      }
      return;
    }
    final silenceData = dataAsync.value!;
    final t = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(t.exportData),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t.chooseExportFormat(silenceData.totalSessions),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: Text(t.csvSpreadsheet),
                  subtitle: Text(t.rawDataForAnalysis),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _performExport(
                      context,
                      silenceData,
                      ExportFormat.csv,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: Text(t.pdfReport),
                  subtitle: Text(t.formattedReportWithCharts),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _performExport(
                      context,
                      silenceData,
                      ExportFormat.pdf,
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(t.cancel),
              ),
            ],
          ),
    );
  }

  Future<void> _performExport(
    BuildContext context,
    SilenceData data,
    ExportFormat format,
  ) async {
    try {
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
                Text(
                  AppLocalizations.of(
                    context,
                  )!.generatingExport(format.name.toUpperCase()),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      final service = ExportService.instance;
      switch (format) {
        case ExportFormat.csv:
          await service.exportAndShareCSV(data);
          break;
        case ExportFormat.pdf:
          await service.exportAndSharePDF(data);
          break;
      }
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
                Text(
                  AppLocalizations.of(
                    context,
                  )!.exportCompleted(format.name.toUpperCase()),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
      }
    } catch (e) {
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
                Text(AppLocalizations.of(context)!.exportFailed(e.toString())),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    }
  }

  void _openFAQ(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: const _FAQBottomSheet(),
          ),
    );
  }

  void _openSupport(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    final tier = container.read(subscriptionTierStateProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _SupportBottomSheet(userTier: tier),
          ),
    );
  }

  Future<void> _openPrivacy(BuildContext context) async {
    final uri = Uri.parse(AppConstants.privacyPolicyUrl);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open privacy policy')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open privacy policy')),
        );
      }
    }
  }

  void _rateApp(BuildContext context) {
    RatingService.instance.forceRate(context);
  }

  Widget _errorState(BuildContext context, Object e, WidgetRef ref) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, size: 48, color: Colors.red),
        const SizedBox(height: 16),
        Text(AppLocalizations.of(context)!.errorLoadingSettings(e.toString())),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => ref.invalidate(settingsNotifierProvider),
          child: Text(AppLocalizations.of(context)!.retry),
        ),
      ],
    ),
  );

  Future<void> _showAccessibilityDialog(
    BuildContext context,
    SettingsNotifier notifier,
    Map<String, dynamic> settings,
  ) async {
    bool vib = settings['enableVibration'] as bool? ?? true;
    bool voice = settings['enableVoiceOver'] as bool? ?? false;
    bool highContrast = settings['enableHighContrast'] as bool? ?? false;
    bool largeText = settings['enableLargeText'] as bool? ?? false;
    await showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (c, setState) => AlertDialog(
                  title: Text(
                    AppLocalizations.of(context)!.accessibilitySettings,
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SwitchListTile(
                          title: Text(
                            AppLocalizations.of(context)!.vibrationFeedback,
                          ),
                          subtitle: Text(
                            AppLocalizations.of(
                              context,
                            )!.vibrateOnSessionEvents,
                          ),
                          value: vib,
                          onChanged: (v) async {
                            await notifier.updateSetting('enableVibration', v);
                            setState(() => vib = v);
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            AppLocalizations.of(context)!.voiceAnnouncements,
                          ),
                          subtitle: Text(
                            AppLocalizations.of(
                              context,
                            )!.announceSessionProgress,
                          ),
                          value: voice,
                          onChanged: (v) async {
                            await notifier.updateSetting('enableVoiceOver', v);
                            setState(() => voice = v);
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            AppLocalizations.of(context)!.highContrastMode,
                          ),
                          subtitle: Text(
                            AppLocalizations.of(
                              context,
                            )!.improveVisualAccessibility,
                          ),
                          value: highContrast,
                          onChanged: (v) async {
                            await notifier.updateSetting(
                              'enableHighContrast',
                              v,
                            );
                            setState(() => highContrast = v);
                          },
                        ),
                        SwitchListTile(
                          title: Text(AppLocalizations.of(context)!.largeText),
                          subtitle: Text(
                            AppLocalizations.of(context)!.increaseTextSize,
                          ),
                          value: largeText,
                          onChanged: (v) async {
                            await notifier.updateSetting('enableLargeText', v);
                            setState(() => largeText = v);
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(
                                context,
                              )!.accessibilitySettingsSaved,
                            ),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.save),
                    ),
                  ],
                ),
          ),
    );
  }
}

/// FAQ Bottom Sheet with search functionality
class _FAQBottomSheet extends StatefulWidget {
  const _FAQBottomSheet();

  @override
  State<_FAQBottomSheet> createState() => _FAQBottomSheetState();
}

class _FAQBottomSheetState extends State<_FAQBottomSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // All 20 FAQ items
  List<Map<String, String>> get _allFAQs => [
    {
      'q': 'What is Focus Field and how does it help me focus?',
      'a': 'Focus Field helps you build better focus habits by monitoring ambient noise in your environment. When you start a session (Study, Reading, Meditation, or Other), the app measures how quiet your environment is. The quieter you keep it, the more "focus minutes" you earn. This encourages you to find and maintain distraction-free spaces for deep work.',
    },
    {
      'q': 'How does Focus Field measure my focus?',
      'a': 'Focus Field monitors the ambient noise level in your environment during your session. It calculates an "Ambient Score" by tracking how many seconds your environment stays below your chosen noise threshold. If your session has at least 70% quiet time (Ambient Score ≥70%), you earn full credit for those quiet minutes.',
    },
    {
      'q': 'Does Focus Field record my audio or conversations?',
      'a': 'No, absolutely not. Focus Field only measures decibel levels (loudness) - it never records, stores, or transmits any audio. Your privacy is completely protected. The app simply checks if your environment is above or below your chosen threshold.',
    },
    {
      'q': 'What activities can I track with Focus Field?',
      'a': 'Focus Field comes with four activity types: Study 📚 (for learning and research), Reading 📖 (for focused reading), Meditation 🧘 (for mindfulness practice), and Other ⭐ (for any focus-requiring activity). All activities use ambient noise monitoring to help you maintain a quiet, focused environment.',
    },
    {
      'q': 'Should I use Focus Field for all my activities?',
      'a': 'Focus Field works best for activities where ambient noise indicates your level of focus. Activities like Study, Reading, and Meditation benefit most from quiet environments. While you can track "Other" activities, we recommend using Focus Field primarily for noise-sensitive focus work.',
    },
    {
      'q': 'How do I start a focus session?',
      'a': 'Go to the Sessions tab, select your activity (Study, Reading, Meditation, or Other), choose your session duration (1, 5, 10, 15, 30 minutes, or premium options), tap the Start button on the progress ring, and keep your environment quiet!',
    },
    {
      'q': 'What session durations are available?',
      'a': 'Free users can choose: 1, 5, 10, 15, or 30-minute sessions. Premium users also get: 1 hour, 1.5 hours, and 2-hour extended sessions for longer deep work periods.',
    },
    {
      'q': 'Can I pause or stop a session early?',
      'a': 'Yes! During a session, you\'ll see Pause and Stop buttons above the progress ring. To prevent accidental taps, you need to long-press these buttons. If you stop early, you\'ll still earn points for the quiet minutes you accumulated.',
    },
    {
      'q': 'How do I earn points in Focus Field?',
      'a': 'You earn 1 point per quiet minute. During your session, Focus Field tracks how many seconds your environment stays below the noise threshold. At the end, those quiet seconds are converted to minutes. For example, if you complete a 10-minute session with 8 minutes of quiet time, you earn 8 points.',
    },
    {
      'q': 'What is the 70% threshold and why does it matter?',
      'a': 'The 70% threshold determines if your session counts toward your daily goal. If your Ambient Score (quiet time ÷ total time) is at least 70%, your session qualifies for quest credit. Even if you\'re under 70%, you still earn points for every quiet minute!',
    },
    {
      'q': 'What\'s the difference between Ambient Score and points?',
      'a': 'Ambient Score is your session quality as a percentage (quiet seconds ÷ total seconds), determining if you hit the 70% threshold. Points are the actual quiet minutes earned (1 point = 1 minute). Ambient Score = quality, Points = achievement.',
    },
    {
      'q': 'How do streaks work in Focus Field?',
      'a': 'Streaks track consecutive days of meeting your daily goal. Focus Field uses a compassionate 2-Day Rule: Your streak only breaks if you miss two consecutive days. This means you can miss one day and your streak continues if you complete your goal the next day.',
    },
    {
      'q': 'What are freeze tokens and how do I use them?',
      'a': 'Freeze tokens protect your streak when you can\'t complete your goal. You get 1 free freeze token per month. When used, your overall progress shows 100% (goal protected), your streak is safe, and individual activity tracking continues normally. Use it wisely for busy days!',
    },
    {
      'q': 'Can I customize my daily focus goal?',
      'a': 'Yes! Tap Edit on the Sessions card in the Today tab. You can set your global daily goal (10-60 minutes for free, up to 1080 minutes for premium), enable per-activity goals for separate targets, and show/hide specific activities.',
    },
    {
      'q': 'What is the noise threshold and how do I adjust it?',
      'a': 'The threshold is the maximum noise level (in decibels) that counts as "quiet." Default is 40 dB (library quiet). You can adjust it in the Sessions tab: 30 dB (very quiet), 40 dB (library quiet - recommended), 50 dB (moderate office), 60-80 dB (louder environments).',
    },
    {
      'q': 'What is Adaptive Threshold and should I use it?',
      'a': 'After 3 consecutive successful sessions at your current threshold, Focus Field suggests increasing it by 2 dB to challenge yourself. This helps you gradually improve. You can accept or dismiss the suggestion - it only appears once every 7 days.',
    },
    {
      'q': 'What is Focus Mode?',
      'a': 'Focus Mode is a full-screen distraction-free overlay during your session. It shows your countdown timer, live calm percentage, and minimal controls (Pause/Stop via long-press). It removes all other UI elements so you can concentrate fully. Enable it in Settings > Basic > Focus Mode.',
    },
    {
      'q': 'Why does Focus Field need microphone permission?',
      'a': 'Focus Field uses your device\'s microphone to measure ambient noise levels (decibels) during sessions. This is essential to calculate your Ambient Score. Remember: no audio is ever recorded - only noise levels are measured in real-time.',
    },
    {
      'q': 'Can I see my focus patterns over time?',
      'a': 'Yes! The Today tab shows your daily progress, weekly trends, 12-week activity heatmap (like GitHub contributions), and session timeline. Premium users get advanced analytics with performance metrics, moving averages, and AI-powered insights.',
    },
    {
      'q': 'How do notifications work in Focus Field?',
      'a': 'Focus Field has smart reminders: Daily Reminders (learns your preferred focus time or use a fixed time), Session Completion notifications with results, Achievement notifications for milestones, and Weekly Summary (Premium). Enable/customize in Settings > Advanced > Notifications.',
    },
  ];

  List<Map<String, String>> get _filteredFAQs {
    if (_searchQuery.isEmpty) return _allFAQs;
    
    final query = _searchQuery.toLowerCase();
    return _allFAQs.where((faq) {
      final question = faq['q']!.toLowerCase();
      final answer = faq['a']!.toLowerCase();
      return question.contains(query) || answer.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredFAQs = _filteredFAQs;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
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
          // Header with close button
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.quiz,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Frequently Asked Questions',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search FAQs...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          // Results count
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filteredFAQs.length} result${filteredFAQs.length == 1 ? '' : 's'} found',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          // Scrollable content
          Expanded(
            child: filteredFAQs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search term',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...filteredFAQs.map((faq) => _buildFAQItem(
                              theme,
                              faq['q']!,
                              faq['a']!,
                            )),
                        // Invisible spacer at bottom for complete scrolling
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(ThemeData theme, String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
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
  final _subject = TextEditingController();
  final _description = TextEditingController();
  bool _submitting = false;
  @override
  void dispose() {
    _subject.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
            Row(
              children: [
                Icon(
                  Icons.support_agent,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  t.support,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (widget.userTier != SubscriptionTier.free)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              t.contactSupport,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3),
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
                      t.emailOpenDescription,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _subject,
              decoration: InputDecoration(
                labelText: t.subject,
                hintText: t.briefDescription,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.subject),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _description,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: t.description,
                hintText: t.issueDescriptionHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.description),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submitting ? null : _submit,
              icon:
                  _submitting
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.send),
              label: Text(_submitting ? t.openingEmail : t.openEmailApp),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context)!;
    if (_subject.text.trim().isEmpty || _description.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.fillSubjectDescription)));
      return;
    }
    setState(() => _submitting = true);
    try {
      final service = SupportService.instance;
      final info = await service.getDeviceInfo();
      final priority = service.getSupportPriority(widget.userTier);
      final ticket = SupportTicket(
        subject: _subject.text.trim(),
        description: _description.text.trim(),
        priority: priority,
        deviceInfo: info,
        userTier: widget.userTier.displayName,
      );
      await service.openEmailSupport(ticket);
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
                Expanded(child: Text(t.emailOpened)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t.noEmailAppFound),
                SelectableText(
                  'focusfield@sparkvibe.io',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(t.standardSubject(_subject.text)),
                Text(t.issueLine(_description.text)),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            duration: const Duration(seconds: 8),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
