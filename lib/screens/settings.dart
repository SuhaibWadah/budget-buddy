import 'package:expense_tracker/widgets/personal_card.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

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
            Text('Preferences'),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              tileColor: const Color.fromARGB(137, 221, 217, 224),
              leading: Icon(Icons.nightlight_sharp),
              trailing: Switch(value: false, onChanged: (val) {}),
              title: Text('Dark Mode'),
              subtitle: Text('Enable dark mode'),
            ),
            ListTile(
              tileColor: const Color.fromARGB(137, 221, 217, 224),
              leading: Icon(Icons.notifications),
              trailing: Switch(value: false, onChanged: (val) {}),
              title: Text('Notifications'),
              subtitle: Text('Receive transactions alerts'),
            ),
            ListTile(
              tileColor: const Color.fromARGB(137, 221, 217, 224),
              leading: Icon(Icons.attach_money),
              trailing: IconButton(
                  onPressed: () {}, icon: Icon(Icons.arrow_forward_ios)),
              title: Text('Cuurency'),
              subtitle: Text('Cuurent: USD'),
            ),
            Text('Actions'),
          ],
        ),
      ),
    );
  }
}
