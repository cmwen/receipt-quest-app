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

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE receipts (
        id TEXT PRIMARY KEY,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER,
        imagePath TEXT NOT NULL,
        vendorName TEXT,
        totalAmount REAL NOT NULL,
        potentialTaxSaving REAL NOT NULL,
        category TEXT,
        notes TEXT,
        financialYearId TEXT DEFAULT '',
        isDeleted INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migration from version 1 to version 2
      await db.execute('ALTER TABLE receipts ADD COLUMN updatedAt INTEGER');
      await db.execute('ALTER TABLE receipts ADD COLUMN notes TEXT');
      await db.execute(
        "ALTER TABLE receipts ADD COLUMN financialYearId TEXT DEFAULT ''",
      );
      await db.execute(
        'ALTER TABLE receipts ADD COLUMN isDeleted INTEGER DEFAULT 0',
      );
    }
  }

  Future<String> insertReceipt(Receipt receipt) async {
    final db = await database;
    await db.insert('receipts', receipt.toMap());
    return receipt.id;
  }

  Future<int> updateReceipt(Receipt receipt) async {
    final db = await database;
    final updatedReceipt = receipt.copyWith(updatedAt: DateTime.now());
    return await db.update(
      'receipts',
      updatedReceipt.toMap(),
      where: 'id = ?',
      whereArgs: [receipt.id],
    );
  }

  Future<Receipt?> getReceipt(String id) async {
    final db = await database;
    final maps = await db.query(
      'receipts',
      where: 'id = ? AND isDeleted = 0',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Receipt.fromMap(maps.first);
  }

  Future<List<Receipt>> getAllReceipts() async {
    final db = await database;
    final maps = await db.query(
      'receipts',
      where: 'isDeleted = 0',
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => Receipt.fromMap(map)).toList();
  }

  Future<List<Receipt>> getReceiptsByFinancialYear(
    String financialYearId,
  ) async {
    final db = await database;
    final maps = await db.query(
      'receipts',
      where: 'financialYearId = ? AND isDeleted = 0',
      whereArgs: [financialYearId],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => Receipt.fromMap(map)).toList();
  }

  Future<double> getTotalPotentialSavings() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(potentialTaxSaving) as total FROM receipts WHERE isDeleted = 0',
    );

    return (result.first['total'] as double?) ?? 0.0;
  }

  Future<int> getReceiptCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM receipts WHERE isDeleted = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> deleteReceipt(String id) async {
    final db = await database;
    return await db.delete('receipts', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> softDeleteReceipt(String id) async {
    final db = await database;
    return await db.update(
      'receipts',
      {'isDeleted': 1, 'updatedAt': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> restoreReceipt(String id) async {
    final db = await database;
    return await db.update(
      'receipts',
      {'isDeleted': 0, 'updatedAt': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
