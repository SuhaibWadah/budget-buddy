import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:expense_tracker/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalCard extends StatelessWidget {
  const PersonalCard({super.key});
  @override
  Widget build(BuildContext context) {
    final AuthProviders auth_provider = context.read<AuthProviders>();
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
            title: Text(auth_provider.user!.displayName ?? 'user name'),
            subtitle: Text(auth_provider.user!.email!),
            onTap: () {},
            trailing: IconButton(
              icon: Icon(Icons.logout, color: Colors.red),
              onPressed: () {
                auth_provider.signOut();
              },
            ),
          )),
    );
  }
}
