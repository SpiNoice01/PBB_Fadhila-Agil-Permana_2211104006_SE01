import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE my_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        nim TEXT,
        kelas TEXT
      )
    ''');
  }

  Future<void> insert(String nama, String nim, String kelas) async {
    final db = await database;
    await db.insert(
      'my_table',
      {'nama': nama, 'nim': nim, 'kelas': kelas},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await database;
    return await db.query('my_table');
  }

  Future<void> deleteDatabaseFile() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    if (await databaseExists(path)) {
      await deleteDatabase(path);
    }
  }
}
