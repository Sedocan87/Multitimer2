import 'package:flutter/material.dart';
import 'package:time_blocks/models/multi_timer.dart';

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
    // Start with one timer by default
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
    final preset = MultiTimerPreset(
      name: _presetNameController.text,
      steps: _timers,
    );
    Navigator.of(context).pop(preset);
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
            OutlinedButton.icon(
              onPressed: _addTimer,
              icon: const Icon(Icons.add),
              label: const Text('Add Another Timer'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _savePreset,
        label: const Text('Save Preset'),
        icon: const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTimerCard(int index, Key key) {
    return Card(
      key: key,
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
                        _timers[index] = _timers[index].copyWith(label: value);
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Timer Label',
                      hintText: 'e.g., Plank',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeInput(
                        initialValue: _timers[index].duration.inMinutes
                            .toString()
                            .padLeft(2, '0'),
                        onChanged: (value) {
                          final minutes = int.tryParse(value) ?? 0;
                          setState(() {
                            _timers[index] = _timers[index].copyWith(
                              duration: Duration(
                                minutes: minutes,
                                seconds: _timers[index].duration.inSeconds % 60,
                              ),
                            );
                          });
                        },
                      ),
                      const Text(':', style: TextStyle(fontSize: 24)),
                      _buildTimeInput(
                        initialValue: (_timers[index].duration.inSeconds % 60)
                            .toString()
                            .padLeft(2, '0'),
                        onChanged: (value) {
                          final seconds = int.tryParse(value) ?? 0;
                          setState(() {
                            _timers[index] = _timers[index].copyWith(
                              duration: Duration(
                                minutes: _timers[index].duration.inMinutes,
                                seconds: seconds,
                              ),
                            );
                          });
                        },
                      ),
                    ],
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
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeTimer(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInput({
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      width: 40,
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontFamily: 'monospace'),
        decoration: const InputDecoration(border: InputBorder.none),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
