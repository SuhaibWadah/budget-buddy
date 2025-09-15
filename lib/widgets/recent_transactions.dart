import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:flutter/material.dart';

class RecentTransactionsList extends StatefulWidget {
  const RecentTransactionsList({super.key, required this.transactions});
  final List<TransactionModel> transactions;

  @override
  _RecentTransactionsListState createState() => _RecentTransactionsListState();
}

class _RecentTransactionsListState extends State<RecentTransactionsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.transactions.length,
      itemBuilder: (context, index) {
        return ListTile(
          style: ListTileStyle.drawer,
          leading: Icon(Icons.food_bank),
          title: Text(widget.transactions[index].title),
          subtitle: Row(
            children: [Text('Foods'), Text(widget.transactions[index].date)],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.transactions[index].isExpense
                    ? '- ${widget.transactions[index].amount}'
                    : '${widget.transactions[index].amount}',
              ),
              Icon(Icons.delete, color: Colors.red[700]),
            ],
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
