import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_blocks/models/timer_type.dart';
import 'package:time_blocks/services/timer_service.dart';
import 'package:uuid/uuid.dart';

class StopwatchScreen extends StatefulWidget {
  final Timerable? timerable;

  const StopwatchScreen({super.key, this.timerable});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late final Timerable _timerable;
  final Stopwatch _stopwatch = Stopwatch();
  final Stopwatch _lapStopwatch = Stopwatch();
  late Timer _timer;
  String _result = '00:00:00.00';
  String _lapResult = '00:00:00.00';

  @override
  void initState() {
    super.initState();
    if (widget.timerable != null) {
      _timerable = widget.timerable!;
      _result = _formatDuration(_timerable.duration);
    } else {
      _timerable = Timerable(
        id: const Uuid().v4(),
        name: 'Stopwatch Session',
        timerType: TimerType.stopwatch,
      );
    }
    _start();
  }

  String _formatDuration(Duration d) {
    return '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}:${(d.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}';
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      setState(() {
        if (widget.timerable != null) {
          _result = _formatDuration(_timerable.duration + _stopwatch.elapsed);
        } else {
          _result = _formatDuration(_stopwatch.elapsed);
        }
        _lapResult = _formatDuration(_lapStopwatch.elapsed);
      });
    });
    _stopwatch.start();
    _lapStopwatch.start();
  }

  void _stop() {
    _timer.cancel();
    _stopwatch.stop();
    _lapStopwatch.stop();
  }

  void _lap() {
    setState(() {
      _timerable.laps.add(_lapStopwatch.elapsed);
    });
    _lapStopwatch.reset();
  }

  void _reset() {
    _stop();
    _stopwatch.reset();
    _lapStopwatch.reset();
    setState(() {
      _timerable.laps.clear();
      _result = '00:00:00.00';
      _lapResult = '00:00:00.00';
    });
  }

  void _saveSession() {
    if (widget.timerable != null) {
      // Timer already exists, just pop
      Navigator.of(context).pop();
      return;
    }
    final timerService = Provider.of<TimerService>(context, listen: false);
    final newStopwatch = _timerable.copyWith(duration: _stopwatch.elapsed);
    timerService.addTimer(newStopwatch);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _stopwatch.elapsed > Duration.zero ? _saveSession : null,
          ),
        ],
      ),
      body: Column(
        children: [_buildTimerDisplay(), _buildControls(), _buildLapList()],
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        children: [
          Text(_result, style: const TextStyle(fontSize: 48.0)),
          Text(
            _lapResult,
            style: const TextStyle(fontSize: 24.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: _stopwatch.isRunning ? _lap : _reset,
            child: Icon(_stopwatch.isRunning ? Icons.flag : Icons.refresh),
          ),
          FloatingActionButton(
            onPressed: _stopwatch.isRunning ? _stop : _start,
            child: Icon(_stopwatch.isRunning ? Icons.pause : Icons.play_arrow),
          ),
        ],
      ),
    );
  }

  Widget _buildLapList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _timerable.laps.length,
        itemBuilder: (context, index) {
          final lap = _timerable.laps[index];
          final lapText =
              '${lap.inMinutes.toString().padLeft(2, '0')}:${(lap.inSeconds % 60).toString().padLeft(2, '0')}:${(lap.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}';
          return ListTile(
            leading: Text('Lap ${index + 1}'),
            title: Text(lapText),
          );
        },
      ),
    );
  }
}
