import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/receipt.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('receipts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE receipts (
        id TEXT PRIMARY KEY,
        createdAt INTEGER NOT NULL,
        imagePath TEXT NOT NULL,
        vendorName TEXT,
        totalAmount REAL NOT NULL,
        potentialTaxSaving REAL NOT NULL,
        category TEXT
      )
    ''');
  }

  Future<String> insertReceipt(Receipt receipt) async {
    final db = await database;
    await db.insert('receipts', receipt.toMap());
    return receipt.id;
  }

  Future<Receipt?> getReceipt(String id) async {
    final db = await database;
    final maps = await db.query('receipts', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;
    return Receipt.fromMap(maps.first);
  }

  Future<List<Receipt>> getAllReceipts() async {
    final db = await database;
    final maps = await db.query('receipts', orderBy: 'createdAt DESC');

    return maps.map((map) => Receipt.fromMap(map)).toList();
  }

  Future<double> getTotalPotentialSavings() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(potentialTaxSaving) as total FROM receipts',
    );

    return (result.first['total'] as double?) ?? 0.0;
  }

  Future<int> getReceiptCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM receipts');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> deleteReceipt(String id) async {
    final db = await database;
    return await db.delete('receipts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
