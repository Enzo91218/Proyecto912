import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class DatabaseProvider {
  DatabaseProvider._internal();
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  factory DatabaseProvider() => _instance;

  Database? _database;
  DateTime? _lastUpdate;

  Future<Database> get database async {
    if (_database != null) return _database!;

    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final dbPath = join(documentsDir.path, 'proyecto912.db');

      // Si la base de datos no existe, copiarla desde assets
      if (!await File(dbPath).exists()) {
        try {
          final data = await rootBundle.load('assets/db/proyecto912.db');
          final bytes = data.buffer.asUint8List(
            data.offsetInBytes,
            data.lengthInBytes,
          );
          await File(dbPath).writeAsBytes(bytes);
          print('✓ Database copied from assets to: $dbPath');
        } catch (e) {
          print('⚠ Error copying database from assets: $e');
          // Continuar sin la BD de assets, crearemos tablas en onCreate
        }
      } else {
        print('✓ Database exists at: $dbPath');
      }

      _database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: (db, oldVersion, newVersion) async {
          // Si la versión cambia, ejecutar migraciones aquí
          print('⚠ Database upgrade from v$oldVersion to v$newVersion');
        },
      );

      _recordUpdate();
      print('✓ Database initialized successfully');
      return _database!;
    } catch (e) {
      print('✗ Error initializing database: $e');
      rethrow;
    }
  }

  /// Obtiene la ruta de la base de datos
  Future<String> getDatabasePath() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    return join(documentsDir.path, 'proyecto912.db');
  }

  /// Obtiene la fecha de la última actualización
  DateTime? get lastUpdate => _lastUpdate;

  /// Registra una actualización
  void _recordUpdate() {
    _lastUpdate = DateTime.now();
  }

  /// Notifica cuando la base de datos fue actualizada
  void recordDatabaseUpdate() {
    _recordUpdate();
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS usuarios (
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
      CREATE TABLE IF NOT EXISTS recetas (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        cultura TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ingredientes (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        cantidad TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS receta_ingredientes (
        receta_id TEXT NOT NULL,
        ingrediente_id TEXT NOT NULL,
        PRIMARY KEY (receta_id, ingrediente_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS dietas (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS dieta_recetas (
        dieta_id TEXT NOT NULL,
        receta_id TEXT NOT NULL,
        PRIMARY KEY (dieta_id, receta_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS registros_imc (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imc REAL NOT NULL,
        categoria TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS registros_peso_altura (
        id TEXT PRIMARY KEY,
        usuario_id TEXT NOT NULL,
        peso REAL NOT NULL,
        altura REAL NOT NULL,
        fecha TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS rutinas (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        favorito INTEGER NOT NULL DEFAULT 0
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS rutinas_ejercicios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rutina_id TEXT NOT NULL,
        ejercicio TEXT NOT NULL,
        FOREIGN KEY (rutina_id) REFERENCES rutinas(id) ON DELETE CASCADE
      );
    ''');
  }
}
