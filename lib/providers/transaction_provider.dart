import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:expense_tracker/data/repositories/transactions_repo.dart';
import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:expense_tracker/services/transaction_service.dart';
import 'package:flutter/material.dart';

enum Period { day, week, month, year }

class TransactionProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  final TransactionsRepo _transRepo;
  final TransactionService _transService;

  Future<String> _getUid() async {
    final userId = _authProvider!.user!.uid;
    return userId;
  }

  void updateAuth(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  List<TransactionModel> _filteredTransactions = [];
  List<TransactionModel> get filteredTransactions => _filteredTransactions;

  /// Returns last 10 added transactions (newest first)
  List<TransactionModel> get recentTransactions =>
      _transactions.reversed.take(10).toList();

  TransactionProvider(this._transRepo, this._transService);

  double get totalSpendings {
    return transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Map<int, double> get categoryTotals {
    final map = <int, double>{};
    for (var tx in transactions) {
      if (tx.isExpense) {
        map[tx.categoryId] = (map[tx.categoryId] ?? 0) + tx.amount;
      }
    }
    return map;
  }

  Map<int, double> get categoryPercentages {
    final total = totalSpendings;
    if (total == 0) return {};
    return categoryTotals
        .map((id, amount) => MapEntry(id, (amount / total).clamp(0.0, 1.0)));
  }

  void searchTransactions(String query) {
    if (query.trim().isEmpty) {
      _filteredTransactions = _transactions;
    } else {
      _filteredTransactions = _transactions
          .where((tx) => tx.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    print(
        'Searching Transactions called: ${filteredTransactions.map((t) => '${t.id} and ${t.title}')} Searching done!!!!!!!!!!!111');
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel trans) async {
    await _transRepo.insertTransaction(trans.toMap());
    _transactions.add(trans);
    print('Added : ${trans.toMap().toString()}');
    notifyListeners();

    if (_authProvider!.isLoggedIn) {
      trans.isSynced = true;
      await _transService.addTransaction(await _getUid(), trans);
      await _transRepo.markTransactionAsSynced(trans.id);
    }
  }

  Future<void> updateTransaction(TransactionModel trans) async {
    await _transRepo.updateTransaction(trans.toMap());
    debugPrint('Updating transaction with id: ${trans.id}');

    // Update the transaction in _transactions
    final index = _transactions.indexWhere((t) => t.id == trans.id);
    if (index != -1) {
      _transactions[index] = trans;
      debugPrint('_transactions updated');
    }

    // Reapply search filter to update _filteredTransactions
    searchTransactions("");

    notifyListeners();

    if (_authProvider!.isLoggedIn) {
      await _transService.updateTransaction(trans.id, trans);
      trans.isSynced = true;
      await _transRepo.markTransactionAsSynced(trans.id);
    }
  }

  Future<void> deleteTransaction(String id) async {
    await _transRepo.deleteTransaction(id);
    _transactions.removeWhere((t) => t.id == id);
    print('Delted Transaction with id $id');
    notifyListeners();

    if (_authProvider!.isLoggedIn) {
      await _transService.deleteTransaction(await _getUid(), id);
    }
  }

  Future<void> deleteAllTransactions() async {
    await _transRepo.deleteAllTransactions();
    _transactions.clear();

    searchTransactions("");
    notifyListeners();

    if (_authProvider!.isLoggedIn) {
      await _transService.deleteAllTransactions(await _getUid());
    }
  }

  Future<void> readTransactions() async {
    final local = await _transRepo.readTransactions();
    _transactions =
        local.map((trans) => TransactionModel.fromMap(trans)).toList();

    // Update filtered transactions
    searchTransactions("");

    debugPrint("DB transactions: ${local.map((t) => t['title'])}");

    if (_authProvider!.isLoggedIn) {
      final remote = await _transService.readTransactions(await _getUid());
      for (var tx in remote) {
        if (!_transactions.any((t) => t.id == tx.id)) {
          _transactions.add(tx);
          await _transRepo.insertTransaction(tx.toMap());
        }
      }

      searchTransactions("");
      notifyListeners();
    }
  }

  double totalAmount({bool? isExpense, Period period = Period.day}) {
    final now = DateTime.now();
    DateTime start;

    switch (period) {
      case Period.day:
        start = DateTime(now.year, now.month, now.day);
        break;
      case Period.week:
        start =
            DateTime(now.year, now.month, now.day).subtract(Duration(days: 6));
        break;
      case Period.month:
        start = DateTime(now.year, now.month, 1);
        break;
      case Period.year:
        start = DateTime(now.year, 1, 1);
        break;
    }

    return _transactions
        .where((t) =>
            t.isExpense == isExpense &&
            t.date.isAfter(start.subtract(const Duration(seconds: 1))))
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}
