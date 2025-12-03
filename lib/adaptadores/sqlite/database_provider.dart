import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

class DatabaseProvider {
  DatabaseProvider._internal();

  static final DatabaseProvider instance = DatabaseProvider._internal();
  Database? _database;

  Database get database {
    _database ??= _openDatabase();
    return _database!;
  }

  Database _openDatabase() {
    final dbPath = p.join(Directory.systemTemp.path, 'proyecto912.db');
    final db = sqlite3.open(dbPath);
    _createTables(db);
    return db;
  }

  void _createTables(Database db) {
    db.execute('''
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

    db.execute('''
      CREATE TABLE IF NOT EXISTS ingredientes (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        cantidad TEXT NOT NULL
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS recetas (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        descripcion TEXT NOT NULL
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS receta_ingredientes (
        receta_id TEXT NOT NULL,
        ingrediente_id TEXT NOT NULL,
        cantidad TEXT NOT NULL,
        PRIMARY KEY (receta_id, ingrediente_id),
        FOREIGN KEY (receta_id) REFERENCES recetas(id) ON DELETE CASCADE,
        FOREIGN KEY (ingrediente_id) REFERENCES ingredientes(id) ON DELETE CASCADE
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS dietas (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS dieta_recetas (
        dieta_id TEXT NOT NULL,
        receta_id TEXT NOT NULL,
        PRIMARY KEY (dieta_id, receta_id),
        FOREIGN KEY (dieta_id) REFERENCES dietas(id) ON DELETE CASCADE,
        FOREIGN KEY (receta_id) REFERENCES recetas(id) ON DELETE CASCADE
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS dieta_ingredientes (
        dieta_id TEXT NOT NULL,
        ingrediente_id TEXT NOT NULL,
        cantidad TEXT NOT NULL,
        PRIMARY KEY (dieta_id, ingrediente_id),
        FOREIGN KEY (dieta_id) REFERENCES dietas(id) ON DELETE CASCADE,
        FOREIGN KEY (ingrediente_id) REFERENCES ingredientes(id) ON DELETE CASCADE
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS registro_peso_altura (
        id TEXT PRIMARY KEY,
        usuario_id TEXT NOT NULL,
        peso REAL NOT NULL,
        altura REAL NOT NULL,
        fecha TEXT NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS registro_imc (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imc REAL NOT NULL,
        categoria TEXT NOT NULL,
        usuario_id TEXT,
        fecha TEXT DEFAULT (datetime('now')),
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
      );
    ''');
  }
}
