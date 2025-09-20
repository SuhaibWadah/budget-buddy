import 'package:expense_tracker/widgets/personal_card.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
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
                value: true,
                onChanged: (v) => setState(() {}),
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
                value: true,
                onChanged: (v) => setState(() {}),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.grey.shade100,
              child: ListTile(
                title: Text('Currency'),
                subtitle: Text('Current: USD'),
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
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("YER"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("SAR"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("EGP"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("EUR"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("JPY"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ));
}

void _showLanguageDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Select Currency'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                title: Text("English"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Arabic"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ]),
          ));
}
