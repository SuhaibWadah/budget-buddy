import 'package:expense_tracker/data/models/settings_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 1;

  @override
  SettingsModel read(BinaryReader reader) {
    return SettingsModel(
      language: reader.readString(),
      isDarkTheme: reader.readBool(),
      currency: reader.readString(),
      notificationsEnabled: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer.writeString(obj.language);
    writer.writeBool(obj.isDarkTheme);
    writer.writeString(obj.currency);
    writer.writeBool(obj.notificationsEnabled);
  }
}
