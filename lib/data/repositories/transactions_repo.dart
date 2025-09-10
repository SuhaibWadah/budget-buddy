import 'package:expense_tracker/data/db/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class TransactionsRepo {
  final dbHelper = DatabaseHelper();
  late final Future<Database?> _dbHelper;

  TransactionsRepo() {
    _dbHelper = dbHelper.db;
  }

  Future<Database> _getDbOrThrow() async {
    final db = await _dbHelper;
    if (db == null) throw Exception("Database is not initialized.");
    return db;
  }

  Future<T> _runDbOperation<T>(
    String label,
    Future<T> Function(Database db) operation,
  ) async {
    try {
      final db = await _getDbOrThrow();
      return await operation(db);
    } catch (e, stackTrace) {
      debugPrint('$label failed: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Database operation "$label" failed');
    }
  }

  Future<List<Map>> readTransactions() =>
      _runDbOperation('readTransactions', (db) => db.query('transactions'));

  Future<int> insertCategory(Map<String, Object?> values) => _runDbOperation(
    'insertTransaction',
    (db) => db.insert('transactions', values),
  );

  Future<int> deleteCategory(int transactionId) => _runDbOperation(
    'deleteTransaction',
    (db) =>
        db.delete('transactions', where: 'id = ?', whereArgs: [transactionId]),
  );

  Future<int> updateTransaction(
    int transactionId,
    Map<String, Object?> values,
  ) => _runDbOperation(
    'updateTransaction',
    (db) => db.update(
      'transactions',
      values,
      where: 'id = ?',
      whereArgs: [transactionId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    ),
  );
}
