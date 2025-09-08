import 'package:flutter/material.dart';

class RecentTransactionsList extends StatefulWidget {
  const RecentTransactionsList({super.key, required this.names});
  final List<String> names;

  @override
  _RecentTransactionsListState createState() => _RecentTransactionsListState();
}

class _RecentTransactionsListState extends State<RecentTransactionsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.names.length,
      itemBuilder: (context, index) {
        return ListTile(
          style: ListTileStyle.drawer,
          leading: Icon(Icons.food_bank),
          title: Text('Grocery'),
          subtitle: Row(children: [Text('Food'), Text('90/1/2034')]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text('-43\$'), Icon(Icons.delete)],
          ),
          tileColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 8),
    );
  }
}
