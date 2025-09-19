import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:expense_tracker/widgets/transaction_dialog.dart';
import 'package:flutter/material.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({super.key, required this.trans});
  final TransactionModel trans;

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
              TransactionDialog(transaction: widget.trans),
            ],
          ),
        ));
  }
}
