import 'package:expense_tracker/providers/settings_provider.dart';
import 'package:expense_tracker/widgets/personal_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PersonalCard(),
            SizedBox(height: 16),
            Text('Preferences', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.grey.shade100,
              child: SwitchListTile(
                title: Text('Dark mode'),
                subtitle: Text('Enable dark mode'),
                secondary: Icon(Icons.dark_mode),
                value: settingsProvider.settings.isDarkTheme,
                onChanged: (_) {
                  setState(() {
                    settingsProvider.toggleTheme();
                  });
                },
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.grey.shade100,
              child: SwitchListTile(
                title: Text('Notifications'),
                subtitle: Text('Receive transactions alerts'),
                secondary: Icon(Icons.notifications),
                value: settingsProvider.settings.notificationsEnabled,
                onChanged: (_) {
                  setState(() {
                    settingsProvider.toggleNotification();
                  });
                },
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.grey.shade100,
              child: ListTile(
                title: Text('Currency'),
                subtitle:
                    Text('Current: ${settingsProvider.settings.currency}'),
                leading: Icon(Icons.attach_money_outlined),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showCurrencyDialog(context);
                },
              ),
            ),
            SizedBox(height: 16),
            Text('Actions', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.grey.shade100,
              child: ListTile(
                title: Text('Export Data'),
                leading: Icon(Icons.download),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _export(context);
                },
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.grey.shade100,
              child: ListTile(
                title: Text('Language'),
                leading: Icon(Icons.language),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showLanguageDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _export(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'))
            ],
          ));
}

void _showCurrencyDialog(BuildContext context) {
  final settingsProvider = context.read<SettingsProvider>();
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Select Currency'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("USD"),
                  onTap: () {
                    settingsProvider.changeCurrency("USD");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("YER"),
                  onTap: () {
                    settingsProvider.changeCurrency("YER");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("SAR"),
                  onTap: () {
                    settingsProvider.changeCurrency("SAR");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("EGP"),
                  onTap: () {
                    settingsProvider.changeCurrency("EGP");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("EUR"),
                  onTap: () {
                    settingsProvider.changeCurrency("EUR");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("JPY"),
                  onTap: () {
                    settingsProvider.changeCurrency("JPY");
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ));
}

void _showLanguageDialog(BuildContext context) {
  final settingsProvider = context.read<SettingsProvider>();
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Select Currency'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                title: Text("English"),
                onTap: () {
                  settingsProvider.changeLanguage("en");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Arabic"),
                onTap: () {
                  settingsProvider.changeLanguage("ar");
                  Navigator.pop(context);
                },
              ),
            ]),
          ));
}
