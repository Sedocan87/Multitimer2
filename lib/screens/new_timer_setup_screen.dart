import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_blocks/models/multi_timer.dart';
import 'package:time_blocks/models/timer_type.dart';
import 'package:time_blocks/services/timer_service.dart';
import 'package:uuid/uuid.dart';

class NewTimerSetupScreen extends StatefulWidget {
  const NewTimerSetupScreen({super.key});

  @override
  State<NewTimerSetupScreen> createState() => _NewTimerSetupScreenState();
}

class _NewTimerSetupScreenState extends State<NewTimerSetupScreen> {
  final _presetNameController = TextEditingController();
  final List<TimerStep> _timers = [];

  @override
  void initState() {
    super.initState();
    _addTimer();
  }

  void _addTimer() {
    setState(() {
      _timers.add(
        const TimerStep(
          label: '',
          duration: Duration(minutes: 1),
          alertSound: 'Chimes',
        ),
      );
    });
  }

  void _removeTimer(int index) {
    setState(() {
      _timers.removeAt(index);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _timers.removeAt(oldIndex);
      _timers.insert(newIndex, item);
    });
  }

  void _savePreset() {
    final timerService = Provider.of<TimerService>(context, listen: false);
    final totalDuration = _timers.fold(
      Duration.zero,
      (prev, step) => prev + step.duration,
    );
    final newPreset = Timerable(
      id: const Uuid().v4(),
      name: _presetNameController.text.isNotEmpty
          ? _presetNameController.text
          : 'Multi-Timer',
      timerType: TimerType.multiTimer,
      duration: _timers.isNotEmpty
          ? _timers.first.duration
          : Duration.zero, // Duration of the first step
      initialDuration: totalDuration,
      steps: _timers, // Pass the list of timers
    );
    timerService.savePreset(newPreset);
    Navigator.of(context).pop();
  }

  Future<void> _showDeleteConfirmationDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Timer'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this timer?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _removeTimer(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSoundSelectionDialog(int index) async {
    final sounds = ['Chimes', 'Digital', 'Beep', 'Bell'];
    final selectedSound = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Sound'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sounds.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text(sounds[i]),
                  onTap: () {
                    Navigator.of(context).pop(sounds[i]);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedSound != null) {
      setState(() {
        _timers[index] = _timers[index].copyWith(alertSound: selectedSound);
      });
    }
  }

  Future<void> _showDurationPicker(int index) async {
    final newDuration = await showModalBottomSheet<Duration>(
      context: context,

      builder: (context) {
        return SizedBox(
          height: 200,

          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hms,

            initialTimerDuration: _timers[index].duration,

            onTimerDurationChanged: (newDuration) {
              setState(() {
                _timers[index] = _timers[index].copyWith(duration: newDuration);
              });
            },
          ),
        );
      },
    );

    if (newDuration != null) {
      setState(() {
        _timers[index] = _timers[index].copyWith(duration: newDuration);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Multi-Timer'),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),

          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: ListView(
          children: [
            TextField(
              controller: _presetNameController,

              decoration: const InputDecoration(
                labelText: 'Preset Name',

                hintText: 'e.g., Morning Workout',

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Timers',

              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            ReorderableListView(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              onReorder: _onReorder,

              children: [
                for (int index = 0; index < _timers.length; index++)
                  _buildTimerCard(index, Key('$index')),
              ],
            ),

            const SizedBox(height: 16),

            OutlinedButton(
              key: const Key('add_timer_button'),

              onPressed: _addTimer,

              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(
                  const Size(double.infinity, 50),
                ),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.add),

                  SizedBox(width: 8),

                  Text('Add Another Timer'),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            ElevatedButton(
              onPressed: _savePreset,

              child: const Text('Save Preset'),
            ),

            ElevatedButton(
              onPressed: () {
                final timerService = Provider.of<TimerService>(
                  context,

                  listen: false,
                );

                final totalDuration = _timers.fold(
                  Duration.zero,

                  (prev, step) => prev + step.duration,
                );

                final newTimer = Timerable(
                  id: const Uuid().v4(),

                  name: _presetNameController.text.isNotEmpty
                      ? _presetNameController.text
                      : 'Multi-Timer',

                  timerType: TimerType.multiTimer,

                  duration: _timers.isNotEmpty
                      ? _timers.first.duration
                      : Duration.zero,

                  initialDuration: totalDuration,

                  steps: _timers,
                );

                timerService.addTimer(newTimer);

                Navigator.of(context).pop();
              },

              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildTimerCard(int index, Key key) {

      return GestureDetector(

        key: key,

        onLongPress: () => _showDeleteConfirmationDialog(index),

        child: Card(

          margin: const EdgeInsets.only(bottom: 16),

        child: Padding(
          padding: const EdgeInsets.all(8.0),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const Icon(Icons.drag_indicator),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _timers[index].label,

                      onChanged: (value) {
                        setState(() {
                          _timers[index] = _timers[index].copyWith(
                            label: value,
                          );
                        });
                      },

                      decoration: const InputDecoration(
                        labelText: 'Timer Label',

                        hintText: 'e.g., Plank',
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: () => _showDurationPicker(index),

                      child: Text(
                        '${_timers[index].duration.inHours.toString().padLeft(2, '0')}:${(_timers[index].duration.inMinutes % 60).toString().padLeft(2, '0')}:${(_timers[index].duration.inSeconds % 60).toString().padLeft(2, '0')}',

                        style: const TextStyle(fontSize: 24),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextButton.icon(
                      onPressed: () => _showSoundSelectionDialog(index),

                      icon: const Icon(Icons.music_note),

                      label: Text(_timers[index].alertSound),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
