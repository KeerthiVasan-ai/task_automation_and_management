import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../feature_github_repo/models/repository.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._internal();
  Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'management_automation.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE Transactions (
          TransID INTEGER PRIMARY KEY AUTOINCREMENT,
          TransDesc TEXT,
          TransStatus TEXT,
          TransDateTime TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE Repositories (
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          stars INTEGER,
          ownerUsername TEXT,
          ownerAvatarUrl TEXT
        )
        ''');
      },
    );
  }

  Future<void> insertSampleData() async {
    final db = await database;
    await db.insert('Transactions', {
      'TransDesc': 'UpdateTask',
      'TransStatus': 'Error',
      'TransDateTime': DateTime.now().toString(),
    });
  }

  Future<List<Map<String, dynamic>>> getErrorRecords() async {
    final db = await database;
    return await db.query(
      'Transactions',
      where: 'TransStatus = ?',
      whereArgs: ['Error'],
    );
  }

  Future<void> insertRepository(Repository repository) async {
    final db = await database;
    await db.insert(
      'Repositories',
      repository.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Repository>> getRepositories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Repositories');

    return List.generate(maps.length, (i) {
      return Repository.fromMap(maps[i]);
    });
  }
}
