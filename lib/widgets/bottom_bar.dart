import 'package:flutter/material.dart';

NavigationBar buildBottomNavBar() {
  var sIndex = 0;
  return NavigationBar(
    selectedIndex: sIndex,
    onDestinationSelected: (index) {
      sIndex = index;
    },
    destinations: const [
      NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.category), label: 'Categories'),
      NavigationDestination(icon: Icon(Icons.analytics), label: 'Statistics'),
      NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
    ],
  );
}
