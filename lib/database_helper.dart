import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'proyectoi912.db';
  static const String _assetPath = 'assets/db/proyectoi912.db';

  /// Obtiene la instancia del Database.
  /// Si la base de datos no existe, la copia desde assets y la abre.
  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Inicializa la base de datos.
  /// Copia el archivo desde assets si es la primera vez que corre la app.
  static Future<Database> _initDatabase() async {
    // Obtener la ruta de la carpeta de documentos de la app
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final databasePath = '${documentsDirectory.path}/$_databaseName';
    final databaseFile = File(databasePath);

    // Si la base de datos no existe, copiarla desde assets
    if (!await databaseFile.exists()) {
      try {
        // Leer el archivo desde assets
        final data = await rootBundle.load(_assetPath);
        final bytes = data.buffer.asUint8List();

        // Crear el archivo en la carpeta de documentos
        await databaseFile.writeAsBytes(bytes, flush: true);
      } catch (e) {
        throw Exception('Error al copiar la base de datos desde assets: $e');
      }
    }

    // Abrir la base de datos
    return await openDatabase(databasePath, version: 1);
  }

  /// Cierra la base de datos.
  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// Ejecuta una consulta SELECT genérica y retorna los resultados.
  static Future<List<Map<String, dynamic>>> query(String table,
      {List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? orderBy,
      int? limit}) async {
    final db = await database;
    return await db.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  /// Ejecuta una consulta INSERT.
  static Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  /// Ejecuta una consulta UPDATE.
  static Future<int> update(String table, Map<String, dynamic> values,
      {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  /// Ejecuta una consulta DELETE.
  static Future<int> delete(String table,
      {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  /// Ejecuta una consulta SQL personalizada.
  static Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<Object?>? arguments]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }
}
