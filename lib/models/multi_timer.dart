import 'package:json_annotation/json_annotation.dart';

part 'multi_timer.g.dart';

@JsonSerializable()
class TimerStep {
  final String label;
  final Duration duration;
  final String alertSound;

  const TimerStep({
    required this.label,
    required this.duration,
    required this.alertSound,
  });

  factory TimerStep.fromJson(Map<String, dynamic> json) =>
      _$TimerStepFromJson(json);
  Map<String, dynamic> toJson() => _$TimerStepToJson(this);

  TimerStep copyWith({String? label, Duration? duration, String? alertSound}) {
    return TimerStep(
      label: label ?? this.label,
      duration: duration ?? this.duration,
      alertSound: alertSound ?? this.alertSound,
    );
  }
}

@JsonSerializable()
class MultiTimerPreset {
  final String name;
  final List<TimerStep> steps;

  const MultiTimerPreset({required this.name, required this.steps});

  factory MultiTimerPreset.fromJson(Map<String, dynamic> json) =>
      _$MultiTimerPresetFromJson(json);
  Map<String, dynamic> toJson() => _$MultiTimerPresetToJson(this);

  MultiTimerPreset copyWith({String? name, List<TimerStep>? steps}) {
    return MultiTimerPreset(
      name: name ?? this.name,
      steps: steps ?? this.steps,
    );
  }
}
