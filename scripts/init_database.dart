import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dbPath = 'assets/db/proyecto912.db';
  final dbFile = File(dbPath);
  
  // Crear el directorio si no existe
  dbFile.parent.createSync(recursive: true);
  
  // Si existe, simplemente abrirlo y verificar que tenga datos
  // Si no, crearlo nuevo
  
  final db = await openDatabase(
    dbPath,
    version: 1,
  );

  // Crear tablas
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

  // Insertar datos de prueba solo si la tabla rutinas está vacía
  final result = await db.query('rutinas');
  if (result.isEmpty) {
    print('Insertando datos de prueba...');
    
    await db.insert('rutinas', {
      'id': 'r1',
      'nombre': 'Rutina Alimenticia Básica',
      'descripcion': 'Plan de comidas saludables para 7 días',
      'favorito': 0,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

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

    await db.insert('recetas', {
      'id': 'rec1',
      'titulo': 'Ensalada Mediterránea',
      'descripcion': 'Ensalada fresca con vegetales del Mediterráneo',
      'cultura': 'Mediterránea',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

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

    await db.insert('receta_ingredientes', {
      'receta_id': 'rec1',
      'ingrediente_id': 'ing1',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    await db.insert('receta_ingredientes', {
      'receta_id': 'rec1',
      'ingrediente_id': 'ing2',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    
    print('✅ Datos insertados');
  } else {
    print('✅ La base de datos ya tiene datos');
  }

  await db.close();
  print('✅ Database initialized successfully at $dbPath');
}
