import 'dart:math';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silence_score/l10n/app_localizations.dart';

/// Handles rating prompt logic with conservative, session-based gating.
class RatingService {
  RatingService._();
  static final RatingService instance = RatingService._();

  // Preference keys
  static const _kFirstInstall = 'rating_first_install';
  static const _kLastPrompt = 'rating_last_prompt';
  static const _kTimesPrompted = 'rating_times_prompted';
  static const _kStatus = 'rating_status'; // none|rated|declined|later
  static const _kLastVersionPrompted = 'rating_last_version_prompted';
  static const _kLastSessionCountPrompted = 'rating_last_session_count_prompted';

  // Gating configuration (defaults based on best practices)
  static const int minSessions = 7;
  static const int minDaysSinceInstall = 5;
  static const int minDaysBetweenPrompts = 14;
  static const int maxPrompts = 3; // total automatic prompts
  static const double baseProbability = 0.18;
  static const double probabilitySlope = 0.02; // per session above min
  static const double maxProbability = 0.40;
  static const int minShortSessionSeconds = 180; // avoid prompting right after a very short session
  static const int rePromptAfterDaysIfPatch = 30; // allow patch-level re-prompt after this many days if status == later

  SharedPreferences? _prefs;
  bool _evaluatedThisLaunch = false;

  Future<void> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> registerSession({required int lastSessionDurationSeconds}) async {
    // Could be used to store additional heuristics; currently not needed beyond gating check.
    // Intentionally left lightweight.
    if (lastSessionDurationSeconds < 0) return; // ignore invalid
  }

  Future<void> initLaunch() async {
    await _ensurePrefs();
    if (!_prefs!.containsKey(_kFirstInstall)) {
      _prefs!.setString(_kFirstInstall, DateTime.now().toIso8601String());
    }
  }

