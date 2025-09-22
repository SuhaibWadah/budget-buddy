import 'package:expense_tracker/data/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider with ChangeNotifier {
  static const String _boxName = 'settingsBox';
  late Box<SettingsModel> _box;

  SettingsModel _settings = SettingsModel(
      language: "en",
      isDarkTheme: false,
      currency: 'USD',
      notificationsEnabled: false);

  SettingsModel get settings => _settings;

  Future<void> init() async {
    _box = await Hive.openBox<SettingsModel>(_boxName);
    if (_box.isNotEmpty) {
      _settings = _box.get('userSettings')!;
    } else {
      await _box.put("userSettings", _settings);
    }
    notifyListeners();
  }

  Future<void> updateSettings(SettingsModel newSettings) async {
    _settings = newSettings;
    await _box.put("userSettings", _settings);
    notifyListeners();
  }

  void toggleTheme() {
    updateSettings(_settings.copyWith(isDarkTheme: !_settings.isDarkTheme));
    notifyListeners();
  }

  void changeLanguage(String lang) {
    updateSettings(_settings.copyWith(language: lang));
    notifyListeners();
  }

  void changeCurrency(String curr) {
    updateSettings(_settings.copyWith(currency: curr));
    notifyListeners();
  }

  void toggleNotification() {
    updateSettings(_settings.copyWith(
        notificationsEnabled: !_settings.notificationsEnabled));
    notifyListeners();
  }
}
