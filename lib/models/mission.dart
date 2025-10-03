enum MissionStage { preflight, ignition, liftoff, stageSeparation, orbit }

class ActivityGoal {
  final String type; // e.g., studying, fitness, meditation, family, reading, work, noise, custom
  final String? label; // for custom
  final int dailyMinutes; // default 1

  const ActivityGoal({required this.type, this.label, this.dailyMinutes = 1});
}

class Mission {
  final String id;
  final DateTime startDate;
  final DateTime endDate; // 30-day window
  final List<ActivityGoal> goals;

  const Mission({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.goals,
  });

  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays.clamp(0, 30);
  }

  MissionStage computeStage({required int totalMicroSessions}) {
    // Simple thresholds for Phase 1; can evolve later
    if (totalMicroSessions >= 20) return MissionStage.orbit;
    if (totalMicroSessions >= 12) return MissionStage.stageSeparation;
    if (totalMicroSessions >= 5) return MissionStage.liftoff;
    if (totalMicroSessions >= 1) return MissionStage.ignition;
    return MissionStage.preflight;
  }
}
