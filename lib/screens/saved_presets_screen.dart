import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_blocks/services/timer_service.dart';

class SavedPresetsScreen extends StatelessWidget {
  const SavedPresetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Presets')),
      body: Consumer<TimerService>(
        builder: (context, timerService, child) {
          return ListView.builder(
            itemCount: timerService.savedPresets.length,
            itemBuilder: (context, index) {
              final preset = timerService.savedPresets[index];
              return ListTile(
                title: Text(preset.name),
                trailing: ElevatedButton(
                  onPressed: () {
                    timerService.addTimer(preset);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Start'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
