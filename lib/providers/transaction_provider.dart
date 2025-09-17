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

  List<TransactionModel> _recentTransactions = [];
  List<TransactionModel> get recentTransactions => _recentTransactions;

  TransactionProvider(this._transRepo, this._transService);

  Future<void> addTransaction(TransactionModel trans) async {
    await _transRepo.insertTransaction(trans.toMap());

    _transactions.add(trans);
    if (_recentTransactions.length == 10) {
      _recentTransactions.removeAt(0);
    }
    _recentTransactions.add(trans);
    readRecentTransactions();
    notifyListeners();

    if (_authProvider!.isLoggedIn) {
      trans.isSynced = true;
      await _transService.addTransaction(await _getUid(), trans);
      await _transRepo.markTransactionAsSynced(trans.id);
    }
  }

  Future<void> updateTransaction(TransactionModel trans) async {
    await _transRepo.updateTransaction(trans.id, trans.toMap());
    print('Updated .....................................');
    final index = _transactions.indexWhere((t) => t.id == trans.id);
    if (index != -1) _transactions[index] = trans;
    notifyListeners();
    final index2 = _recentTransactions.indexWhere((t) => t.id == trans.id);
    if (index2 != -1) _recentTransactions[index2] = trans;
    notifyListeners();
    print('Fully updated ................................');
    if (_authProvider!.isLoggedIn) {
      await _transService.updateTransaction(trans.id, trans);
      trans.isSynced = true;
      await _transRepo.markTransactionAsSynced(trans.id);
    }
  }

  Future<void> deleteAllTransactions() async {
    print('Not Deleted !!!!!!!!!!!!!!!!!!!!111');
    await _transRepo.deleteAllTransactions();
    print('Deleted !!!!!!!!!!!!!!!11');
    _transactions.clear();
    _recentTransactions.clear();
    notifyListeners();

    if (_authProvider!.isLoggedIn) {
      await _transService.deleteAllTransactions(await _getUid());
    }
  }

  Future<void> deleteTransaction(String id) async {
    await _transRepo.deleteTransaction(id);
    _transactions.removeWhere((t) => t.id == id);
    _recentTransactions.removeWhere((t) => t.id == id);
    notifyListeners();
    if (_authProvider!.isLoggedIn) {
      await _transService.deleteTransaction(await _getUid(), id);
    }
  }

  Future<void> readTransactions() async {
    final local = await _transRepo.readTransactions();
    _transactions =
        local.map((trans) => TransactionModel.fromMap(trans)).toList();

    notifyListeners();

    if (_authProvider!.isLoggedIn) {
      final remote = await _transService.readTransactions(await _getUid());
      for (var tx in remote) {
        if (!_transactions.any((t) => t.id == tx.id)) {
          _transactions.add(tx);
          await _transRepo.insertTransaction(tx.toMap());
        }
      }
      notifyListeners();
    }
  }

  Future<void> readRecentTransactions() async {
    final local = await _transRepo.readRecentTransactions();

    _recentTransactions =
        local.map((tx) => TransactionModel.fromMap(tx)).toList();

    notifyListeners();
  }

  double totalAmount({required bool isExpense, Period period = Period.day}) {
    final now = DateTime.now();

    DateTime start;

    switch (period) {
      case Period.day:
        start = DateTime(now.year, now.month, now.day);
        break;
      case Period.week:
        start = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: now.weekday - 1)); // start of week (Mon)
        break;
      case Period.month:
        start = DateTime(now.year, now.month, 1); // first day of month
        break;
      case Period.year:
        start = DateTime(now.year, 1, 1); // first day of year
        break;
    }

    return _transactions
        .where((t) =>
            t.isExpense == isExpense &&
            t.date.isAfter(
                start.subtract(const Duration(seconds: 1)))) // include start
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}
