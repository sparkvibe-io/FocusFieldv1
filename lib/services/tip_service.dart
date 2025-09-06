import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// i18n: future wiring to AppLocalizations; using English fallbacks now
import 'package:silence_score/providers/silence_provider.dart';
import 'package:silence_score/providers/subscription_provider.dart';
import 'package:silence_score/l10n/app_localizations.dart';
import 'package:silence_score/widgets/tip_overlay.dart';

final tipServiceProvider = Provider<TipService>((ref) => TipService(ref));

class TipService {
  TipService(this._ref);
  final Ref _ref;
  // Reactive enabled flag for UI; initialized on first getEnabled() call
  final ValueNotifier<bool> enabled = ValueNotifier<bool>(true);
  bool _enabledInitialized = false;

  static const _enabledKey = 'tips_enabled';
  static const _orderKey = 'tips_order';
  static const _indexKey = 'tips_index';
  static const _shownSetKey = 'tips_shown_set';
  static const _sessionShownKey = 'tips_session_shown';
  static const _currentTipKey = 'tips_current_tip';
  static const _currentTipShownAtKey = 'tips_current_tip_shown_at';
  static const _currentTipSeenKey = 'tips_current_tip_seen';

  static const _tipDisplayMinutes = 5; // Show same tip for 5 minutes

  OverlayEntry? _current;
  
  // Session guard to prevent tips on theme-change-induced app rebuilds

