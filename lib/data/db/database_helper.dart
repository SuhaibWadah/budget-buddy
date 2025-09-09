import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'expenses.db');
    Database mydb = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      create table "transactions"(
      "id" integer not null primary key,
      "title" text not null,
      "note" text,
      "date" text not null,
      "isExpense" integer not null,
      "isSynced" integer not null
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('sdf');
  }

  Future<List<Map>> readData(String query) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(query);
    return response;
  }

  Future<int> insert(String table, Map<String, Object?> value) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, value);
    return response;
  }

  Future<int> update(
    String table,
    Map<String, Object?> value,
    String? whereCondition,
  ) async {
    Database? mydb = await db;
    int response = await mydb!.update(
      table,
      value,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return response;
  }

  Future<int> delete(String table, String? whereCondition) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: whereCondition);
    return response;
  }
}
