import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:time_blocks/models/timer_type.dart';

class Timerable {
  final String id;
  final String name;
  final TimerType timerType;
  bool isActive;
  Duration duration;

  Timerable({
    required this.id,
    required this.name,
    required this.timerType,
    this.isActive = false,
    this.duration = Duration.zero,
  });
}

class TimerService extends ChangeNotifier {
  final List<Timerable> _activeTimers = [];
  final List<Timerable> _recentTimers = [];
  Timer? _timer;

  List<Timerable> get activeTimers => _activeTimers;
  List<Timerable> get recentTimers => _recentTimers;

  TimerService() {
    // Sample data for demonstration
    _activeTimers.addAll([
      Timerable(id: '1', name: 'Workout', timerType: TimerType.stopwatch, isActive: true),
      Timerable(
          id: '2',
          name: 'Study Session',
          timerType: TimerType.countdown,
          isActive: false,
          duration: const Duration(minutes: 24, seconds: 10)),
    ]);
    _recentTimers.addAll([
      Timerable(id: '3', name: 'Pizza in Oven', timerType: TimerType.multiTimer, duration: const Duration(minutes: 15)),
      Timerable(id: '4', name: 'Morning Run', timerType: TimerType.stopwatch, duration: const Duration(minutes: 22, seconds: 8)),
    ]);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_activeTimers.any((t) => t.isActive)) {
        for (var t in _activeTimers) {
          if (t.isActive) {
            switch (t.timerType) {
              case TimerType.stopwatch:
                t.duration += const Duration(seconds: 1);
                break;
              case TimerType.countdown:
              case TimerType.multiTimer:
                if (t.duration > Duration.zero) {
                  t.duration -= const Duration(seconds: 1);
                } else {
                  t.isActive = false;
                  // Optionally, you could play a sound or show a notification here.
                }
                break;
            }
          }
        }
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void addTimer(Timerable timer) {
    _recentTimers.removeWhere((t) => t.id == timer.id);
    timer.isActive = true;
    _activeTimers.add(timer);
    notifyListeners();
  }

  void pauseTimer(String id) {
    final timer = _activeTimers.firstWhere((t) => t.id == id);
    timer.isActive = false;
    notifyListeners();
  }

  void resumeTimer(String id) {
    final timer = _activeTimers.firstWhere((t) => t.id == id);
    timer.isActive = true;
    notifyListeners();
  }

  void resetTimer(String id) {
    final timer = _activeTimers.firstWhere((t) => t.id == id);
    _activeTimers.remove(timer);
    timer.isActive = false;
    timer.duration = Duration.zero;
    _recentTimers.add(timer);
    notifyListeners();
  }

  void deleteTimer(String id) {
    _activeTimers.removeWhere((t) => t.id == id);
    _recentTimers.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
