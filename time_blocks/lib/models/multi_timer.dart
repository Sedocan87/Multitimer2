class MultiTimerPreset {
  final String name;
  final List<TimerStep> steps;

  MultiTimerPreset({
    required this.name,
    required this.steps,
  });
}

class TimerStep {
  final String label;
  final Duration duration;
  final String sound;

  TimerStep({
    required this.label,
    required this.duration,
    this.sound = 'default',
  });
}
