import 'dart:async';
import 'package:flutter/material.dart';
import 'package:time_blocks/screens/new_timer_setup_screen.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  final Stopwatch _lapStopwatch = Stopwatch();
  late Timer _timer;
  String _result = '00:00:00.00';
  String _lapResult = '00:00:00.00';
  final List<String> _laps = [];

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      setState(() {
        _result =
            '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}';
        _lapResult =
            '${_lapStopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_lapStopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_lapStopwatch.elapsed.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}';
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
      _laps.add(_result);
    });
    _lapStopwatch.reset();
  }

  void _reset() {
    _stop();
    _stopwatch.reset();
    _lapStopwatch.reset();
    setState(() {
      _laps.clear();
      _result = '00:00:00.00';
      _lapResult = '00:00:00.00';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NewTimerSetupScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTimerDisplay(),
          _buildControls(),
          _buildLapList(),
          _buildSavedSessionsHeader(),
          // TODO: Implement Saved Sessions in Phase 5
          _buildSavedSessionsList(),
        ],
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
        itemCount: _laps.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text('Lap ${index + 1}'),
            title: Text(_laps[index]),
          );
        },
      ),
    );
  }

  Widget _buildSavedSessionsHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'SAVED SESSIONS',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSavedSessionsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: 0, // Placeholder
        itemBuilder: (context, index) {
          return const ListTile(
            leading: Icon(Icons.history),
            title: Text('Session 1'),
            subtitle: Text('00:00:00.00'),
            trailing: Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}
