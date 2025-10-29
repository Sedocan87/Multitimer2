import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_blocks/models/timer_type.dart';
import 'package:time_blocks/services/timer_service.dart';
import 'package:time_blocks/models/countdown.dart';
import 'package:uuid/uuid.dart';

class NewCountdownScreen extends StatefulWidget {
  const NewCountdownScreen({super.key});

  @override
  State<NewCountdownScreen> createState() => _NewCountdownScreenState();
}

class _NewCountdownScreenState extends State<NewCountdownScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  CountdownType _type = CountdownType.dateAndTime;
  DateTime _targetDate = DateTime.now();
  Duration _duration = const Duration(hours: 1);
  RepeatType _repeat = RepeatType.none;
  bool _enableAlert = false;
  String? _alertSound = 'Default';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('New Countdown'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            const SizedBox(height: 20),
            CupertinoSlidingSegmentedControl<CountdownType>(
              groupValue: _type,
              onValueChanged: (value) {
                if (value != null) {
                  setState(() {
                    _type = value;
                  });
                }
              },
              children: const {
                CountdownType.dateAndTime: Text('Date & Time'),
                CountdownType.duration: Text('Duration'),
              },
            ),
            const SizedBox(height: 20),
            if (_type == CountdownType.dateAndTime)
              _buildDateTimePicker()
            else
              _buildDurationPicker(),
            const SizedBox(height: 20),
            _buildCollapsibleSection(
              title: 'Repeat',
              child: _buildRepeatOptions(),
            ),
            _buildCollapsibleSection(
              title: 'Alerts',
              child: _buildAlertsOptions(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final timerService = Provider.of<TimerService>(
                    context,
                    listen: false,
                  );
                  final newTimerable = Timerable(
                    id: const Uuid().v4(),
                    name: _name,
                    timerType: TimerType.countdown,
                    countdownType: _type,
                    duration: _type == CountdownType.duration
                        ? _duration
                        : _targetDate.difference(DateTime.now()),
                    initialDuration: _type == CountdownType.duration
                        ? _duration
                        : _targetDate.difference(DateTime.now()),
                    // Add alert settings to Timerable if needed, or handle separately
                  );
                  timerService.addTimer(newTimerable);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Create Countdown'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Column(
      children: [
        ListTile(
          title: const Text('Date'),
          trailing: Text(
            '${_targetDate.year}-${_targetDate.month}-${_targetDate.day}',
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _targetDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                _targetDate = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  _targetDate.hour,
                  _targetDate.minute,
                );
              });
            }
          },
        ),
        ListTile(
          title: const Text('Time'),
          trailing: Text('${_targetDate.hour}:${_targetDate.minute}'),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(_targetDate),
            );
            if (time != null) {
              setState(() {
                _targetDate = DateTime(
                  _targetDate.year,
                  _targetDate.month,
                  _targetDate.day,
                  time.hour,
                  time.minute,
                );
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildDurationPicker() {
    return SizedBox(
      height: 200,
      child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hms,
        initialTimerDuration: _duration,
        onTimerDurationChanged: (newDuration) {
          setState(() {
            _duration = newDuration;
          });
        },
      ),
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required Widget child,
  }) {
    return ExpansionTile(title: Text(title), children: [child]);
  }

  Widget _buildRepeatOptions() {
    return Column(
      children: RepeatType.values.map((repeatType) {
        return ListTile(
          title: Text(repeatType.toString().split('.').last),
          leading: Radio<RepeatType>(
            value: repeatType,
            // ignore: deprecated_member_use
            groupValue: _repeat,
            // ignore: deprecated_member_use
            onChanged: (RepeatType? value) {
              setState(() {
                _repeat = value!;
              });
            },
          ),
          onTap: () {
            setState(() {
              _repeat = repeatType;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildAlertsOptions() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Enable Alert'),
          value: _enableAlert,
          onChanged: (value) {
            setState(() {
              _enableAlert = value;
            });
          },
        ),
        if (_enableAlert)
          ListTile(
            title: const Text('Alert Sound'),
            trailing: Text(_alertSound ?? 'Default'),
            onTap: () async {
              final selectedSound = await _showSoundPicker();
              if (selectedSound != null) {
                setState(() {
                  _alertSound = selectedSound;
                });
              }
            },
          ),
      ],
    );
  }

  Future<String?> _showSoundPicker() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Sound'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Default', 'Chime', 'Alarm', 'Signal']
                .map(
                  (sound) => ListTile(
                    title: Text(sound),
                    onTap: () {
                      Navigator.of(context).pop(sound);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
