

enum CountdownType { dateAndTime, duration }

enum RepeatType { none, daily, weekly, monthly, yearly }

class Countdown {
  final String name;
  final CountdownType type;
  final DateTime? targetDate;
  final Duration? duration;
  final RepeatType repeat;
  final String? alertSound;
  final bool enableAlert;

  Countdown({
    required this.name,
    required this.type,
    this.targetDate,
    this.duration,
    this.repeat = RepeatType.none,
    this.alertSound,
    this.enableAlert = false,
  });

  Countdown copyWith({
    String? name,
    CountdownType? type,
    DateTime? targetDate,
    Duration? duration,
    RepeatType? repeat,
    String? alertSound,
    bool? enableAlert,
  }) {
    return Countdown(
      name: name ?? this.name,
      type: type ?? this.type,
      targetDate: targetDate ?? this.targetDate,
      duration: duration ?? this.duration,
      repeat: repeat ?? this.repeat,
      alertSound: alertSound ?? this.alertSound,
      enableAlert: enableAlert ?? this.enableAlert,
    );
  }}
