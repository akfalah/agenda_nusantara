import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import 'package:agenda_nusantara/models/task.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agenda_nusantara.db');

    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
        CREATE TABLE tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          due_date TEXT,
          category TEXT NOT NULL,
          is_done INTEGER DEFAULT 0,
          created_at TEXT
        )
      ''');
  }

  // CRUD
  static Future<int> insert(Task task) async {
    final db = await database;

    return await db.insert('tasks', task.toMap());
  }

  static Future<List<Task>> getAll() async {
    final db = await database;
    final rows = await db.query('tasks', orderBy: 'due_date ASC');

    return rows.map(Task.fromMap).toList();
  }

  static Future<void> toggleDone(int id, int newStatus) async {
    final db = await database;

    await db.update(
      'tasks',
      {'is_done': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Stats
  static Future<int> countDone() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM tasks WHERE is_done = 1',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<int> countPending() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM tasks WHERE is_done = 0',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Chart
  static Future<Map<String, int>> getDailyCompletionStats() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT created_at, COUNT(*) AS total
      FROM tasks
      WHERE is_done = 1
      GROUP BY created_at
      ORDER BY created_at ASC
    ''');

    final Map<String, int> result = {};
    for (final row in rows) {
      result[row['created_at'] as String] = row['total'] as int;
    }
    return result;
  }
}
