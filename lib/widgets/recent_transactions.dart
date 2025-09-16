import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:expense_tracker/screens/transaction_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentTransactionsList extends StatefulWidget {
  const RecentTransactionsList({super.key, required this.transactions});
  final List<TransactionModel> transactions;

  @override
  _RecentTransactionsListState createState() => _RecentTransactionsListState();
}

class _RecentTransactionsListState extends State<RecentTransactionsList> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final transactions = widget.transactions;

    return ListView.separated(
      padding: EdgeInsets.only(top: 8),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final trans = transactions[index];
        return ListTile(
          style: ListTileStyle.drawer,
          leading: Icon(Icons.food_bank),
          title: Text(trans.title),
          subtitle: Row(
            children: [
              Text(
                  "${trans.date.year}-${trans.date.month.toString().padLeft(2, '0')}-${trans.date.day.toString().padLeft(2, '0')}")
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                trans.isExpense ? '- ${trans.amount}' : '${trans.amount}',
              ),
              IconButton(
                  onPressed: () {
                    provider.deleteAllTransactions();
                  },
                  icon: Icon(Icons.delete, color: Colors.red[700])),
            ],
          ),
          tileColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: () {
            debugPrint(
                " suiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii ${trans.categoryId}");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransactionDetails(
                        title: trans.title,
                        note: trans.note,
                        amount: trans.amount,
                        date: trans.date,
                        isExpense: trans.isExpense,
                        categoryId: trans.categoryId)));
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 8),
    );
  }
}
