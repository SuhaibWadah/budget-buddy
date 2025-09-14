import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:expense_tracker/data/repositories/transactions_repo.dart';
import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:expense_tracker/services/transaction_service.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  final TransactionsRepo _transRepo;
  final TransactionService _transService;

  Future<String> _getUid() async {
    final userId = _authProvider.user!.uid;
    return userId;
  }

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  TransactionProvider(this._authProvider, this._transRepo, this._transService);

  Future<void> addTransaction(TransactionModel trans) async {
    final id = await _transRepo.insertTransaction(trans.toMap());
    trans.id = id as String;
    _transactions.add(trans);
    notifyListeners();

    if (_authProvider.isLoggedIn) {
      trans.isSynced = true;
      await _transService.addTransaction(await _getUid(), trans);
      await _transRepo.markTransactionAsSynced(trans.id);
    }
  }

  Future<void> updateTransaction(TransactionModel trans) async {
    await _transRepo.updateTransaction(trans.id, trans.toMap());
    final index = _transactions.indexWhere((t) => t.id == trans.id);
    if (index != -1) _transactions[index] = trans;
    notifyListeners();

    if (_authProvider.isLoggedIn) {
      await _transService.updateTransaction(trans.id, trans);
      trans.isSynced = true;
      await _transRepo.markTransactionAsSynced(trans.id);
    }
  }

  Future<void> deleteTransaction(String id) async {
    await _transRepo.deleteTransaction(id);
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
    if (_authProvider.isLoggedIn) {
      await _transService.deleteTransaction(await _getUid(), id);
    }
  }

  Future<void> readTransactions() async {
    final local = await _transRepo.readTransactions();
    _transactions = local
        .map((trans) => TransactionModel.fromMap(trans))
        .toList();
    notifyListeners();

    if (_authProvider.isLoggedIn) {
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
}
