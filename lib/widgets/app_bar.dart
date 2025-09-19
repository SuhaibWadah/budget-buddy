import 'package:expense_tracker/screens/search_transactions_screen.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar() {
  return AppBar(
    title: Text('Budget Buddy'),
    actions: [
      IconButton(
          onPressed: () {
            SearchTransactions();
          },
          icon: Icon(Icons.search))
    ],
  );
}
