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

  Future<List<Map<String, dynamic>>> readRecentTransactions() =>
      _runDbOperation('readRecent10transactions', (db) async {
        return await db.rawQuery(''' select
t.id as transactionId, t.title, t.note, t.amount, t.date, t.isExpense, t.categoryId,
        c.name AS categoryName from transactions t
    join categories c on t.categoryId = c.id
    order by t.date desc
    limit 10
         
''');
      });

  Future<List<Map<String, dynamic>>> readTransactions({String? transId}) =>
      _runDbOperation('readTransactions', (db) async {
        // Base query
        String sql = '''
    select t.id, t.title, t.note, t.amount, t.date, t.isExpense,
           t.isSynced, t.categoryId, c.id, c.name AS categoryName
    from transactions t
    join categories c ON t.categoryId = c.id
  ''';

        // Add filter if categoryId is provided
        List<dynamic> args = [];
        if (transId != null) {
          sql += ' WHERE c.id = ?';
          args.add(transId);
        }

        return await db.rawQuery(sql, args);
      });

  Future<int> insertTransaction(Map<String, Object?> values) {
    return _runDbOperation(
      'insertTransaction',
      (db) async {
        final id = await db.insert('transactions', values);

        // Debug: dump all rows after insert
        final all = await db.query('transactions');
        for (var row in all) {
          debugPrint("Row after insert: $row");
        }

        return id;
      },
    );
  }

  Future<int> deleteTransaction(String transactionId) => _runDbOperation(
        'deleteTransaction',
        (db) => db.delete('transactions',
            where: 'id = ?', whereArgs: [transactionId]),
      );
  Future<int> deleteAllTransactions() => _runDbOperation(
      'deleteAllTransactions', (db) => db.delete('transactions'));

  Future<int> updateTransaction(Map<String, Object?> values) async {
    return await _runDbOperation('updateTransaction', (db) async {
      debugPrint('Repo update WHERE id = ${values['id']}');
      final all = await db.query('transactions');
      debugPrint(all.map((t) => t['id']).toList().toString());

      final count = await db.update(
        'transactions',
        values,
        where: 'id = ?',
        whereArgs: [values['id']],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('DB updated $count row(s) for id ${values['id']}');
      return count;
    });
  }

  Future<int> markTransactionAsSynced(String transactionId) => _runDbOperation(
        'markTransactionAsSynced',
        (db) => db.update(
          'transactions',
          {'isSynced': 1},
          where: 'id: ?',
          whereArgs: [transactionId],
        ),
      );
}
