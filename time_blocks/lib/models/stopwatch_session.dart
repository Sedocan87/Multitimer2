class StopwatchSession {
  final List<Lap> laps;

  StopwatchSession({
    required this.laps,
  });
}

class Lap {
  final Duration time;

  Lap({
    required this.time,
  });
}
