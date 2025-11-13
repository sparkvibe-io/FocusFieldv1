import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/user_preferences.dart';

/// Service for managing celebration effects (confetti + sound)
/// Simplified: Fixed 1.5s duration, single sound file
class CelebrationService {
  ConfettiController? _confettiController;
  AudioPlayer? _audioPlayer;
  bool _isInitialized = false;

  /// Initialize the celebration service with a confetti controller
  void initialize(TickerProvider vsync) {
    if (_isInitialized) return;

    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 1500), // Fixed 1.5 seconds
    );
    _audioPlayer = AudioPlayer();
    _isInitialized = true;
  }

  /// Dispose the service and clean up resources
  void dispose() {
    _confettiController?.dispose();
    _confettiController = null;
    _audioPlayer?.dispose();
    _audioPlayer = null;
    _isInitialized = false;
  }

  /// Trigger a celebration based on user preferences
  Future<void> celebrate(UserPreferences prefs) async {
    if (!_isInitialized) return;

    // Play confetti animation if enabled
    if (prefs.enableCelebrationEffects && _confettiController != null) {
      _confettiController!.play();
    }

    // Play sound if enabled (independent of confetti)
    if (prefs.celebrationSound) {
      await _playSound();
    }
  }

  /// Play celebration sound
  Future<void> _playSound() async {
    if (_audioPlayer == null) {
      if (kDebugMode) {
        debugPrint('🔊 AudioPlayer not initialized');
      }
      return;
    }

    try {
      // Stop any currently playing sound
      await _audioPlayer!.stop();

      // Play the sound from assets
      await _audioPlayer!.play(AssetSource('sounds/sound.mp3'));

      if (kDebugMode) {
        debugPrint('🔊 Playing celebration sound: sound.mp3');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🔊 Error playing sound: $e');
      }
      // Gracefully handle missing sound files - don't crash the app
    }
  }

  /// Get the confetti controller for rendering in widgets
  ConfettiController? get confettiController => _confettiController;

  /// Check if the service is initialized
  bool get isInitialized => _isInitialized;
}
