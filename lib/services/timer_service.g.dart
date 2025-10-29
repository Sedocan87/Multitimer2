// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timerable _$TimerableFromJson(Map<String, dynamic> json) => Timerable(
  id: json['id'] as String,
  name: json['name'] as String,
  timerType: $enumDecode(_$TimerTypeEnumMap, json['timerType']),
  countdownType: $enumDecodeNullable(
    _$CountdownTypeEnumMap,
    json['countdownType'],
  ),
  isActive: json['isActive'] as bool? ?? false,
  duration: json['duration'] == null
      ? Duration.zero
      : Duration(microseconds: (json['duration'] as num).toInt()),
  initialDuration: json['initialDuration'] == null
      ? Duration.zero
      : Duration(microseconds: (json['initialDuration'] as num).toInt()),
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => TimerStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  currentStepIndex: (json['currentStepIndex'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TimerableToJson(Timerable instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'timerType': _$TimerTypeEnumMap[instance.timerType]!,
  'countdownType': _$CountdownTypeEnumMap[instance.countdownType],
  'isActive': instance.isActive,
  'duration': instance.duration.inMicroseconds,
  'initialDuration': instance.initialDuration.inMicroseconds,
  'steps': instance.steps,
  'currentStepIndex': instance.currentStepIndex,
};

const _$TimerTypeEnumMap = {
  TimerType.stopwatch: 'stopwatch',
  TimerType.multiTimer: 'multiTimer',
  TimerType.countdown: 'countdown',
};

const _$CountdownTypeEnumMap = {
  CountdownType.dateAndTime: 'dateAndTime',
  CountdownType.duration: 'duration',
};
