import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _searchFiled = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchFiled,
      decoration: InputDecoration(
        labelText: 'Search Transactions',
        prefixIcon: Icon(Icons.search),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        fillColor: Colors.grey[200],
        filled: true,
        contentPadding: EdgeInsets.all(16.0),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
