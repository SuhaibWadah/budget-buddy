import 'package:expense_tracker/widgets/transaction_dialog.dart';
import 'package:flutter/material.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails(
      {super.key,
      this.id,
      required this.title,
      this.note,
      required this.amount,
      required this.date,
      required this.isExpense,
      required this.categoryId});
  final String? id;
  final String title;
  final String? note;
  final double amount;
  final DateTime date;
  final bool isExpense;
  final int categoryId;

  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Transaction Details'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TransactionDialog(
                  id: widget.id,
                  title: widget.title,
                  note: widget.note,
                  amount: widget.amount,
                  date: widget.date,
                  isExpense: widget.isExpense,
                  categoryId: widget.categoryId),
            ],
          ),
        ));
  }
}
