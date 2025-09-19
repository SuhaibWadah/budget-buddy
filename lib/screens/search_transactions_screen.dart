import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:expense_tracker/widgets/recent_transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchTransactions extends StatefulWidget {
  SearchTransactions({Key? key}) : super(key: key);

  @override
  _SearchTransactionsState createState() => _SearchTransactionsState();
}

class _SearchTransactionsState extends State<SearchTransactions> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final transactions = provider.filteredTransactions;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search transactions...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  provider.searchTransaction(value);
                },
              )
            : const Text('Expenses'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  provider.searchTransaction(""); // reset
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: _isSearching
          ? Container(
              color: Colors.white,
              child: transactions.isEmpty
                  ? const Center(child: Text("No matching expenses"))
                  : RecentTransactionsList(transactions: transactions))
          : Center(child: Text("Normal expenses screen here...")),
    );
  }
}
