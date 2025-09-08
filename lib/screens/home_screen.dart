import 'package:expense_tracker/widgets/current_balance_card.dart';
import 'package:expense_tracker/widgets/total_balance_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            children: [
              CurrentBalanceCard(),
              Row(
                spacing: 16,
                children: [
                  TotalBalanceCard(isExpense: true),
                  TotalBalanceCard(isExpense: false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
