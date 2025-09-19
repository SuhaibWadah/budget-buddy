import 'dart:async';

import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:expense_tracker/widgets/recent_transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchTransactions extends StatefulWidget {
  const SearchTransactions({super.key});

  @override
  _SearchTransactionsState createState() => _SearchTransactionsState();
}

class _SearchTransactionsState extends State<SearchTransactions> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<TransactionProvider>().readTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final transactions = provider.filteredTransactions;
    print(
        'oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo ${transactions.map((t) => t.id)} oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Search transactions...',
              border: InputBorder.none,
            ),
            onChanged: (value) {
              provider.searchTransactions(value);
              debugPrint(transactions.length.toString());
            },
          ),
        ),
        body: Container(
            color: Colors.white,
            child: transactions.isEmpty
                ? const Center(child: Text("No matching expenses"))
                : RecentTransactionsList(transactions: transactions)));
  }
}
