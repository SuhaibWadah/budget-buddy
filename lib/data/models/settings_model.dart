import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class SettingsModel {
  @HiveField(0)
  final String language;

  @HiveField(1)
  final bool isDarkTheme;

  @HiveField(2)
  final String currency;

  @HiveField(3)
  final bool notificationsEnabled;

  SettingsModel({
    required this.language,
    required this.isDarkTheme,
    required this.currency,
    required this.notificationsEnabled,
  });

  SettingsModel copyWith({
    String? language,
    bool? isDarkTheme,
    String? currency,
    bool? notificationsEnabled,
  }) {
    return SettingsModel(
      language: language ?? this.language,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
