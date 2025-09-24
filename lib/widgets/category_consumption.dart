import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/providers/category_provider.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:expense_tracker/data/models/category_model.dart';
import 'package:expense_tracker/data/models/transaction_model.dart';

class CategoryConsumption extends StatefulWidget {
  @override
  _CategoryConsumption createState() => _CategoryConsumption();
}

class _CategoryConsumption extends State<CategoryConsumption> {
  bool _showExpensesOnly = true;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final c = categoryProvider.categories;
    print(c.map((c2) => '${c2.id} =========> ${c2.name}'));
    return Column(
      children: [
        // Segmented Button

        SegmentedButton<bool>(
          segments: const [
            ButtonSegment<bool>(
              value: true,
              label: Text('Expenses Only'),
            ),
            ButtonSegment<bool>(
              value: false,
              label: Text('All'),
            ),
          ],
          selected: {_showExpensesOnly},
          onSelectionChanged: (Set<bool> newSelection) {
            setState(() {
              _showExpensesOnly = newSelection.first;
            });
          },
        ),

        // ListView
        Expanded(
          child: _buildCategoryList(categoryProvider, transactionProvider),
        ),
      ],
    );
  }

  Widget _buildCategoryList(CategoryProvider categoryProvider,
      TransactionProvider transactionProvider) {
    // Calculate statistics for each category
    final categoryStats = _calculateCategoryStatistics(
      categoryProvider.categories,
      transactionProvider.transactions,
      _showExpensesOnly,
    );

    if (categoryStats.isEmpty) {
      return Center(
        child: Text('No transactions found for selected filter'),
      );
    }

    return ListView.builder(
      itemCount: categoryStats.length,
      itemBuilder: (context, index) {
        final stat = categoryStats[index];
        return _buildCategoryTile(stat);
      },
    );
  }

  List<CategoryStat> _calculateCategoryStatistics(
    List<Category> categories,
    List<TransactionModel> transactions,
    bool expensesOnly,
  ) {
    // Filter transactions based on selection
    List<TransactionModel> filteredTransactions = expensesOnly
        ? transactions.where((t) => t.isExpense).toList()
        : transactions;

    if (filteredTransactions.isEmpty) {
      return [];
    }

    // Calculate total amount for percentage calculation
    double totalAmount = filteredTransactions.fold(
        0.0, (sum, transaction) => sum + transaction.amount);

    // Group transactions by category and calculate statistics
    Map<int, CategoryStat> statsMap = {};

    // Initialize all categories with zero values
    for (var category in categories) {
      statsMap[category.id!] = CategoryStat(
        category: category,
        transactionCount: 0,
        totalAmount: 0.0,
        percentage: 0.0,
      );
    }

    // Calculate actual statistics from transactions
    for (var transaction in filteredTransactions) {
      if (statsMap.containsKey(transaction.categoryId)) {
        final stat = statsMap[transaction.categoryId]!;
        final newTotalAmount = stat.totalAmount + transaction.amount;
        final newPercentage =
            totalAmount > 0 ? (newTotalAmount / totalAmount * 100) : 0.0;

        statsMap[transaction.categoryId] = CategoryStat(
          category: stat.category,
          transactionCount: stat.transactionCount + 1,
          totalAmount: newTotalAmount,
          percentage: newPercentage,
        );
      }
    }

    // Convert to list, filter out categories with no transactions, and sort by total amount (descending)
    List<CategoryStat> stats =
        statsMap.values.where((stat) => stat.transactionCount > 0).toList();
    stats.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    return stats;
  }

  Widget _buildCategoryTile(CategoryStat stat) {
    // Generate a consistent color based on category ID for the progress indicator
    final color = _generateColorFromId(stat.category.id!);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                stat.category.name,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                '${stat.transactionCount}',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: LinearProgressIndicator(
                    value: stat.percentage / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${stat.percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Text(
              '${stat.totalAmount.toStringAsFixed(2)} USD',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to generate consistent colors from category ID
  Color _generateColorFromId(int id) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
    ];
    return colors[id % colors.length];
  }
}

// Helper class to store category statistics
class CategoryStat {
  final Category category;
  final int transactionCount;
  final double totalAmount;
  final double percentage;

  CategoryStat({
    required this.category,
    required this.transactionCount,
    required this.totalAmount,
    required this.percentage,
  });
}
