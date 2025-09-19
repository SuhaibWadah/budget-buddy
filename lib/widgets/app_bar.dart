import 'package:expense_tracker/screens/search_transactions_screen.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: Text('Budget Buddy'),
    actions: [
      IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchTransactions()));
          },
          icon: Icon(Icons.search))
    ],
  );
}
