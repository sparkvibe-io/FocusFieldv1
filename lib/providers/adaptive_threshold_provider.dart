import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/silence_provider.dart';

/// Tracks consecutive wins and suggests threshold increase after 3 successes
/// Simple logic: count completed sessions, suggest +2 dB, user can accept or dismiss
class AdaptiveThresholdState {
  final int consecutiveWins;
  final bool suggestionDismissed;
  final DateTime? lastDismissedAt;

  const AdaptiveThresholdState({
    this.consecutiveWins = 0,
    this.suggestionDismissed = false,
    this.lastDismissedAt,
  });

  AdaptiveThresholdState copyWith({
    int? consecutiveWins,
    bool? suggestionDismissed,
    DateTime? lastDismissedAt,
  }) {
    return AdaptiveThresholdState(
      consecutiveWins: consecutiveWins ?? this.consecutiveWins,
      suggestionDismissed: suggestionDismissed ?? this.suggestionDismissed,
      lastDismissedAt: lastDismissedAt ?? this.lastDismissedAt,
    );
  }

  bool get shouldShowSuggestion {
    // Show if:
    // 1. Have 3+ consecutive wins
    // 2. User hasn't dismissed it
    // 3. Or it's been 7 days since dismissal (give another chance)
    if (consecutiveWins < 3) return false;
    if (!suggestionDismissed) return true;

    if (lastDismissedAt != null) {
      final daysSinceDismissal = DateTime.now().difference(lastDismissedAt!).inDays;
      return daysSinceDismissal >= 7; // Reset after a week
    }

    return false;
  }
}

class AdaptiveThresholdNotifier extends StateNotifier<AdaptiveThresholdState> {
  final Ref _ref;

  AdaptiveThresholdNotifier(this._ref) : super(const AdaptiveThresholdState()) {
    _init();
  }

  void _init() {
    // Listen to session completions
    _ref.listen<SilenceState>(
      silenceStateProvider,
      (previous, next) {
        if (previous?.success != true && next.success == true) {
          // Session just completed successfully
          _onSessionCompleted(success: true);
        } else if (previous?.isListening == true && next.isListening == false && next.success != true) {
          // Session ended but not successful
          _onSessionCompleted(success: false);
        }
      },
    );
  }

  void _onSessionCompleted({required bool success}) {
    if (success) {
      // Increment consecutive wins
      state = state.copyWith(
        consecutiveWins: state.consecutiveWins + 1,
      );
    } else {
      // Reset streak on failure
      state = state.copyWith(
        consecutiveWins: 0,
        suggestionDismissed: false, // Also reset dismissal
      );
    }
  }

  void dismissSuggestion() {
    state = state.copyWith(
      suggestionDismissed: true,
      lastDismissedAt: DateTime.now(),
    );
  }

  void acceptSuggestion() {
    // Reset state after accepting
    state = const AdaptiveThresholdState();
  }
}

/// Provider for adaptive threshold state
final adaptiveThresholdProvider = StateNotifierProvider<AdaptiveThresholdNotifier, AdaptiveThresholdState>((ref) {
  return AdaptiveThresholdNotifier(ref);
});

/// Computed provider for suggested threshold (current + 2)
final suggestedThresholdProvider = Provider<int>((ref) {
  final currentThreshold = ref.watch(decibelThresholdProvider);
  return ((currentThreshold + 2).clamp(20, 80)).round(); // Keep within valid range
});
