import 'package:sqflite/sqflite.dart';

import '../../dominio/entidades/rutina.dart';
import '../../dominio/repositorios/repositorio_de_rutinas.dart';
import 'database_provider.dart';

class RepositorioDeRutinasSqlite implements RepositorioDeRutinas {
  final DatabaseProvider _provider;

  RepositorioDeRutinasSqlite(this._provider);

  @override
  Future<List<Rutina>> obtenerRutinas() async {
    try {
      final db = await _provider.database;
      final rutinasList = await db.query('rutinas');

      final rutinas = <Rutina>[];
      for (var rutina in rutinasList) {
        final ejercicios = await db.query(
          'rutinas_ejercicios',
          where: 'rutina_id = ?',
          whereArgs: [rutina['id']],
        );

        rutinas.add(
          Rutina(
            id: rutina['id'] as String? ?? '',
            nombre: rutina['nombre'] as String? ?? '',
            descripcion: rutina['descripcion'] as String? ?? '',
            ejercicios: ejercicios
                .map((e) => (e['ejercicio'] as String?) ?? '')
                .where((e) => e.isNotEmpty)
                .toList(),
            favorito: ((rutina['favorito'] as int?) ?? 0) == 1,
          ),
        );
      }
      return rutinas;
    } catch (e) {
      print('Error obteniendo rutinas: $e');
      return [];
    }
  }

  Future<void> agregarRutina(Rutina rutina) async {
    final db = await _provider.database;

    // Insertar rutina
    await db.insert('rutinas', {
      'id': rutina.id,
      'nombre': rutina.nombre,
      'descripcion': rutina.descripcion,
      'favorito': rutina.favorito ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // Insertar ejercicios
    for (var ejercicio in rutina.ejercicios) {
      await db.insert('rutinas_ejercicios', {
        'rutina_id': rutina.id,
        'ejercicio': ejercicio,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    _provider.recordDatabaseUpdate();
  }

  Future<void> actualizarRutina(Rutina rutina) async {
    final db = await _provider.database;

    // Actualizar rutina
    await db.update(
      'rutinas',
      {
        'nombre': rutina.nombre,
        'descripcion': rutina.descripcion,
        'favorito': rutina.favorito ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [rutina.id],
    );

    // Eliminar ejercicios viejos
    await db.delete(
      'rutinas_ejercicios',
      where: 'rutina_id = ?',
      whereArgs: [rutina.id],
    );

    // Insertar ejercicios nuevos
    for (var ejercicio in rutina.ejercicios) {
      await db.insert('rutinas_ejercicios', {
        'rutina_id': rutina.id,
        'ejercicio': ejercicio,
      });
    }

    _provider.recordDatabaseUpdate();
  }

  Future<void> eliminarRutina(String id) async {
    final db = await _provider.database;

    // Eliminar ejercicios asociados (cascada)
    await db.delete(
      'rutinas_ejercicios',
      where: 'rutina_id = ?',
      whereArgs: [id],
    );

    // Eliminar rutina
    await db.delete('rutinas', where: 'id = ?', whereArgs: [id]);

    _provider.recordDatabaseUpdate();
  }
}
