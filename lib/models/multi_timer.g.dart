// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_timer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimerStep _$TimerStepFromJson(Map<String, dynamic> json) => TimerStep(
  label: json['label'] as String,
  duration: Duration(microseconds: (json['duration'] as num).toInt()),
  alertSound: json['alertSound'] as String,
);

Map<String, dynamic> _$TimerStepToJson(TimerStep instance) => <String, dynamic>{
  'label': instance.label,
  'duration': instance.duration.inMicroseconds,
  'alertSound': instance.alertSound,
};

MultiTimerPreset _$MultiTimerPresetFromJson(Map<String, dynamic> json) =>
    MultiTimerPreset(
      name: json['name'] as String,
      steps: (json['steps'] as List<dynamic>)
          .map((e) => TimerStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MultiTimerPresetToJson(MultiTimerPreset instance) =>
    <String, dynamic>{'name': instance.name, 'steps': instance.steps};
