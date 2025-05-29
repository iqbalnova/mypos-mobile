import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'encryption_helper.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart_database.db');

    return await openDatabase(
      path,
      version: 1,
      password: EncryptionHelper.encrypt('product-password'),
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT NOT NULL,
        productName TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        UNIQUE(productId)
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
