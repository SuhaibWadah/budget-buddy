import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  // Private constructor
  DatabaseHelper._internal();

  // Factory constructor returns the same instance
  factory DatabaseHelper() => instance;

  static Database? _db;

  Future<Database?> get db async {
    _db ??= await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'expenses.db');
    Database mydb = await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    await mydb.execute('PRAGMA foreign_keys = ON;');
    return mydb;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      create table "transactions"(
      "id" text not null primary key,
      "title" text not null,
      "note" text,
      "date" integer not null,
      "amount" real not null,
      "isExpense" integer not null,
      "isSynced" integer not null,
      "categoryId" integer not null,
       foreign key (categoryId) references categories(id) on delete cascade
      )
    ''');

    await db.execute('''
    create table "categories"(
    "id" integer not null primary key,
    "name" text not null unique,
    "isSynced" integer not null
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.transaction((txn) async {
        await txn.execute('PRAGMA foreign_keys=OFF;');
        await txn
            .execute('ALTER TABLE transactions RENAME TO transactions_old;');

        await txn.execute('''
    CREATE TABLE transactions (
      id TEXT NOT NULL PRIMARY KEY,
      title TEXT NOT NULL,
      note TEXT,
      date INTEGER NOT NULL,
      amount REAL NOT NULL,
      isExpense INTEGER NOT NULL,
      isSynced INTEGER NOT NULL,
      categoryId INTEGER NOT NULL,
      FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE CASCADE
    )
  ''');

        final oldData = await txn.query('transactions_old');
        final batch = txn.batch();
        for (var row in oldData) {
          final parsedDate = DateTime.tryParse(row['date'] as String);
          final timestamp = parsedDate?.millisecondsSinceEpoch ?? 0;
          batch.insert('transactions', {
            'id': row['id'],
            'title': row['title'],
            'note': row['note'],
            'date': timestamp,
            'amount': row['amount'],
            'isExpense': row['isExpense'],
            'isSynced': row['isSynced'],
            'categoryId': row['categoryId'],
          });
        }
        await batch.commit(noResult: true);

        await txn.execute('DROP TABLE transactions_old;');
        await txn.execute('PRAGMA foreign_keys=ON;');
      });
    }
    print('Running upgrade from $oldVersion to $newVersion');
  }
}
