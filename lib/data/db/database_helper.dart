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
      "isSynced" integer not null,
       foreign key (category_id) references categories(id) on delete cascade
      )
    ''');

    await db.execute('''
    create table "categories"(
    "id" integer not null primary key,
    "name" text not null unique,
    )
''');

    await db.execute('''
  INSERT INTO categories (name)
  VALUES ("Food"), ("Transport"), ("Entertainment"), ("Family"), ("Friends"), ("Grocery"), ("Rent"), ("Personal Care"),("Shopping"), ("Health & Medicine") ("Utilities"), ("Gifts")
 ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}
}
