import 'package:expense_tracker/data/db/database_helper.dart';
import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:expense_tracker/widgets/app_bar.dart';
import 'package:expense_tracker/widgets/bottom_bar.dart';
import 'package:expense_tracker/widgets/current_balance_card.dart';
import 'package:expense_tracker/widgets/recent_transactions.dart';
import 'package:expense_tracker/widgets/search_field.dart';
import 'package:expense_tracker/widgets/total_balance_card.dart';
import 'package:expense_tracker/widgets/transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    // Load transactions once the widget is ready
    Future.microtask(() async {
      if (mounted) {
        await Provider.of<TransactionProvider>(context, listen: false)
            .readRecentTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    _transactions = provider.recentTransactions;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                return AlertDialog(
                  scrollable: true,
                  actions: [],
                  title: const Text('New Transaction'),
                  content: IntrinsicHeight(
                    child: TransactionDialog(),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
      appBar: buildAppBar(),
      body: SafeArea(
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
      ),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }
}
