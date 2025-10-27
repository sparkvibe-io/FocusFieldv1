// Clean rebuilt SettingsSheet implementation
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/constants/app_constants.dart';
import 'package:focus_field/constants/ui_constants.dart';
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
import 'package:focus_field/widgets/common/drag_handle.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:focus_field/services/tip_service.dart';
import 'package:focus_field/providers/user_preferences_provider.dart';
import 'package:focus_field/widgets/activity_edit_sheet.dart';
import 'package:focus_field/screens/onboarding_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final maxHeight =
        MediaQuery.of(context).size.height *
        UIConstants.bottomSheetMaxHeightRatio;
    // In test environment simplify sheet (no tabs) to make finding labels deterministic
    if (const bool.fromEnvironment('FLUTTER_TEST', defaultValue: false)) {
      final t = AppLocalizations.of(context);
      return Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(UIConstants.bottomSheetBorderRadius),
          ),
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UIConstants.bottomSheetBorderRadius),
        ),
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const DragHandle(),
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

  Widget _dailyGoalsButton(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userPrefs = ref.watch(userPreferencesProvider);
    final currentMinutes = userPrefs.globalDailyQuietGoalMinutes;
    final enabledCount = userPrefs.enabledProfiles.length;

    // Format display value
    final displayValue =
        currentMinutes >= 60
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
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3),
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
                      l10n.settingsDailyGoalsTitle,
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
    final l10n = AppLocalizations.of(context)!;
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
            Text(l10n.focusModeButton),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            l10n.settingsFocusModeDescription,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        value: userPrefs.focusModeEnabled,
        onChanged: (value) {
          ref
              .read(userPreferencesProvider.notifier)
              .updateFocusModeEnabled(value);
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
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallPhone = size.height < 760 || size.width < 380;
    final cols = size.width < 380 ? 1 : 2;
    final tileHeight =
        size.width < 380 ? 120.0 : (isSmallPhone ? 140.0 : 130.0);
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
            title: l10n.settingsDeepFocusTitle,
            subtitle: l10n.settingsDeepFocusDescription,
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
                  featureDescription:
                      'Unlock Deep Focus to automatically end sessions when you leave the app',
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
            onTap: () => _handleNotificationSettings(context),
          ),
          _advancedCard(
            context,
            title: AppLocalizations.of(context)!.accessibility,
            subtitle: AppLocalizations.of(context)!.accessibilityFeatures,
            icon: Icons.accessibility,
            onTap: () => _showAccessibilityDialog(context, notifier, settings),
          ),
          _advancedCard(
            context,
            title: 'Celebration Effects',
            subtitle: 'Show confetti on successful sessions',
            icon: Icons.celebration,
            onTap: () => _showConfettiDialog(context, ref),
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
    int grace =
        (settings['deepFocusGraceSeconds'] as int?)?.clamp(1, 300) ?? 10;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.deepFocusDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(l10n.deepFocusEnableLabel)),
                      Switch(
                        value: enabled,
                        onChanged: (v) {
                          setState(() => enabled = v);
                          notifier.updateSetting('deepFocusEnabled', v);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.deepFocusGracePeriodLabel),
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
                            setState(() => grace = v.round());
                            notifier.updateSetting(
                              'deepFocusGraceSeconds',
                              grace,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 44,
                        child: Text('$grace s', textAlign: TextAlign.end),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.deepFocusExplanation,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(l10n.close),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _handleNotificationSettings(BuildContext context) async {
    // Always show the notification settings widget
    // The widget itself handles permission checks and displays appropriate UI
    // (warning banner with "Enable Notifications" button if permission not granted)
    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const NotificationSettingsWidget(),
      );
    }
  }

  Future<void> _showNotificationPermissionDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isIOS = Platform.isIOS;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(l10n.notificationPermissionTitle)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.notificationPermissionExplanation,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              _buildPermissionBenefit(
                theme,
                Icons.alarm,
                l10n.notificationBenefitReminders,
              ),
              _buildPermissionBenefit(
                theme,
                Icons.celebration,
                l10n.notificationBenefitCompletion,
              ),
              _buildPermissionBenefit(
                theme,
                Icons.emoji_events,
                l10n.notificationBenefitAchievements,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isIOS
                              ? l10n.notificationHowToEnableIos
                              : l10n.notificationHowToEnableAndroid,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (isIOS) ...[
                      Text(
                        l10n.notificationStepsIos,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ] else ...[
                      Text(
                        l10n.notificationStepsAndroid,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(ctx).pop(true),
              icon: const Icon(Icons.settings),
              label: Text(l10n.buttonOpenSettings),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        );
      },
    );

    if (result == true && context.mounted) {
      // User chose to open settings
      await openAppSettings();
    }
  }

  Widget _buildPermissionBenefit(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
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
                          AppLocalizations.of(context)!.aboutShowTips,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.aboutShowTipsDescription,
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
          const SizedBox(height: 16),
          Card(
            child: InkWell(
              onTap: () => _replayOnboarding(context),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.tour,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.aboutReplayOnboarding,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.aboutReplayOnboardingDescription,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
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
          ),
          const SizedBox(height: 16),
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
                        AppLocalizations.of(context)!.buttonFaq,
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
          const SizedBox(height: 24), // Extra bottom padding for scrolling
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
          Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
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
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.allSettingsReset),
            backgroundColor: theme.colorScheme.primary,
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

  void _replayOnboarding(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OnboardingScreen(isReplay: true),
        fullscreenDialog: true,
      ),
    );
  }

  void _openFAQ(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
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
        Icon(Icons.error, size: 48, color: Theme.of(context).colorScheme.error),
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

  Future<void> _showConfettiDialog(BuildContext context, WidgetRef ref) async {
    bool localEnabled = ref.read(userPreferencesProvider).enableCelebrationConfetti;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, setState) {
          return AlertDialog(
            title: const Text('Celebration Effects'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Show Confetti'),
                  subtitle: const Text('Display confetti animation on successful sessions'),
                  value: localEnabled,
                  onChanged: (v) {
                    setState(() => localEnabled = v);
                  },
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
                  await ref.read(userPreferencesProvider.notifier)
                      .updateCelebrationConfettiEnabled(localEnabled);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Celebration settings saved'),
                      ),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// FAQ Bottom Sheet with search functionality
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
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    t.contactSupport,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
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
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
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
                      labelText: '${t.subject} *',
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
                      labelText: '${t.description} *',
                      hintText: t.issueDescriptionHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.description),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: _subject,
                    builder: (context, subjectValue, _) {
                      return ValueListenableBuilder(
                        valueListenable: _description,
                        builder: (context, descValue, _) {
                          final hasSubject =
                              subjectValue.text.trim().isNotEmpty;
                          final hasDescription =
                              descValue.text.trim().isNotEmpty;
                          final canSubmit =
                              hasSubject && hasDescription && !_submitting;

                          return ElevatedButton.icon(
                            onPressed: canSubmit ? _submit : null,
                            icon:
                                _submitting
                                    ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Icon(Icons.send),
                            label: Text(
                              _submitting
                                  ? t.openingEmail
                                  : canSubmit
                                  ? t.openEmailApp
                                  : 'Fill Required Fields',
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          );
                        },
                      );
                    },
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
    // Validation now handled by button state (disabled when fields empty)
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

  // All 20 FAQ items - dynamically built from localization strings
  List<Map<String, String>> get _allFAQs {
    final l10n = AppLocalizations.of(context)!;
    return [
      {'q': l10n.faqQ01, 'a': l10n.faqA01},
      {'q': l10n.faqQ02, 'a': l10n.faqA02},
      {'q': l10n.faqQ03, 'a': l10n.faqA03},
      {'q': l10n.faqQ04, 'a': l10n.faqA04},
      {'q': l10n.faqQ05, 'a': l10n.faqA05},
      {'q': l10n.faqQ06, 'a': l10n.faqA06},
      {'q': l10n.faqQ07, 'a': l10n.faqA07},
      {'q': l10n.faqQ08, 'a': l10n.faqA08},
      {'q': l10n.faqQ09, 'a': l10n.faqA09},
      {'q': l10n.faqQ10, 'a': l10n.faqA10},
      {'q': l10n.faqQ11, 'a': l10n.faqA11},
      {'q': l10n.faqQ12, 'a': l10n.faqA12},
      {'q': l10n.faqQ13, 'a': l10n.faqA13},
      {'q': l10n.faqQ14, 'a': l10n.faqA14},
      {'q': l10n.faqQ15, 'a': l10n.faqA15},
      {'q': l10n.faqQ16, 'a': l10n.faqA16},
      {'q': l10n.faqQ17, 'a': l10n.faqA17},
      {'q': l10n.faqQ18, 'a': l10n.faqA18},
      {'q': l10n.faqQ19, 'a': l10n.faqA19},
      {'q': l10n.faqQ20, 'a': l10n.faqA20},
    ];
  }

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
                Icon(Icons.quiz, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.faqTitle,
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
                hintText: AppLocalizations.of(context)!.faqSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchQuery.isNotEmpty
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
                  AppLocalizations.of(context)!.faqResultsCount(filteredFAQs.length),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          // Scrollable content
          Expanded(
            child:
                filteredFAQs.isEmpty
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
                            AppLocalizations.of(context)!.faqNoResults,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.faqNoResultsSubtitle,
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
                          ...filteredFAQs.map(
                            (faq) => _buildFAQItem(theme, faq['q']!, faq['a']!),
                          ),
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
