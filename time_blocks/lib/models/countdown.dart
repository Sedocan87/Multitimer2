import 'package:flutter/material.dart';

enum CountdownType { dateAndTime, duration }

enum RepeatType { none, daily, weekly, monthly, yearly }

class Countdown {
  final String name;
  final CountdownType type;
  final DateTime? targetDate;
  final Duration? duration;
  final RepeatType repeat;
  final TimeOfDay? alertTime;
  final String? alertSound;

  Countdown({
    required this.name,
    required this.type,
    this.targetDate,
    this.duration,
    this.repeat = RepeatType.none,
    this.alertTime,
    this.alertSound,
  });

  Countdown copyWith({
    String? name,
    CountdownType? type,
    DateTime? targetDate,
    Duration? duration,
    RepeatType? repeat,
    TimeOfDay? alertTime,
    String? alertSound,
  }) {
    return Countdown(
      name: name ?? this.name,
      type: type ?? this.type,
      targetDate: targetDate ?? this.targetDate,
      duration: duration ?? this.duration,
      repeat: repeat ?? this.repeat,
      alertTime: alertTime ?? this.alertTime,
      alertSound: alertSound ?? this.alertSound,
    );
  }
}
