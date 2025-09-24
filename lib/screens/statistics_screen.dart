import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:expense_tracker/widgets/category_consumption.dart';
import 'package:expense_tracker/widgets/current_balance_card.dart';
import 'package:expense_tracker/widgets/total_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

Period _selectedPeriod = Period.week;

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(spacing: 16, children: [
          SegmentedButton<Period>(
            segments: Period.values.map((period) {
              return ButtonSegment<Period>(
                value: period,
                label: Text(period.name.toUpperCase()),
              );
            }).toList(),
            selected: <Period>{_selectedPeriod},
            onSelectionChanged: (newSelection) {
              setState(() {
                _selectedPeriod = newSelection.first;
              });
            },
            showSelectedIcon: false,
          ),
          CurrentBalanceCard(period: _selectedPeriod),
          Row(
            spacing: 16,
            children: [
              Expanded(
                  child: TotalBalanceCard(
                      isExpense: true, period: _selectedPeriod)),
              Expanded(
                  child: TotalBalanceCard(
                      isExpense: false, period: _selectedPeriod)),
            ],
          ),
          Text('Categories Summary'),
          Divider(),
          Expanded(child: CategoryConsumption()),
        ]));
  }
}
