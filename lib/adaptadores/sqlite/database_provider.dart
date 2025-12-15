import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
      // Obtener la carpeta Documents del usuario actual (automáticamente por usuario)
      final documentsDir = await getApplicationDocumentsDirectory();
      final dbPath = join(documentsDir.path, 'proyecto912.db');

      print('📂 Database path: $dbPath');
      print('📂 Database exists: ${await File(dbPath).exists()}');

      // Si la BD no existe, copiarla desde assets (plantilla inicial)
      if (!await File(dbPath).exists()) {
        try {
          print('📋 Copying database from assets (first time)...');
          final data = await rootBundle.load('assets/db/proyecto912.db');
          final bytes = data.buffer.asUint8List(
            data.offsetInBytes,
            data.lengthInBytes,
          );
          print('📋 Database file size: ${bytes.length} bytes');

          await File(dbPath).writeAsBytes(bytes);
          print('✓ Database copied from assets to: $dbPath');
        } catch (e) {
          print('⚠ Error copying database from assets: $e');
          print('⚠ Creating new database with tables...');
          // Continuar sin la BD de assets, crearemos tablas en onCreate
        }
      } else {
        print('✓ Database already exists at: $dbPath');
      }

      _database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: (db, oldVersion, newVersion) async {
          print('⚠ Database upgrade from v$oldVersion to v$newVersion');
        },
      );

      // Verificar y actualizar las tablas siempre (agregar columnas faltantes)
      await _verificarYCrearTablas(_database!);

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
    await _crearTablasYDatos(db);
  }

  Future<void> _verificarYCrearTablas(Database db) async {
    try {
      // Verificar si rutinas existe
      final tablas = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='rutinas'",
      );

      if (tablas.isEmpty) {
        print('⚠ Tables not found, creating them...');
        await _crearTablasYDatos(db);
      } else {
        print('✓ Tables already exist');
      }

      // SIEMPRE verificar y agregar columnas faltantes a registros_imc
      // (puede ser que la BD vieja no tenga las columnas nuevas)
      await _verificarYAgregarColumnasRegistrosIMC(db);
      
      // SIEMPRE verificar y agregar la columna foto_perfil a usuarios
      await _verificarYAgregarColumnasUsuarios(db);
    } catch (e) {
      print('⚠ Error verifying tables: $e');
    }
  }

  Future<void> _verificarYAgregarColumnasRegistrosIMC(Database db) async {
    try {
      print('🔍 Verificando estructura de registros_imc...');
      // Obtener la información de las columnas de registros_imc
      final columnas = await db.rawQuery("PRAGMA table_info(registros_imc)");
      final columnNames = columnas.map((col) => col['name'] as String).toList();
      print('📋 Columnas actuales en registros_imc: $columnNames');

      // Verificar si usuario_id existe
      if (!columnNames.contains('usuario_id')) {
        print('⚠ Columna usuario_id no existe en registros_imc, agregando...');
        try {
          await db.execute(
            'ALTER TABLE registros_imc ADD COLUMN usuario_id TEXT DEFAULT "unknown"',
          );
          print('✓ Columna usuario_id agregada a registros_imc');
        } catch (e) {
          print('⚠ Error agregando usuario_id: $e');
        }
      } else {
        print('✓ Columna usuario_id ya existe');
      }

      // Verificar si fecha existe
      if (!columnNames.contains('fecha')) {
        print('⚠ Columna fecha no existe en registros_imc, agregando...');
        try {
          await db.execute('ALTER TABLE registros_imc ADD COLUMN fecha TEXT');
          print('✓ Columna fecha agregada a registros_imc');
        } catch (e) {
          print('⚠ Error agregando fecha: $e');
        }
      } else {
        print('✓ Columna fecha ya existe');
      }
    } catch (e) {
      print('⚠ Error verificando columnas de registros_imc: $e');
    }
  }

  Future<void> _verificarYAgregarColumnasUsuarios(Database db) async {
    try {
      print('🔍 Verificando estructura de usuarios...');
      // Obtener la información de las columnas de usuarios
      final columnas = await db.rawQuery("PRAGMA table_info(usuarios)");
      final columnNames = columnas.map((col) => col['name'] as String).toList();
      print('📋 Columnas actuales en usuarios: $columnNames');

      // Verificar si foto_perfil existe
      if (!columnNames.contains('foto_perfil')) {
        print('⚠ Columna foto_perfil no existe en usuarios, agregando...');
        try {
          await db.execute(
            'ALTER TABLE usuarios ADD COLUMN foto_perfil TEXT',
          );
          print('✓ Columna foto_perfil agregada a usuarios');
        } catch (e) {
          print('⚠ Error agregando foto_perfil: $e');
        }
      } else {
        print('✓ Columna foto_perfil ya existe');
      }
    } catch (e) {
      print('⚠ Error verificando columnas de usuarios: $e');
    }
  }

  Future<void> _crearTablasYDatos(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS usuarios (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        edad INTEGER NOT NULL,
        peso REAL NOT NULL,
        altura REAL NOT NULL,
        foto_perfil TEXT
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
        usuario_id TEXT NOT NULL,
        imc REAL NOT NULL,
        categoria TEXT NOT NULL,
        fecha TEXT NOT NULL
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

    // Insertar datos de prueba solo si están vacíos
    await _insertarDatosPrueba(db);
  }

  Future<void> _insertarDatosPrueba(Database db) async {
    try {
      print('📝 Insertando datos de prueba...');

      // Insertar rutinas
      await db.insert('rutinas', {
        'id': 'r1',
        'nombre': 'Rutina Alimenticia Básica',
        'descripcion': 'Plan de comidas saludables para 7 días',
        'favorito': 0,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      // Insertar ejercicios para rutina 1
      final ejercicios = [
        'Día 1: Desayuno - Avena, Almuerzo - Pollo y arroz, Cena - Ensalada',
        'Día 2: Desayuno - Yogur y frutas, Almuerzo - Pescado y verduras, Cena - Sopa de verduras',
        'Día 3: Desayuno - Tostadas integrales, Almuerzo - Carne magra y puré, Cena - Omelette de verduras',
      ];
      for (var ejercicio in ejercicios) {
        await db.insert('rutinas_ejercicios', {
          'rutina_id': 'r1',
          'ejercicio': ejercicio,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      // Insertar recetas
      await db.insert('recetas', {
        'id': 'rec1',
        'titulo': 'Ensalada Mediterránea',
        'descripcion': 'Ensalada fresca con vegetales del Mediterráneo',
        'cultura': 'Mediterránea',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      // Insertar ingredientes
      await db.insert('ingredientes', {
        'id': 'ing1',
        'nombre': 'Lechuga',
        'cantidad': '1 taza',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      await db.insert('ingredientes', {
        'id': 'ing2',
        'nombre': 'Tomate',
        'cantidad': '2 unidades',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      // Relacionar receta con ingredientes
      await db.insert('receta_ingredientes', {
        'receta_id': 'rec1',
        'ingrediente_id': 'ing1',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      await db.insert('receta_ingredientes', {
        'receta_id': 'rec1',
        'ingrediente_id': 'ing2',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      print('✅ Datos de prueba insertados correctamente');
    } catch (e) {
      print('⚠️ Error insertando datos de prueba: $e');
    }
  }
}
