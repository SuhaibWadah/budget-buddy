import 'package:expense_tracker/widgets/current_balance_card.dart';
import 'package:expense_tracker/widgets/total_balance_card.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(spacing: 16, children: [
        CurrentBalanceCard(),
        Row(
          spacing: 16,
          children: [
            Expanded(child: TotalBalanceCard(isExpense: true)),
            Expanded(child: TotalBalanceCard(isExpense: false)),
          ],
        ),
        SizedBox(height: 8),
        Text('Categories Summary'),
        Divider(),
      ]),
    );
  }
}
