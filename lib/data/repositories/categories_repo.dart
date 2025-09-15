import 'package:expense_tracker/data/db/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class CategoriesRepo {
  final dbHelper = DatabaseHelper();
  late final Future<Database?> _dbHelper;

  CategoriesRepo() {
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
      final db = await DatabaseHelper.instance.db; // singleton DB
      if (db == null) {
        throw Exception('Database not initialized');
      }
      debugPrint('Inside the op');
      final result = await operation(db);
      return result;
    } catch (e) {
      debugPrint('$label failed: $e');
      throw Exception('Database operation "$label" failed');
    }
  }

  Future<List<Map>> readCategories() => _runDbOperation(
        'readCategories',
        (db) => db.query('categories'),
      );

  Future<int> insertCategory(Map<String, Object?> values) => _runDbOperation(
        'insertCategory',
        (db) => db.insert('categories', values),
      );

  Future<int> deleteCategory(int categoryId) => _runDbOperation(
        'deleteCategory',
        (db) =>
            db.delete('categories', where: 'id = ?', whereArgs: [categoryId]),
      );

  Future<int> markCategoryAsSynced(int? categoryId) => _runDbOperation(
        'markAsSynced',
        (db) => db.update(
          'categories',
          {'isSynced': 1},
          where: 'id = ?',
          whereArgs: [categoryId],
        ),
      );
}
