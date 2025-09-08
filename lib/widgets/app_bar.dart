import 'package:flutter/material.dart';

AppBar buildAppBar() {
  return AppBar(
    title: Text('Budget Buddy'),
    actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
  );
}
