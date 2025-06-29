import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/models/silence_data.dart';
import 'package:silence_score/services/silence_detector.dart';
import 'package:silence_score/services/storage_service.dart';

// Storage service provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Silence detector provider
final silenceDetectorProvider = Provider<SilenceDetector>((ref) {
  final threshold = ref.watch(decibelThresholdProvider);
  return SilenceDetector(threshold: threshold);
});

// Decibel threshold provider
final decibelThresholdProvider = StateProvider<double>((ref) {
  return AppConstants.defaultDecibelThreshold;
});

// Silence data provider
final silenceDataProvider = StateNotifierProvider<SilenceDataNotifier, SilenceData>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return SilenceDataNotifier(storageService);
});

// Silence state provider
final silenceStateProvider = StateNotifierProvider<SilenceStateNotifier, SilenceState>((ref) {
  return SilenceStateNotifier();
});

// Silence state notifier
class SilenceStateNotifier extends StateNotifier<SilenceState> {
  SilenceStateNotifier() : super(const SilenceState());

  void setListening(bool listening) {
    state = state.copyWith(isListening: listening);
  }

  void setProgress(double progress) {
    state = state.copyWith(progress: progress);
  }

  void setSuccess(bool? success) {
    state = state.copyWith(success: success);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void reset() {
    state = const SilenceState();
  }
}

// Silence data notifier
class SilenceDataNotifier extends StateNotifier<SilenceData> {
  final StorageService _storageService;

  SilenceDataNotifier(this._storageService) : super(const SilenceData()) {
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _storageService.loadSilenceData();
    state = data;
  }

  Future<void> addPoint() async {
    // Update streak first
    final updatedData = await _storageService.updateStreak(state);
    
    // Add point and update best streak if needed
    final newTotalPoints = updatedData.totalPoints + AppConstants.pointsPerSuccess;
    final newBestStreak = newTotalPoints > updatedData.bestStreak 
        ? newTotalPoints 
        : updatedData.bestStreak;
    
    final newData = updatedData.copyWith(
      totalPoints: newTotalPoints,
      bestStreak: newBestStreak,
    );
    
    await _storageService.saveSilenceData(newData);
    state = newData;
  }

  Future<void> resetData() async {
    await _storageService.resetAllData();
    state = const SilenceData();
  }

  Future<void> updateDecibelThreshold(double threshold) async {
    await _storageService.saveDecibelThreshold(threshold);
  }
}

// Silence state model
class SilenceState {
  final bool isListening;
  final double progress;
  final bool? success;
  final String? error;

  const SilenceState({
    this.isListening = false,
    this.progress = 0.0,
    this.success,
    this.error,
  });

  SilenceState copyWith({
    bool? isListening,
    double? progress,
    bool? success,
    String? error,
  }) {
    return SilenceState(
      isListening: isListening ?? this.isListening,
      progress: progress ?? this.progress,
      success: success ?? this.success,
      error: error ?? this.error,
    );
  }
} 