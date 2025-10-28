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
  TimeOfDay? _alertTime;
  String? _alertSound = 'Default';
  bool _isRepeatExpanded = false;
  bool _isAlertsExpanded = false;

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
              isExpanded: _isRepeatExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isRepeatExpanded = expanded;
                });
              },
              child: _buildRepeatOptions(),
            ),
            _buildCollapsibleSection(
              title: 'Alerts',
              isExpanded: _isAlertsExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isAlertsExpanded = expanded;
                });
              },
              child: _buildAlertsOptions(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final timerService = Provider.of<TimerService>(context, listen: false);
                  final newCountdown = Timerable(
                    id: const Uuid().v4(),
                    name: _name,
                    timerType: TimerType.countdown,
                    duration: _type == CountdownType.duration ? _duration : _targetDate.difference(DateTime.now()),
                  );
                  timerService.addTimer(newCountdown);
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
    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.dateAndTime,
        initialDateTime: _targetDate,
        onDateTimeChanged: (newDate) {
          setState(() {
            _targetDate = newDate;
          });
        },
      ),
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
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
    required Widget child,
  }) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        onExpansionChanged(!isExpanded);
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(title: Text(title));
          },
          body: child,
          isExpanded: isExpanded,
        ),
      ],
    );
  }

  Widget _buildRepeatOptions() {
    return Column(
      children: RepeatType.values.map((repeatType) {
        return ListTile(
          title: Text(repeatType.toString().split('.').last),
          leading: Radio<RepeatType>(
            value: repeatType,
            groupValue: _repeat,
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
        ListTile(
          title: const Text('Alert Time'),
          trailing: Text(_alertTime?.format(context) ?? 'Not set'),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: _alertTime ?? TimeOfDay.now(),
            );
            if (time != null) {
              setState(() {
                _alertTime = time;
              });
            }
          },
        ),
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
