import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:expense_tracker/widgets/current_balance_card.dart';
import 'package:expense_tracker/widgets/recent_transactions.dart';
import 'package:expense_tracker/widgets/search_field.dart';
import 'package:expense_tracker/widgets/total_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  MainPage({
    super.key,
  });
  List<TransactionModel> _transactions = [];
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    _transactions = provider.recentTransactions;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          spacing: 16,
          children: [
            CurrentBalanceCard(),
            Row(
              spacing: 16,
              children: [
                Expanded(child: TotalBalanceCard(isExpense: true)),
                Expanded(child: TotalBalanceCard(isExpense: false)),
              ],
            ),
            SizedBox(height: 8),
            SearchField(),
            Text('Recent Transactions'),
            Divider(),
            Expanded(
                child: RecentTransactionsList(
                    transactions: provider.recentTransactions)),
          ],
        ),
      ),
    );
  }
}
