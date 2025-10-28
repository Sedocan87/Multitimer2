class AppSettings {
  final bool vibrationEnabled;
  final bool keepScreenOn;
  final String notificationSound;
  final String theme;

  AppSettings({
    this.vibrationEnabled = true,
    this.keepScreenOn = false,
    this.notificationSound = 'default',
    this.theme = 'system',
  });

  AppSettings copyWith({
    bool? vibrationEnabled,
    bool? keepScreenOn,
    String? notificationSound,
    String? theme,
  }) {
    return AppSettings(
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      notificationSound: notificationSound ?? this.notificationSound,
      theme: theme ?? this.theme,
    );
  }
}
