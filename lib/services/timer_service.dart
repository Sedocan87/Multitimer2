import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_blocks/models/countdown.dart';
import 'package:time_blocks/models/timer_type.dart';
import 'package:time_blocks/models/multi_timer.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_blocks/services/notification_service.dart'; // Re-add this import

part 'timer_service.g.dart';

@JsonSerializable()
class Timerable {
  final String id;
  final String name;
  final TimerType timerType;
  final CountdownType? countdownType; // New property
  bool isActive;
  Duration duration;
  Duration initialDuration;
  List<TimerStep> steps; // New property
  int currentStepIndex; // New property

  Timerable({
    required this.id,
    required this.name,
    required this.timerType,
    this.countdownType,
    this.isActive = false,
    this.duration = Duration.zero,
    this.initialDuration = Duration.zero,
    this.steps = const [], // Initialize with an empty list
    this.currentStepIndex = 0, // Initialize with 0
  });

  factory Timerable.fromJson(Map<String, dynamic> json) =>
      _$TimerableFromJson(json);
  Map<String, dynamic> toJson() => _$TimerableToJson(this);
}

class TimerService extends ChangeNotifier with WidgetsBindingObserver {
  // Implement WidgetsBindingObserver
  final List<Timerable> _activeTimers = [];
  final List<Timerable> _recentTimers = [];
  final List<Timerable> _savedPresets = []; // New list
  Timer? _timer;
  final NotificationService _notificationService = NotificationService();


  List<Timerable> get activeTimers => _activeTimers;
  List<Timerable> get recentTimers => _recentTimers;
  List<Timerable> get savedPresets => _savedPresets;

  TimerService() {
    _loadTimers();
    WidgetsBinding.instance.addObserver(this); // Add observer
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (_activeTimers.any((t) => t.isActive)) {
        for (var t in _activeTimers) {
          if (t.isActive) {
            switch (t.timerType) {
              case TimerType.stopwatch:
                t.duration += const Duration(milliseconds: 10);
                break;
              case TimerType.countdown:
                if (t.duration > Duration.zero) {
                  t.duration -= const Duration(milliseconds: 10);
                } else {
                  t.isActive = false;
                  _notificationService.showNotification(
                      t.name, 'Countdown finished!');
                }
                break;
              case TimerType.multiTimer:
                if (t.duration > Duration.zero) {
                  t.duration -= const Duration(milliseconds: 10);
                } else {
                  if (t.currentStepIndex < t.steps.length - 1) {
                    t.currentStepIndex++;
                    t.duration = t.steps[t.currentStepIndex].duration;
                  } else {
                    t.isActive = false;
                    _notificationService.showNotification(
                        t.name, 'Multi-step timer finished!');
                  }
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
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveTimers(); // Save timers when app goes to background
    } else if (state == AppLifecycleState.resumed) {
      // Logic for adjusting timers based on background duration is now handled in _loadTimers()
    }
  }

  @override
  void didChangeAccessibilityFeatures() {}

  @override
  void didChangeLocales(List<Locale>? locales) {}

  @override
  void didChangeMetrics() {}

  @override
  void didChangePlatformBrightness() {}

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPushRoute(String route) async => true;

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) async =>
      true;

  @override
  Future<bool> didPopRoute() async => true;

  @override
  void didChangeTextScaleFactor() {}

  @override
  void didChangeViewFocus(ViewFocusEvent event) {}

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) => true;

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {}

  void addTimer(Timerable timer) {
    _recentTimers.removeWhere((t) => t.id == timer.id);
    timer.isActive = true;
    _activeTimers.add(timer);
    notifyListeners();
    _saveTimers();
  }

  void pauseTimer(String id) {
    final timer = _activeTimers.firstWhere((t) => t.id == id);
    timer.isActive = false;
    notifyListeners();
    _saveTimers();
  }

  void resumeTimer(String id) {
    final timer = _activeTimers.firstWhere((t) => t.id == id);
    timer.isActive = true;
    notifyListeners();
    _saveTimers();
  }

  void resetTimer(String id) {
    final timer = _activeTimers.firstWhere((t) => t.id == id);
    _activeTimers.remove(timer);
    timer.isActive = false;
    timer.duration = timer.initialDuration; // Reset to initial duration
    _recentTimers.add(timer);
    notifyListeners();
    _saveTimers();
  }

  void deleteTimer(String id) {
    _activeTimers.removeWhere((t) => t.id == id);
    _recentTimers.removeWhere((t) => t.id == id);
    notifyListeners();
    _saveTimers();
  }

  void savePreset(Timerable preset) {
    _savedPresets.add(preset);
    notifyListeners();
    _saveTimers();
  }

  Future<void> _saveTimers() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'activeTimers',
      jsonEncode(_activeTimers.map((t) => t.toJson()).toList()),
    );
    prefs.setString(
      'recentTimers',
      jsonEncode(_recentTimers.map((t) => t.toJson()).toList()),
    );
    prefs.setString(
      'savedPresets',
      jsonEncode(_savedPresets.map((t) => t.toJson()).toList()),
    );
    prefs.setString('lastActiveTime', DateTime.now().toIso8601String());
  }

  Future<void> _loadTimers() async {
    final prefs = await SharedPreferences.getInstance();
    final activeTimersJson = prefs.getString('activeTimers');
    if (activeTimersJson != null) {
      _activeTimers.addAll(
        (jsonDecode(activeTimersJson) as List).map(
          (e) => Timerable.fromJson(e as Map<String, dynamic>),
        ),
      );
    }
    final recentTimersJson = prefs.getString('recentTimers');
    if (recentTimersJson != null) {
      _recentTimers.addAll(
        (jsonDecode(recentTimersJson) as List).map(
          (e) => Timerable.fromJson(e as Map<String, dynamic>),
        ),
      );
    }
    final savedPresetsJson = prefs.getString('savedPresets');
    if (savedPresetsJson != null) {
      _savedPresets.addAll(
        (jsonDecode(savedPresetsJson) as List).map(
          (e) => Timerable.fromJson(e as Map<String, dynamic>),
        ),
      );
    }
    final lastActiveTimeString = prefs.getString('lastActiveTime');
    if (lastActiveTimeString != null) {
      final lastActiveTime = DateTime.parse(lastActiveTimeString);
      final elapsedTime = DateTime.now().difference(lastActiveTime);
      for (var t in _activeTimers) {
        if (t.isActive) {
          if (t.timerType == TimerType.countdown ||
              t.timerType == TimerType.multiTimer) {
            t.duration -= elapsedTime;
            if (t.duration < Duration.zero) {
              t.duration = Duration.zero;
              t.isActive = false;
            }
          } else if (t.timerType == TimerType.stopwatch) {
            t.duration += elapsedTime;
          }
        }
      }
    }
    notifyListeners();
  }
}