import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_blocks/screens/settings_screen.dart';
import 'package:time_blocks/screens/new_timer_setup_screen.dart';
import 'package:time_blocks/screens/new_countdown_screen.dart';
import 'package:time_blocks/screens/stopwatch_screen.dart';
import 'package:time_blocks/services/timer_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(width: 56),
        title: const Text('Time Blocks'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TimerService>(
        builder: (context, timerService, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              const SizedBox(height: 24),
              const Text('Active', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...timerService.activeTimers.map((timer) => _buildActiveTimerCard(timer)),
              const SizedBox(height: 32),
              const Text('Recent', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...timerService.recentTimers.map((timer) => _buildRecentTimerCard(timer)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMenu(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActiveTimerCard(Timerable timer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timer),
                const SizedBox(width: 8),
                Text(timer.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(timer.duration), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                const SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: null, // Indeterminate
                    strokeWidth: 6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Provider.of<TimerService>(context, listen: false).resetTimer(timer.id);
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 8),
                if (timer.isActive)
                  ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<TimerService>(context, listen: false).pauseTimer(timer.id);
                    },
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<TimerService>(context, listen: false).resumeTimer(timer.id);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Resume'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTimerCard(Timerable timer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history),
                const SizedBox(width: 8),
                Text(timer.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(timer.duration), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                const Text('Timer', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Provider.of<TimerService>(context, listen: false).addTimer(timer);
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text('Start Again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('New Multi-Timer'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewTimerSetupScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.hourglass_empty),
              title: const Text('New Countdown'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewCountdownScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.watch),
              title: const Text('New Stopwatch'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StopwatchScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
