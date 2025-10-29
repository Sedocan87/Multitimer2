import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_blocks/models/timer_type.dart';
import 'package:time_blocks/screens/settings_screen.dart';
import 'package:time_blocks/screens/new_timer_setup_screen.dart';
import 'package:time_blocks/models/countdown.dart';
import 'package:time_blocks/screens/new_countdown_screen.dart';
import 'package:time_blocks/screens/stopwatch_screen.dart';
import 'package:time_blocks/services/timer_service.dart';
import 'package:humanize_duration/humanize_duration.dart';
import 'package:time_blocks/screens/saved_presets_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _formatDuration(Duration duration, TimerType timerType) {
    if (timerType == TimerType.countdown) {
      return humanizeDuration(
        duration,
        options: const HumanizeOptions(
          units: [
            Units.year,
            Units.month,
            Units.week,
            Units.day,
            Units.hour,
            Units.minute,
            Units.second,
          ],
          delimiter: ' ',
        ),
      );
    } else if (timerType == TimerType.stopwatch) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String threeDigits(int n) => n.toString().padLeft(3, '0');
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      String threeDigitMilliseconds = threeDigits(
        duration.inMilliseconds.remainder(1000),
      );
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.$threeDigitMilliseconds";
    } else {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
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
              const Text(
                'Active',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...timerService.activeTimers.map(
                (timer) => _buildActiveTimerCard(timer),
              ),
              const SizedBox(height: 32),
              const Text(
                'Recent',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...timerService.recentTimers.map(
                (timer) => _buildRecentTimerCard(timer),
              ),
              const SizedBox(height: 80), // Add padding for the FAB
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
    if (timer.timerType == TimerType.multiTimer) {
      return InkWell(
        onLongPress: () {
          _showDeleteConfirmationDialog(timer.id);
        },

        child: Card(
          child: ExpansionTile(
            title: Text(
              timer.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            subtitle: Text(
              'Step ${timer.currentStepIndex + 1} of ${timer.steps.length} - ${_formatDuration(timer.duration, TimerType.countdown)}',
            ),

            children: timer.steps.map((step) {
              final stepIndex = timer.steps.indexOf(step);

              final isCurrentStep = stepIndex == timer.currentStepIndex;

              final isCompletedStep = stepIndex < timer.currentStepIndex;

              final double progress = isCompletedStep
                  ? 1.0
                  : isCurrentStep
                  ? 1.0 - (timer.duration.inSeconds / step.duration.inSeconds)
                  : 0.0;

              return ListTile(
                title: Text(step.label),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      _formatDuration(
                        isCurrentStep ? timer.duration : step.duration,
                        TimerType.countdown,
                      ),
                    ),

                    const SizedBox(height: 8),

                    LinearProgressIndicator(
                      value: progress,

                      backgroundColor: Colors.grey[300],

                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      );
    } else {
      return InkWell(
        onLongPress: () {
          _showDeleteConfirmationDialog(timer.id);
        },

        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    const Icon(Icons.timer),

                    const SizedBox(width: 8),

                    Text(
                      timer.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,

                        alignment: Alignment.centerLeft,

                        child: Text(
                          _formatDuration(timer.duration, timer.timerType),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [
                    if (timer.timerType != TimerType.countdown ||
                        timer.countdownType == CountdownType.duration) ...[
                      const SizedBox(width: 8),

                      OutlinedButton(
                        onPressed: () {
                          Provider.of<TimerService>(
                            context,
                            listen: false,
                          ).resetTimer(timer.id);
                        },

                        child: const Text('Reset'),
                      ),

                      const SizedBox(width: 8),

                      if (timer.isActive)
                        ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<TimerService>(
                              context,
                              listen: false,
                            ).pauseTimer(timer.id);
                          },

                          icon: const Icon(Icons.pause),

                          label: const Text('Pause'),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<TimerService>(
                              context,
                              listen: false,
                            ).resumeTimer(timer.id);
                          },

                          icon: const Icon(Icons.play_arrow),

                          label: const Text('Resume'),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                    ],
                  ],
                ),

                if (timer.timerType == TimerType.countdown &&
                    timer.initialDuration.inSeconds > 0)
                  Column(
                    children: [
                      const SizedBox(height: 16),

                      LinearProgressIndicator(
                        value:
                            1.0 -
                            (timer.duration.inSeconds /
                                timer.initialDuration.inSeconds),

                        backgroundColor: Colors.grey[300],

                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildRecentTimerCard(Timerable timer) {
    return InkWell(
      onLongPress: () {
        _showDeleteConfirmationDialog(timer.id);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.history),
                  const SizedBox(width: 8),
                  Text(
                    timer.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _formatDuration(timer.duration, timer.timerType),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Timer',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<TimerService>(
                        context,
                        listen: false,
                      ).addTimer(timer);
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text('Start Again'),
                  ),
                ],
              ),
            ],
          ),
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
                  MaterialPageRoute(
                    builder: (context) => const NewTimerSetupScreen(),
                  ),
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
                  MaterialPageRoute(
                    builder: (context) => const NewCountdownScreen(),
                  ),
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
                  MaterialPageRoute(
                    builder: (context) => const StopwatchScreen(),
                  ),
                );
              },
            ),
            ListTile(
              // New button
              leading: const Icon(Icons.save),
              title: const Text('Saved Presets'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedPresetsScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String timerId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Timer'),
          content: const Text('Are you sure you want to delete this timer?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TimerService>(
                  context,
                  listen: false,
                ).deleteTimer(timerId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
