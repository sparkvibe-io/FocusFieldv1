// Clean rebuilt SettingsSheet implementation
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/models/silence_data.dart';
import 'package:silence_score/models/subscription_tier.dart';
import 'package:silence_score/providers/silence_provider.dart';
import 'package:silence_score/providers/subscription_provider.dart';
import 'package:silence_score/services/export_service.dart';
import 'package:silence_score/services/noise_calibration_service.dart';
import 'package:silence_score/services/support_service.dart';
// TODO: remove if not existing in project or adjust paths
import 'package:silence_score/widgets/feature_gate.dart';
import 'package:silence_score/widgets/notification_settings_widget.dart';
import 'package:silence_score/widgets/theme_selector_widget.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(children: [
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
            child: Row(children: [
              Text(AppConstants.settingsTitle, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            ]),
          ),
          TabBar(tabs: const [
            Tab(icon: Icon(Icons.tune), text: 'Basic'),
            Tab(icon: Icon(Icons.engineering), text: 'Advanced'),
            Tab(icon: Icon(Icons.info), text: 'About'),
          ]),
          Expanded(
            child: settingsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _errorState(context, e, ref),
              data: (settings) => TabBarView(children: [
                _basicTab(context, ref, notifier, settings),
                _advancedTab(context, ref, notifier, settings),
                _aboutTab(context, ref),
              ]),
            ),
          )
        ]),
      ),
    );
  }

  Widget _basicTab(BuildContext context, WidgetRef ref, SettingsNotifier notifier, Map<String, dynamic> settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const ThemeSelectorWidget(),
        const SizedBox(height: 20),
        _decibelSection(context, notifier, settings),
        const SizedBox(height: 20),
        _sessionDurationSection(context, ref, notifier, settings),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
            child: ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Reset All Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => _showResetDialog(context, notifier, ref),
          ),
        ),
      ]),
    );
  }

  Widget _decibelSection(BuildContext context, SettingsNotifier notifier, Map<String, dynamic> settings) {
    const minDb = AppConstants.decibelMin;
    const maxDb = AppConstants.decibelMax;
    double current = (settings['decibelThreshold'] as double?) ?? minDb;
    current = current.clamp(minDb, maxDb);
    final slider = _valueSlider(
      context,
      label: 'Decibel Threshold (max noise level)',
      value: current,
      min: minDb,
      max: maxDb,
      divisions: (maxDb - minDb).toInt(),
      unit: 'dB',
      showInfo: true,
      onChanged: (v) => notifier.updateSetting('decibelThreshold', v.clamp(minDb, maxDb)),
    );
    if (current >= AppConstants.highThresholdWarning) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        slider,
        const SizedBox(height: 8),
        Row(children: [
          Icon(Icons.warning_amber_rounded, size: 18, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text('High threshold may ignore meaningful noise events.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error)),
          )
        ])
      ]);
    }
    return slider;
  }

  Widget _sessionDurationSection(BuildContext context, WidgetRef ref, SettingsNotifier notifier, Map<String, dynamic> settings) {
    final maxMinutes = ref.watch(maxSessionMinutesProvider);
    final tier = ref.watch(subscriptionTierStateProvider);
    final currentMinutes = ((settings['sessionDuration'] ?? AppConstants.silenceDurationSeconds) as int) / 60.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Session Duration', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        if (tier != SubscriptionTier.free) Icon(Icons.workspace_premium, size: 16, color: Theme.of(context).colorScheme.primary),
        if (tier == SubscriptionTier.free && maxMinutes < SubscriptionTier.premium.maxSessionMinutes) ...[
          const Spacer(),
          InkWell(
            onTap: () => showPaywall(context, requiredTier: SubscriptionTier.premium),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.upgrade, size: 12, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 3),
                Text('Upgrade for ${SubscriptionTier.premium.maxSessionMinutes}m',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: 10, fontWeight: FontWeight.w500)),
              ]),
            ),
          )
        ]
      ]),
      const SizedBox(height: 4),
      Text('Free: up to $maxMinutes min', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      const SizedBox(height: 12),
      _valueSlider(
        context,
        label: 'Duration',
        value: currentMinutes.clamp(1.0, maxMinutes.toDouble()),
        min: 1,
        max: maxMinutes.toDouble(),
        divisions: maxMinutes - 1,
        unit: 'min',
        onChanged: (v) => notifier.updateSetting('sessionDuration', (v * 60).round()),
      ),
    ]);
  }

  Widget _advancedTab(BuildContext context, WidgetRef ref, SettingsNotifier notifier, Map<String, dynamic> settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
        children: [
          _advancedCard(
            context,
            title: 'Noise Calibration',
            subtitle: 'Calibrate baseline',
            icon: Icons.equalizer,
            isPremium: true,
            hasAccess: ref.watch(premiumAccessProvider),
            onTap: () async {
              if (ref.read(premiumAccessProvider)) {
                await _showCalibrationDialog(context, notifier);
              } else {
                showPaywall(context, requiredTier: SubscriptionTier.premium, featureDescription: 'Unlock advanced noise calibration');
              }
            },
          ),
          _advancedCard(
            context,
            title: 'Export Data',
            subtitle: 'Session history',
            icon: Icons.file_download,
            isPremium: true,
            hasAccess: ref.watch(premiumAccessProvider),
            onTap: () => _exportData(context),
          ),
          _advancedCard(
            context,
            title: 'Notifications',
            subtitle: 'Reminders & celebrations',
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
            title: 'Accessibility',
            subtitle: 'Accessibility features',
            icon: Icons.accessibility,
            onTap: () => _showAccessibilityDialog(context, notifier, settings),
          ),
        ],
      ),
    );
  }

  Widget _aboutTab(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text('App Information', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 16),
              _infoRow(context, 'Version', AppConstants.appVersion),
              const SizedBox(height: 8),
              _infoRow(context, 'Bundle ID', 'io.sparkvibe.silencescore'),
              const SizedBox(height: 8),
              _infoRow(context, 'Environment', AppConstants.currentEnvironment),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Help & Support', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _linkButton(context, 'FAQ', Icons.quiz, () => _openFAQ(context)),
                _linkButton(context, 'Support', Icons.help, () => _openSupport(context)),
                _linkButton(context, 'Privacy', Icons.privacy_tip, () => _openPrivacy(context)),
                _linkButton(context, 'Rate App', Icons.star, () => _rateApp(context)),
              ])
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _valueSlider(BuildContext context, {required String label, required double value, required double min, required double max, required int divisions, required String unit, required ValueChanged<double> onChanged, bool showInfo = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
        if (showInfo)
          Tooltip(
            message: 'Typical quiet spaces: 30–40 dB. Calibrate; raise only if normal hum counts as noise.',
            triggerMode: TooltipTriggerMode.tap,
            child: Icon(Icons.info_outline, size: 18, color: Theme.of(context).colorScheme.primary),
          ),
      ]),
      const SizedBox(height: 6),
      Row(children: [
        Text('${min.toInt()}$unit', style: Theme.of(context).textTheme.bodySmall),
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
        Text('${max.toInt()}$unit', style: Theme.of(context).textTheme.bodySmall),
      ]),
      Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
          child: Text('${value.toInt()}$unit', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer, fontWeight: FontWeight.w600)),
        ),
      )
    ]);
  }

  Widget _advancedCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap, bool isPremium = false, bool hasAccess = true}) {
    final enabled = !isPremium || hasAccess;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(alignment: Alignment.center, children: [
              Icon(icon, size: 28, color: enabled ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
              if (isPremium && !hasAccess)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle, border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1.5)),
                    child: Icon(Icons.lock, size: 10, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                )
            ]),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: enabled ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withOpacity(0.5)), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: enabled ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5)), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
          ]),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
  ]);

  Widget _linkButton(BuildContext context, String label, IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
      ]),
    ),
  );

  Future<void> _showResetDialog(BuildContext context, SettingsNotifier notifier, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset All Settings'),
        content: const Text('This will reset all settings and data. Cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error, foregroundColor: Theme.of(context).colorScheme.onError),
            child: const Text('Reset'),
          )
        ],
      ),
    );
    if (confirmed == true) {
      await notifier.resetSettings();
      ref.read(silenceDataNotifierProvider.notifier).resetData();
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All settings and data have been reset'), backgroundColor: Colors.green));
      }
    }
  }

  Future<void> _showCalibrationDialog(BuildContext context, SettingsNotifier notifier) async {
    final container = ProviderScope.containerOf(context);
    double? prev;
    final async = container.read(appSettingsProvider);
    if (async.hasValue) prev = async.value?['decibelThreshold'] as double?;
    await showDialog(context: context, builder: (_) => _NoiseCalibrationDialog(settingsNotifier: notifier, previousThreshold: prev));
  }

  Future<void> _exportData(BuildContext context) async {
    final container = ProviderScope.containerOf(context);
    final hasAccess = container.read(featureAccessProvider('data_export'));
    if (!hasAccess) {
      showPaywall(context, requiredTier: SubscriptionTier.premium, featureDescription: 'Export your session data');
      return;
    }
    await _showExportDialog(context);
  }

  Future<void> _showExportDialog(BuildContext context) async {
    final container = ProviderScope.containerOf(context);
    final dataAsync = container.read(silenceDataNotifierProvider);
    if (!dataAsync.hasValue) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data available to export')));
      }
      return;
    }
    final silenceData = dataAsync.value!;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(children: [Icon(Icons.workspace_premium, color: Theme.of(context).colorScheme.primary, size: 20), const SizedBox(width: 8), const Text('Export Data')]),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Choose export format for your ${silenceData.totalSessions} sessions:', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('CSV Spreadsheet'),
            subtitle: const Text('Raw data for analysis'),
            onTap: () async { Navigator.of(context).pop(); await _performExport(context, silenceData, ExportFormat.csv); },
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('PDF Report'),
            subtitle: const Text('Formatted report with charts'),
            onTap: () async { Navigator.of(context).pop(); await _performExport(context, silenceData, ExportFormat.pdf); },
          )
        ]),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel'))],
      ),
    );
  }

  Future<void> _performExport(BuildContext context, SilenceData data, ExportFormat format) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: 12),
            Text('Generating ${format.name.toUpperCase()} export...'),
          ]),
          duration: const Duration(seconds: 2),
        ));
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 16),
            const SizedBox(width: 8),
            Text('${format.name.toUpperCase()} export completed!'),
          ]),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            Icon(Icons.error, color: Theme.of(context).colorScheme.error, size: 16),
            const SizedBox(width: 8),
            Text('Export failed: $e'),
          ]),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ));
      }
    }
  }

  void _openFAQ(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          // Constrain the text so long titles wrap instead of overflowing.
          children: const [
            Icon(Icons.quiz),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Frequently Asked Questions',
                softWrap: true,
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _faqItem(context, 'How does SilenceScore work?', 'It measures ambient noise – time below threshold earns points.'),
              _faqItem(context, 'Is audio recorded?', 'No. Only decibel levels are sampled; audio is never stored.'),
              _faqItem(context, 'Adjust sensitivity?', 'Use Settings > Basic > Decibel Threshold (${AppConstants.decibelMin.toInt()}–${AppConstants.decibelMax.toInt()} dB) and calibrate first.'),
              _faqItem(context, 'Premium features?', 'Extended sessions (up to 120m), advanced analytics, export, themes.'),
              _faqItem(context, 'Notifications?', 'Smart reminders learn habits and celebrate milestones.'),
            ]),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }

  Widget _faqItem(BuildContext context, String q, String a) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(q, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Text(a, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]),
  );

  void _openSupport(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    final tier = container.read(subscriptionTierStateProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _SupportBottomSheet(userTier: tier),
      ),
    );
  }

  void _openPrivacy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Privacy policy coming soon.')));
  }

  void _rateApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rating feature coming soon!')));
  }

  Widget _errorState(BuildContext context, Object e, WidgetRef ref) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error, size: 48, color: Colors.red),
      const SizedBox(height: 16),
      Text('Error loading settings: $e'),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: () => ref.invalidate(settingsNotifierProvider), child: const Text('Retry')),
    ]),
  );

  Future<void> _showAccessibilityDialog(BuildContext context, SettingsNotifier notifier, Map<String, dynamic> settings) async {
    bool vib = settings['enableVibration'] as bool? ?? true;
    bool voice = settings['enableVoiceOver'] as bool? ?? false;
    bool highContrast = settings['enableHighContrast'] as bool? ?? false;
    bool largeText = settings['enableLargeText'] as bool? ?? false;
    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, setState) => AlertDialog(
          title: const Text('Accessibility Settings'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SwitchListTile(
                title: const Text('Vibration Feedback'),
                subtitle: const Text('Vibrate on session events'),
                value: vib,
                onChanged: (v) async { await notifier.updateSetting('enableVibration', v); setState(() => vib = v); },
              ),
              SwitchListTile(
                title: const Text('Voice Announcements'),
                subtitle: const Text('Announce session progress'),
                value: voice,
                onChanged: (v) async { await notifier.updateSetting('enableVoiceOver', v); setState(() => voice = v); },
              ),
              SwitchListTile(
                title: const Text('High Contrast Mode'),
                subtitle: const Text('Improve visual accessibility'),
                value: highContrast,
                onChanged: (v) async { await notifier.updateSetting('enableHighContrast', v); setState(() => highContrast = v); },
              ),
              SwitchListTile(
                title: const Text('Large Text'),
                subtitle: const Text('Increase text size'),
                value: largeText,
                onChanged: (v) async { await notifier.updateSetting('enableLargeText', v); setState(() => largeText = v); },
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            ElevatedButton(onPressed: () { Navigator.of(context).pop(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Accessibility settings saved'))); }, child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}

class _NoiseCalibrationDialog extends StatefulWidget {
  final SettingsNotifier settingsNotifier; final double? previousThreshold;
  const _NoiseCalibrationDialog({required this.settingsNotifier, this.previousThreshold});
  @override State<_NoiseCalibrationDialog> createState() => _NoiseCalibrationDialogState();
}
class _NoiseCalibrationDialogState extends State<_NoiseCalibrationDialog> {
  bool _isCalibrating = true;
  double? _recommended;
  double? _previous;
  bool _noChange = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    try {
      _previous = widget.previousThreshold;
      final value = await NoiseCalibrationService.instance.calibrate();
      if (!mounted) return;
      if (value == null) {
        setState(() {
          _error = 'Could not read microphone';
          _isCalibrating = false;
        });
        return;
      }
      final clamped = value.clamp(AppConstants.decibelMin, AppConstants.decibelMax).toDouble();
      await widget.settingsNotifier.updateSetting('decibelThreshold', clamped);
      final unchanged = (_previous != null) && ((clamped - _previous!).abs() < 0.5);
      setState(() {
        _recommended = clamped;
        _isCalibrating = false;
        _noChange = unchanged;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Calibration failed';
          _isCalibrating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Noise Floor Calibration'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isCalibrating) ...[
              const Text('Measuring ambient noise (≈5s)...'),
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ] else if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isCalibrating = true;
                    _error = null;
                    _recommended = null;
                  });
                  _run();
                },
                child: const Text('Retry'),
              ),
            ] else if (_recommended != null) ...[
              Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 48),
              const SizedBox(height: 12),
              if (_previous != null)
                Text('Previous: ${_previous!.toStringAsFixed(1)} dB', style: Theme.of(context).textTheme.bodySmall),
              Text('New threshold: ${_recommended!.toStringAsFixed(1)} dB',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              if (_noChange)
                Text('No significant change detected.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))
              else if (_recommended! >= AppConstants.highThresholdWarning)
                Text('High ambient environment detected. Consider a quieter space for more sensitivity.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error))
              else
                const Text('You can adjust this anytime in Settings.'),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
      ],
    );
  }
}

class _SupportBottomSheet extends StatefulWidget { final SubscriptionTier userTier; const _SupportBottomSheet({required this.userTier}); @override State<_SupportBottomSheet> createState()=>_SupportBottomSheetState(); }
class _SupportBottomSheetState extends State<_SupportBottomSheet>{
  final _subject=TextEditingController(); final _description=TextEditingController(); bool _submitting=false;
  @override void dispose(){ _subject.dispose(); _description.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){ final service=SupportService.instance; final priority=service.getSupportPriority(widget.userTier); final responseTime=service.getSupportResponseTime(priority); return Container(constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*0.9), padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))), child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children:[ Row(children:[ Icon(Icons.support_agent, color: Theme.of(context).colorScheme.primary, size:24), const SizedBox(width:12), Text('Support', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)), const Spacer(), if(widget.userTier!=SubscriptionTier.free) Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(12)), child: Text(widget.userTier.displayName.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold))), IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: const Icon(Icons.close)) ]), const SizedBox(height:16), Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[ Text('Response Time: $responseTime', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)), const SizedBox(height:16), Row(children:[ Expanded(child: ElevatedButton.icon(onPressed: ()=>_openFAQWebsite(context), icon: const Icon(Icons.quiz, size:18), label: const Text('FAQ'))), const SizedBox(width:12), Expanded(child: ElevatedButton.icon(onPressed: ()=>_openDocumentationWebsite(context), icon: const Icon(Icons.article, size:18), label: const Text('Docs'))), ]) ])), const SizedBox(height:20), Text('Contact Support', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)), const SizedBox(height:8), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3), borderRadius: BorderRadius.circular(8), border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3))), child: Row(children:[ Icon(Icons.email, size:16, color: Theme.of(context).colorScheme.primary), const SizedBox(width:8), Expanded(child: Text('Opens your email app with system information pre-filled', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer))), ])), const SizedBox(height:16), TextField(controller: _subject, decoration: InputDecoration(labelText:'Subject', hintText:'Brief description', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), prefixIcon: const Icon(Icons.subject))), const SizedBox(height:12), TextField(controller: _description, maxLines:4, decoration: InputDecoration(labelText:'Description', hintText:'Provide details about your issue...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), prefixIcon: const Icon(Icons.description), alignLabelWithHint:true)), const SizedBox(height:20), ElevatedButton.icon(onPressed: _submitting?null:_submit, icon: _submitting? const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2)) : const Icon(Icons.send), label: Text(_submitting? 'Opening Email...' : 'Open Email App'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical:16))), const SizedBox(height:16) ]))); }
  Future<void> _submit() async { if(_subject.text.trim().isEmpty || _description.text.trim().isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill subject and description'))); return;} setState(()=>_submitting=true); try { final service=SupportService.instance; final info=await service.getDeviceInfo(); final priority=service.getSupportPriority(widget.userTier); final ticket=SupportTicket(subject:_subject.text.trim(), description:_description.text.trim(), priority:priority, deviceInfo:info, userTier: widget.userTier.displayName); await service.openEmailSupport(ticket); if(mounted){ Navigator.of(context).pop(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children:[ Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary), const SizedBox(width:8), const Expanded(child: Text('Email app opened. Send when ready.')), ]), backgroundColor: Theme.of(context).colorScheme.primaryContainer)); } } catch (e){ if(mounted){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children:[ const Text('No email app found. Contact:'), SelectableText('silencescore@sparkvibe.io', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)), Text('Subject: [STANDARD] ${_subject.text}'), Text('Issue: ${_description.text}'), ]), backgroundColor: Theme.of(context).colorScheme.errorContainer, duration: const Duration(seconds:8))); } } finally { if(mounted) setState(()=>_submitting=false); } }
  Future<void> _openFAQWebsite(BuildContext context) async { try { await SupportService.instance.openFAQ(); } catch (e){ if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to open FAQ: $e'), backgroundColor: Theme.of(context).colorScheme.errorContainer)); } }
  Future<void> _openDocumentationWebsite(BuildContext context) async { try { await SupportService.instance.openDocumentation(); } catch (e){ if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to open documentation: $e'), backgroundColor: Theme.of(context).colorScheme.errorContainer)); } }
}
