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

  Future<List<Map>> readRecentTransactions() =>
      _runDbOperation('readRecent10transactions', (db) async {
        return await db.rawQuery('''
t.id, t.title, t.note, t.amount, t.date, t.isExpense,
        c.name AS categoryName from transactions t
    join categories c on t.category_id = c.id
    order by t.date desc
    limit 10
         
''');
      });

  Future<List<Map<String, dynamic>>> readTransactions({int? categoryId}) =>
      _runDbOperation('readTransactions', (db) async {
        // Base query
        String sql = '''
    select t.id, t.title, t.note, t.amount, t.date, t.isExpense,
           t.isSynced, c.id AS categoryId, c.name AS categoryName
    from transactions t
    join categories c ON t.category_id = c.id
  ''';

        // Add filter if categoryId is provided
        List<dynamic> args = [];
        if (categoryId != null) {
          sql += ' WHERE c.id = ?';
          args.add(categoryId);
        }

        return await db.rawQuery(sql, args);
      });

  Future<int> insertTransaction(Map<String, Object?> values) => _runDbOperation(
    'insertTransaction',
    (db) => db.insert('transactions', values),
  );

  Future<int> deleteTransaction(int transactionId) => _runDbOperation(
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
