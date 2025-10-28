import 'package:flutter/material.dart';
import 'package:time_blocks/models/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppSettings _appSettings;

  @override
  void initState() {
    super.initState();
    _appSettings = AppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSectionHeader('APPEARANCE'),
          _buildThemeOption(context),
          _buildSectionHeader('NOTIFICATIONS'),
          _buildNotificationSoundOption(context),
          _buildVibrationOption(context),
          _buildSectionHeader('GENERAL'),
          _buildKeepScreenOnOption(context),
          _buildRunInBackgroundOption(context),
          _buildSectionHeader('ABOUT'),
          _buildAppVersionOption(context),
          _buildRateThisAppOption(context),
          _buildPrivacyPolicyOption(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.contrast),
      title: const Text('Theme'),
      subtitle: Text(_appSettings.theme),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        debugPrint('Navigate to theme selection');
      },
    );
  }

  Widget _buildNotificationSoundOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: const Text('Notification Sound'),
      subtitle: Text(_appSettings.notificationSound),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        debugPrint('Navigate to notification sound selection');
      },
    );
  }

  Widget _buildVibrationOption(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.vibration),
      title: const Text('Vibration'),
      subtitle: Text(_appSettings.vibrationEnabled ? 'Enabled' : 'Disabled'),
      value: _appSettings.vibrationEnabled,
      onChanged: (bool value) {
        setState(() {
          _appSettings = _appSettings.copyWith(vibrationEnabled: value);
        });
      },
    );
  }

  Widget _buildKeepScreenOnOption(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.screen_lock_portrait),
      title: const Text('Keep Screen On'),
      subtitle: Text(_appSettings.keepScreenOn ? 'Enabled' : 'Disabled'),
      value: _appSettings.keepScreenOn,
      onChanged: (bool value) {
        setState(() {
          _appSettings = _appSettings.copyWith(keepScreenOn: value);
        });
      },
    );
  }

  Widget _buildRunInBackgroundOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.all_out),
      title: const Text('Run in Background'),
      subtitle: const Text('Check app permissions'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        debugPrint('Navigate to app permissions');
      },
    );
  }

  Widget _buildAppVersionOption(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.info),
      title: Text('App Version'),
      subtitle: Text('1.0.0'),
    );
  }

  Widget _buildRateThisAppOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.star_rate),
      title: const Text('Rate This App'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        debugPrint('Navigate to app store');
      },
    );
  }

  Widget _buildPrivacyPolicyOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.privacy_tip),
      title: const Text('Privacy Policy'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        debugPrint('Navigate to privacy policy');
      },
    );
  }
}