  Future<void> forceRate(BuildContext context) async {
    final inAppReview = InAppReview.instance;
    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        await _openStoreListing();
      }
      await _setStatus('rated');
      if (context.mounted) {
        final t = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.ratingThankYou)));
      }
    } catch (_) {
      await _openStoreListing();
    }
  }

  Future<void> maybePrompt(BuildContext context, {required int totalSessions, required int? lastSessionDurationSeconds}) async {
    if (_evaluatedThisLaunch) return;
    _evaluatedThisLaunch = true;
    await _ensurePrefs();

    final status = _prefs!.getString(_kStatus) ?? 'none';
    if (status == 'rated' || status == 'declined') return; // terminal states

    // Basic session & duration gates
    if (totalSessions < minSessions) return;
    if ((lastSessionDurationSeconds ?? 0) < minShortSessionSeconds) return;

    // Date gates
    final now = DateTime.now();
    final firstInstallStr = _prefs!.getString(_kFirstInstall);
    if (firstInstallStr == null) return; // Should be set in initLaunch
    final firstInstall = DateTime.tryParse(firstInstallStr) ?? now;
    if (now.difference(firstInstall).inDays < minDaysSinceInstall) return;

    final lastPromptStr = _prefs!.getString(_kLastPrompt);
    DateTime? lastPrompt = lastPromptStr != null ? DateTime.tryParse(lastPromptStr) : null;
    final timesPrompted = _prefs!.getInt(_kTimesPrompted) ?? 0;
    if (timesPrompted >= maxPrompts && status != 'later') return;
    if (lastPrompt != null && now.difference(lastPrompt).inDays < minDaysBetweenPrompts) return;

    // Version re-prompt logic
    final pkg = await PackageInfo.fromPlatform();
    final currentVersion = pkg.version; // semantic (no +build)
    final lastVersionPrompted = _prefs!.getString(_kLastVersionPrompted);
    final allowByVersion = _allowVersionRePrompt(status, lastVersionPrompted, currentVersion, lastPrompt);
    if (!allowByVersion) return;

    // Probability heuristic
    final p = _probability(totalSessions);
    final r = Random().nextDouble();
    if (r > p) return; // not this time

    // All gates passed -> show prompt sheet
    if (!context.mounted) return;
    await _showPrePromptSheet(context, currentVersion, totalSessions);
  }

  double _probability(int sessions) {
    if (sessions <= minSessions) return baseProbability;
    final extra = sessions - minSessions;
    return (baseProbability + extra * probabilitySlope).clamp(baseProbability, maxProbability);
  }

  bool _allowVersionRePrompt(String status, String? lastVersion, String currentVersion, DateTime? lastPrompt) {
    if (status == 'none') return true; // never prompted
    if (status == 'later') {
      if (lastVersion == null) return true;
      if (lastVersion == currentVersion) {
        // Same version. Allow if patch-level re-prompt time exceeded.
        if (lastPrompt == null) return true;
        return DateTime.now().difference(lastPrompt).inDays >= rePromptAfterDaysIfPatch;
      }
      // Compare semantic versions (major.minor.patch) only for major/minor changes
      List<int> a = _parseSemVer(lastVersion);
      List<int> b = _parseSemVer(currentVersion);
      if (b[0] > a[0]) return true; // major bump
      if (b[0] == a[0] && b[1] > a[1]) return true; // minor bump
      // patch bump alone -> rely on time gate above
      return false;
    }
    // declined or rated handled earlier, but default safeguard:
    return false;
  }

  List<int> _parseSemVer(String v) {
    final parts = v.split('.');
    int major = int.tryParse(parts.isNotEmpty ? parts[0] : '0') ?? 0;
    int minor = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    int patch = int.tryParse(parts.length > 2 ? parts[2] : '0') ?? 0;
    return [major, minor, patch];
  }

  Future<void> _showPrePromptSheet(BuildContext context, String version, int totalSessions) async {
    final t = AppLocalizations.of(context)!;
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (_) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20),
              color: theme.colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.star_rate_rounded, color: theme.colorScheme.primary, size: 28),
                      const SizedBox(width: 8),
                      Expanded(child: Text(t.ratingPromptTitle, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                      IconButton(onPressed: () => Navigator.of(context).pop('later'), icon: const Icon(Icons.close))
                    ]),
                    const SizedBox(height: 12),
                    Text(t.ratingPromptBody, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop('rate'),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                          child: Text(t.ratingPromptRateNow),
                        ),
                      ),
                    ]),
                    TextButton(onPressed: () => Navigator.of(context).pop('later'), child: Text(t.ratingPromptLater)),
                    TextButton(onPressed: () => Navigator.of(context).pop('no'), child: Text(t.ratingPromptNoThanks)),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    switch (result) {
      case 'rate':
        await _recordPrompt(version, totalSessions);
        await forceRate(context);
        break;
      case 'later':
        await _recordPrompt(version, totalSessions, status: 'later');
        break;
      case 'no':
        await _recordPrompt(version, totalSessions, status: 'declined');
        break;
      default:
        // Treat dismiss as later so we respect cool-down
        await _recordPrompt(version, totalSessions, status: 'later');
    }
  }

  Future<void> _recordPrompt(String version, int totalSessions, {String? status}) async {
    await _ensurePrefs();
    _prefs!.setString(_kLastPrompt, DateTime.now().toIso8601String());
    final times = _prefs!.getInt(_kTimesPrompted) ?? 0;
    _prefs!.setInt(_kTimesPrompted, times + 1);
    _prefs!.setString(_kLastVersionPrompted, version);
    _prefs!.setInt(_kLastSessionCountPrompted, totalSessions);
    if (status != null) await _setStatus(status);
  }

  Future<void> _setStatus(String status) async {
    await _ensurePrefs();
    _prefs!.setString(_kStatus, status);
  }

  Future<void> _openStoreListing() async {
    final inAppReview = InAppReview.instance;
    try {
      await inAppReview.openStoreListing();
    } catch (_) {
      // swallow
    }
  }
}
