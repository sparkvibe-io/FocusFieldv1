class AmbientFlags {
  // Enable the new Ambient Quests experience
  static const bool quests = true; // default true in dev
  static const bool ambientScore = true;
  static const bool adaptiveThreshold = true;
  static const bool activeProfiles = false; // can enable later
  static const bool healthSync = false;
  static const bool calendarExport = false;

  // Adaptive tuning
  // Default cooldown between suggestions (in hours)
  static const int defaultAdaptiveCooldownHours = 24;
  // Wins/Losses streak needed to suggest a change
  static const int adaptiveBaseStreak = 3;
  // Extra streak required when reversing direction relative to the last suggestion
  static const int adaptiveReverseBonus = 1;
}
