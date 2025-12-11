import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._internal();
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  factory DatabaseProvider() => _instance;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final documentsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDir.path, 'proyecto912.db');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );

    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        edad INTEGER NOT NULL,
        peso REAL NOT NULL,
        altura REAL NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE recetas (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        cultura TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE ingredientes (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        cantidad TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE receta_ingredientes (
        receta_id TEXT NOT NULL,
        ingrediente_id TEXT NOT NULL,
        PRIMARY KEY (receta_id, ingrediente_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE dietas (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE dieta_recetas (
        dieta_id TEXT NOT NULL,
        receta_id TEXT NOT NULL,
        PRIMARY KEY (dieta_id, receta_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE registros_imc (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imc REAL NOT NULL,
        categoria TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE registros_peso_altura (
        id TEXT PRIMARY KEY,
        usuario_id TEXT NOT NULL,
        peso REAL NOT NULL,
        altura REAL NOT NULL,
        fecha TEXT NOT NULL
      );
    ''');
  }
}
