class AppConstants {
  // App metadata
  static const String appTitle = 'Silence Score';
  static const String appVersion = '0.1.0';
  
  // Silence detection settings
  static const double defaultDecibelThreshold = 38.0; // dB
  static const int silenceDurationSeconds = 60; // 1 minute (default)
  static const int sampleIntervalMs = 200; // Sample every 200ms (system constant)
  
  // Scoring (system constants)
  static const int pointsPerMinute = 1; // 1 point per minute of successful session
  
  // Legacy constant (was user-configurable, now system constant)
  static const int pointsPerSuccess = 1; // Deprecated - use pointsPerMinute instead
  
  // Storage keys
  static const String totalPointsKey = 'total_points';
  static const String currentStreakKey = 'current_streak';
  static const String bestStreakKey = 'best_streak';
  static const String lastPlayDateKey = 'last_play_date';
  static const String decibelThresholdKey = 'decibel_threshold';
  
  // UI strings
  static const String stopButtonText = 'Stop';
  static const String listeningText = 'Listening...';
  static const String successMessage = 'Silence achieved! +1 point';
  static const String failureMessage = 'Too noisy! Try again';
  static const String totalPointsLabel = 'Total Points';
  static const String currentStreakLabel = 'Current Streak';
  static const String bestStreakLabel = 'Best Streak';
  static const String welcomeMessage = 'Press Start to begin your silence journey!';
  static const String settingsTitle = 'Settings';
  static const String resetDataText = 'Reset All Data';
  static const String resetDataConfirmation = 'Are you sure you want to reset all your progress?';
  static const String resetDataSuccess = 'Data reset successfully';
  static const String decibelThresholdLabel = 'Decibel Threshold';
  static const String decibelThresholdHint = 'Set the maximum allowed noise level (dB)';
  
  // Permission strings
  static const String microphonePermissionTitle = 'Microphone Permission';
  static const String microphonePermissionMessage = 'Silence Score needs microphone access to measure ambient noise levels. No audio is stored.';
  static const String permissionDeniedMessage = 'Microphone permission is required to measure silence. Please enable it in settings.';
  
  // Error messages
  static const String noiseMeterError = 'Unable to access microphone';
  static const String generalError = 'Something went wrong. Please try again.';
} 