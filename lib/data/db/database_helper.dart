import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'transactions.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      create table transactions(
      id text primary key,
      title text,
      note text,
      category text,
      amount real,
      date text,
      )
''');

    await db.execute('''
    create table categories(
    id integer primary key autoincrement,
    name text unique,
    )
''');

    await db.insert('categories', {'name': 'Food'});
    await db.insert('categories', {'name': 'Shopping'});
    await db.insert('categories', {'name': 'Bills'});
  }
}
