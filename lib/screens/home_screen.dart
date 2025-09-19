import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:expense_tracker/screens/categories_screen.dart';
import 'package:expense_tracker/screens/main_screen.dart';
import 'package:expense_tracker/screens/statistics_screen.dart';
import 'package:expense_tracker/widgets/app_bar.dart';
import 'package:expense_tracker/widgets/bottom_bar.dart';
import 'package:expense_tracker/widgets/transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TransactionModel> _transactions = [];
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    MainPage(),
    Categories(),
    StatisticsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load transactions once the widget is ready
    Future.microtask(() {
      if (mounted) {
        Provider.of<TransactionProvider>(context, listen: false)
            .recentTransactions;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: buildAppBar(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onItemSelected: (newIndex) {
          setState(() {
            _selectedIndex = newIndex;
          });
        },
      ),
    );
  }
}
