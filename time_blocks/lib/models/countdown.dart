class Countdown {
  final String name;
  final DateTime targetDateTime;
  final Duration duration;
  final String repeat;
  final String alert;

  Countdown({
    required this.name,
    required this.targetDateTime,
    required this.duration,
    this.repeat = 'none',
    this.alert = 'none',
  });
}
