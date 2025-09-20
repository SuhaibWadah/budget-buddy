import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentBalanceCard extends StatefulWidget {
  const CurrentBalanceCard({super.key});

  @override
  _CurrentBalanceCardState createState() => _CurrentBalanceCardState();
}

class _CurrentBalanceCardState extends State<CurrentBalanceCard> {
  @override
  void initState() {
    super.initState();
    final tProvider = context.read<TransactionProvider>();
    tProvider.readTransactions(); // async, updates provider
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final currentBalance =
        provider.totalAmount(isExpense: false, period: Period.day) -
            provider.totalAmount(isExpense: true, period: Period.day);
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 250, 247),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(70),
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Balance',
              style: TextStyle(
                  color: const Color.fromARGB(255, 87, 73, 73).withAlpha(100)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currentBalance.toStringAsFixed(2),
                  style: TextStyle(
                    color: currentBalance > 0 ? Colors.green : Colors.red,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                    currentBalance > 0
                        ? Icons.trending_up
                        : Icons.trending_down,
                    color: currentBalance > 0 ? Colors.green[600] : Colors.red,
                    size: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
