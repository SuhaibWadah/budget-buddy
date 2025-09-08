import 'package:expense_tracker/widgets/app_bar.dart';
import 'package:expense_tracker/widgets/bottom_bar.dart';
import 'package:expense_tracker/widgets/current_balance_card.dart';
import 'package:expense_tracker/widgets/recent_transactions.dart';
import 'package:expense_tracker/widgets/search_field.dart';
import 'package:expense_tracker/widgets/total_balance_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Transactions'),
                  DropdownButton(
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    items: [DropdownMenuItem(child: Text('Food'))],
                    onChanged: (_) {},
                  ),
                ],
              ),
              Divider(),
              Expanded(
                child: RecentTransactionsList(names: ['suhaib', 'skdfjsa']),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }
}
