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

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      create table "transactions"(
      "id" text not null primary key,
      "title" text not null,
      "note" text,
      "date" text not null,
      "amount" real not null,
      "isExpense" integer not null,
      "isSynced" integer not null,
      "categoryId" integer not null,
       foreign key (category_id) references categories(id) on delete cascade
      )
    ''');

    await db.execute('''
    create table "categories"(
    "id" integer not null primary key,
    "name" text not null unique,
    "isSynced" integer not null,
    )
''');

    await db.execute('''
  INSERT INTO categories (name, isSynced) VALUES
    ("Food", 0),
    ("Transport", 0),
    ("Entertainment", 0),
    ("Family", 0),
    ("Friends", 0),
    ("Grocery", 0),
    ("Rent", 0),
    ("Personal Care", 0),
    ("Shopping", 0),
    ("Health & Medicine", 0),
    ("Utilities", 0),
    ("Gifts", 0)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}
}