  Future<bool> _getEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? true;
  }

  // Public accessor that also initializes and updates the ValueNotifier
  Future<bool> getEnabled() async {
    if (!_enabledInitialized) {
      final v = await _getEnabled();
      enabled.value = v;
      _enabledInitialized = true;
    }
    return enabled.value;
  }

  Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, value);
  enabled.value = value;
  _enabledInitialized = true;
  }

  Future<List<int>> _getOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_orderKey);
    if (raw != null) {
      try {
        final list = (jsonDecode(raw) as List).cast<int>();
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }
    // initialize shuffled order
    final order = List<int>.generate(_tips.length, (i) => i);
    order.shuffle();
    await prefs.setString(_orderKey, jsonEncode(order));
    await prefs.setInt(_indexKey, 0);
    await prefs.setString(_shownSetKey, jsonEncode(<int>[]));
    return order;
  }





  Future<bool> _isSessionActive() async {
    // Read current session state
    final state = _ref.read(silenceStateProvider);
    return state.isListening;
  }

  Future<void> maybeShowOnAppStart(BuildContext context) async {
    // DISABLED: Tips now only show when user actively clicks the lightbulb icon
    // This provides better user control and prevents unwanted interruptions
    return;
  }

  Future<void> maybeShowAfterSession(BuildContext context, {required bool success}) async {
    // DISABLED: Tips now only show when user actively clicks the lightbulb icon
    // This provides better user control and prevents unwanted interruptions
    return;
  }


  Future<void> _showSpecificTip(BuildContext context, int tipId) async {
    // Dismiss existing if any
    _dismiss();
    
    final text = _getTipText(context, tipId);
    final isPremiumFeature = _isPremiumTip(tipId);
    final hasPremiumAccess = _ref.read(premiumAccessProvider);
    final showPremiumChip = isPremiumFeature && !hasPremiumAccess;
    final instruction = _getInstructionsForTip(context, tipId);
    final isEnabled = await getEnabled();

    final overlay = OverlayEntry(
      builder: (_) => TipOverlay(
        text: text,
        instructions: instruction,
        isPremium: showPremiumChip,
        isEnabled: isEnabled,
        onClose: () {
          _dismiss();
          // Mark tip as seen when user closes it
          markCurrentTipAsSeen();
        },
        onMute: () async {
          await setEnabled(!isEnabled);
          _dismiss();
          _showMutedToast(context, !isEnabled);
          // Mark tip as seen when user toggles mute
          markCurrentTipAsSeen();
        },
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(overlay);
    _current = overlay;

    // Auto-dismiss after 10s and mark as seen
    Future.delayed(const Duration(seconds: 10), () {
      _dismiss();
      markCurrentTipAsSeen();
    });
  }

  void _dismiss() {
    _current?.remove();
    _current = null;
  }

  void _showMutedToast(BuildContext context, bool isNowHidden) {
    final l10n = AppLocalizations.of(context);
    final message = isNowHidden 
        ? (l10n?.tipsHidden ?? 'Tips hidden')
        : (l10n?.tipsShown ?? 'Tips shown');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _getTipText(BuildContext context, int id) {
    // Try localized AppLocalizations keys tip01..tip30; fallback to English list
    final l10n = AppLocalizations.of(context);
    String? text;
    switch (id) {
      case 0:
        text = l10n?.tip01; break;
      case 1:
        text = l10n?.tip02; break;
      case 2:
        text = l10n?.tip03; break;
      case 3:
        text = l10n?.tip04; break;
      case 4:
        text = l10n?.tip05; break;
      case 5:
        text = l10n?.tip06; break;
      case 6:
        text = l10n?.tip07; break;
      case 7:
        text = l10n?.tip08; break;
      case 8:
        text = l10n?.tip09; break;
      case 9:
        text = l10n?.tip10; break;
      case 10:
        text = l10n?.tip11; break;
      case 11:
        text = l10n?.tip12; break;
      case 12:
        text = l10n?.tip13; break;
      case 13:
        text = l10n?.tip14; break;
      case 14:
        text = l10n?.tip15; break;
      case 15:
        text = l10n?.tip16; break;
      case 16:
        text = l10n?.tip17; break;
      case 17:
        text = l10n?.tip18; break;
      case 18:
        text = l10n?.tip19; break;
      case 19:
        text = l10n?.tip20; break;
      case 20:
        text = l10n?.tip21; break;
      case 21:
        text = l10n?.tip22; break;
      case 22:
        text = l10n?.tip23; break;
      case 23:
        text = l10n?.tip24; break;
      case 24:
        text = l10n?.tip25; break;
      case 25:
        text = l10n?.tip26; break;
      case 26:
        text = l10n?.tip27; break;
      case 27:
        text = l10n?.tip28; break;
      case 28:
        text = l10n?.tip29; break;
      case 29:
        text = l10n?.tip30; break;
    }
    return text ?? _tips[id];
  }

  bool _isPremiumTip(int id) {
    // Mark tips that explicitly mention Premium functionality
    switch (id) {
      case 11: // Export data (Premium)
      case 16: // Upgrade session duration (Premium)
        return true;
      default:
        return false;
    }
  }

  String? _getInstructionsForTip(BuildContext context, int id) {
    final l10n = AppLocalizations.of(context);
    switch (id) {
      // 0 Short sessions → set a short session duration
      case 0:
        return l10n?.tipInstructionSetTime;
      // 1 Smart daily reminders → open Notifications (Daily Reminders)
      case 1:
        return l10n?.tipInstructionDailyReminders;
      // 2 Recalibrate ambient baseline
      case 2:
        return l10n?.tipInstructionCalibrate;
      // 3 Weekly trends live in Analytics
      case 3:
        return l10n?.tipInstructionOpenAnalytics;
      // 4 Daily wins—even 1 minute → set time short
      case 4:
        return l10n?.tipInstructionSetTime;
      // 5 Threshold tuning
      case 5:
        return l10n?.tipInstructionThreshold;
      // 6 Try different times → check Best Time metric in Analytics
      case 6:
        return l10n?.tipInstructionOpenAnalytics;
      // 7 Session complete notifications
      case 7:
        return l10n?.tipInstructionSessionComplete;
      // 8 Smart auto reminders
      case 8:
        return l10n?.tipInstructionDailyReminders;
      // 9 Shorter sessions on busy days
      case 9:
        return l10n?.tipInstructionSetTime;
      // 10 Tap ring to start/stop
      case 10:
        return l10n?.tipInstructionTapRing;
      // 11 Export data (Premium)
      case 11:
        return l10n?.tipInstructionExport;
      // 12 Check average session length in Analytics
      case 12:
        return l10n?.tipInstructionOpenAnalytics;
      // 13 Consistency → enable reminders
      case 13:
        return l10n?.tipInstructionDailyReminders;
      // 14 5-minute baseline → set duration
      case 14:
        return l10n?.tipInstructionSetTime;
      // 15 Noise chart → start a session to view
      case 15:
        return l10n?.tipInstructionOpenNoiseChart;
      // 16 Upgrade duration (Premium)
      case 16:
        return l10n?.tipInstructionUpgradeDuration;
      // 17 High threshold warning → threshold setting
      case 17:
        return l10n?.tipInstructionThreshold;
      // 18 Tune weekly summary
      case 18:
        return l10n?.tipInstructionWeeklySummary;
      // 19 Accessibility options
      case 19:
        return l10n?.tipInstructionAccessibility;
      // 20 Ambient baseline matters → calibrate
      case 20:
        return l10n?.tipInstructionCalibrate;
      // 21 Quiet wins add up → start a session now
      case 21:
        return l10n?.tipInstructionStartNow;
      // 22 Confetti on completion → start a session
      case 22:
        return l10n?.tipInstructionStartNow;
      // 23 Try mornings → pick a daily reminder time
      case 23:
        return l10n?.tipInstructionDailyReminders;
      // 24 Fine‑tune threshold
      case 24:
        return l10n?.tipInstructionThreshold;
      // 25 Moving average context → see Analytics trends
      case 25:
        return l10n?.tipInstructionOpenAnalytics;
      // 26 Weekly insights reminder → enable weekly summary
      case 26:
        return l10n?.tipInstructionWeeklySummary;
      // 27 Finish what you start—short sessions → set short duration
      case 27:
        return l10n?.tipInstructionSetTime;
      // 28 Practice → start now
      case 28:
        return l10n?.tipInstructionStartNow;
      // 29 One tap away → tap ring
      case 29:
        return l10n?.tipInstructionTapRing;
      default:
        return null;
    }
  }

  // 30 concise, motivational, app-capability tips (English fallbacks)
  static const List<String> _tips = [
    'Short sessions count - start with 2-3 minutes to build consistency.',
    'Use Smart Daily Reminders to nudge you at your best time.',
    'Recalibrate when your environment changes for better accuracy.',
    'Check Weekly Trends to spot your momentum over time.',
    'Streaks grow with daily wins - show up, even for one minute.',
    'High ambient noise? Raise threshold a bit to reduce false fails.',
    'Try different times of day to find your quiet sweet spot.',
    'Session complete notifications keep motivation high - enable them!',
    'Prefer hands-off? Auto reminders can schedule themselves (Smart).',
    'Use shorter sessions on busy days to keep your streak alive.',
    'The progress ring is tappable - start or stop with a single tap.',
    'Export your data (Premium) to share progress or back it up.',
    'Average session length helps you choose the right duration.',
    'Consistency beats intensity - small daily practice compounds.',
    'Set a gentle goal: 5 quiet minutes is a great baseline.',
    'The noise chart helps you see spikes - aim for calmer periods.',
    'Upgrade session duration (Premium) for longer focus blocks.',
    'High threshold warning guards accuracy - avoid setting it too high.',
    'Weekdays vary - tune your weekly summary to your schedule.',
    'Accessibility options: high contrast, large text, and vibration.',
    'Ambient baseline matters - calibrate when moving to new spaces.',
    'Quiet wins add up - 1 point per minute keeps it simple.',
    'Confetti celebrates progress - small celebrations reinforce habits.',
    'Try mornings if evenings are noisy - best time differs for everyone.',
    'Fine-tune the decibel threshold for your room\'s character.',
    'Use the moving average to smooth out noisy days.',
    'Let Weekly Insights remind you of your progress rhythm.',
    'Finish what you start - short sessions reduce friction to begin.',
    'Silence is a skill - practice makes patterns, patterns make progress.',
    'You\'re one tap away - start a tiny session now.',
  ];

  // Tip Methods with Proper Timing

  Future<bool> hasNewTips() async {
    // Check if there's a current tip that hasn't been seen yet
    final currentTip = await _getCurrentTip();
    if (currentTip == null) return false;
    
    final isSeen = await _isCurrentTipSeen();
    return !isSeen;
  }

  Future<void> showCurrentTip(BuildContext context) async {
    // Always allow showing tips via info button, even if muted
    if (await _isSessionActive()) return; // never during session
    
    final currentTip = await _getCurrentTip();
    if (currentTip == null) {
      // No current tip, generate a new one
      await _generateNewTip();
      await showCurrentTip(context);
      return;
    }
    
    // Show the current tip (no session restrictions for manual viewing)
    await _showSpecificTip(context, currentTip);
  }

  Future<void> markCurrentTipAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_currentTipSeenKey, true);
  }

  // Session tracking for manual tip display
  static const _sessionTipShownKey = 'tips_session_tip_shown';
  
  Future<bool> _hasShownTipInCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sessionTipShownKey) ?? false;
  }
  
  Future<void> _markTipShownInCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionTipShownKey, true);
  }
  
  Future<void> _clearSessionTipShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionTipShownKey);
  }
  
  /// Reset session state - call this when app starts or new session begins
  Future<void> resetSessionState() async {
    await _clearSessionTipShown();
  }

  Future<int?> _getCurrentTip() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentTipKey);
  }

  Future<DateTime?> _getCurrentTipShownAt() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_currentTipShownAtKey);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<bool> _isCurrentTipSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_currentTipSeenKey) ?? false;
  }

  Future<void> _generateNewTip() async {
    final order = await _getOrder();
    final shownInSession = await _getSessionShownSet();
    
    // Find a tip that hasn't been shown in this session
    final availableTips = order.where((tipId) => !shownInSession.contains(tipId)).toList();
    
    int newTipId;
    if (availableTips.isEmpty) {
      // If all tips shown in session, reset and pick any tip
      await _clearSessionShownSet();
      newTipId = order[DateTime.now().millisecondsSinceEpoch % order.length];
    } else {
      // Pick a random tip from available ones
      newTipId = availableTips[DateTime.now().millisecondsSinceEpoch % availableTips.length];
    }
    
    // Store the new tip
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentTipKey, newTipId);
    await prefs.setInt(_currentTipShownAtKey, DateTime.now().millisecondsSinceEpoch);
    await prefs.setBool(_currentTipSeenKey, false);
    
    // Mark as shown in this session
    shownInSession.add(newTipId);
    await _setSessionShownSet(shownInSession);
  }

  Future<Set<int>> _getSessionShownSet() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionShownKey);
    if (raw == null) return <int>{};
    
    try {
      final List<dynamic> jsonList = jsonDecode(raw);
      return jsonList.map((e) => e as int).toSet();
    } catch (_) {
      return <int>{};
    }
  }

  Future<void> _setSessionShownSet(Set<int> shown) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = shown.toList();
    await prefs.setString(_sessionShownKey, jsonEncode(jsonList));
  }

  Future<void> _clearSessionShownSet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionShownKey);
  }
}
