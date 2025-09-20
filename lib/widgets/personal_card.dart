import 'package:flutter/material.dart';

class PersonalCard extends StatelessWidget {
  const PersonalCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: const Color.fromARGB(255, 153, 130, 190),
              child: Icon(Icons.person),
            ),
            title: Text('Suhaib'),
            subtitle: Text('Suhaibwadah@gmail.com'),
          )),
    );
  }
}
