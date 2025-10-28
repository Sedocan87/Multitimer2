class TimerStep {
  final String label;
  final Duration duration;
  final String alertSound;

  const TimerStep({
    required this.label,
    required this.duration,
    required this.alertSound,
  });

  TimerStep copyWith({
    String? label,
    Duration? duration,
    String? alertSound,
  }) {
    return TimerStep(
      label: label ?? this.label,
      duration: duration ?? this.duration,
      alertSound: alertSound ?? this.alertSound,
    );
  }
}

class MultiTimerPreset {
  final String name;
  final List<TimerStep> steps;

  const MultiTimerPreset({
    required this.name,
    required this.steps,
  });

  MultiTimerPreset copyWith({
    String? name,
    List<TimerStep>? steps,
  }) {
    return MultiTimerPreset(
      name: name ?? this.name,
      steps: steps ?? this.steps,
    );
  }
}
