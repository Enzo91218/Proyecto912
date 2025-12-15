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
      print('🔍 Consultando tabla rutina_alimenticia...');
      final rutinasList = await db.query('rutina_alimenticia');
      print('📊 Rutinas encontradas: ${rutinasList.length}');

      if (rutinasList.isEmpty) {
        print('⚠️ La tabla rutina_alimenticia está vacía');
        return [];
      }

      final rutinas = <Rutina>[];
      for (var rutina in rutinasList) {
        print(
          '🍽️ Procesando rutina: ${rutina['nombre']} (ID: ${rutina['id']})',
        );

        final alimentosQuery = await db.query(
          'rutina_alimenticia_alimentos',
          where: 'rutina_alimenticia_id = ?',
          whereArgs: [rutina['id']],
          orderBy: 'dia, horario',
        );

        print('   → Alimentos encontrados: ${alimentosQuery.length}');

        final alimentos =
            alimentosQuery
                .map(
                  (a) => Alimento(
                    dia: (a['dia'] as int?) ?? 1,
                    horario: (a['horario'] as String?) ?? '00:00',
                    alimento: (a['alimento'] as String?) ?? '',
                    cantidad: (a['cantidad'] as String?) ?? '',
                    completada: ((a['completada'] as int?) ?? 0) == 1,
                  ),
                )
                .toList();

        rutinas.add(
          Rutina(
            id: (rutina['id'] as int?)?.toString() ?? '',
            nombre: rutina['nombre'] as String? ?? '',
            descripcion: rutina['descripcion'] as String? ?? '',
            alimentos: alimentos,
            favorito: false,
          ),
        );
      }

      print('✅ Total de rutinas cargadas: ${rutinas.length}');
      return rutinas;
    } catch (e) {
      print('❌ Error obteniendo rutinas: $e');
      print('📍 Stack trace: ${StackTrace.current}');
      return [];
    }
  }

  Future<void> agregarRutina(Rutina rutina) async {
    final db = await _provider.database;

    // Insertar rutina
    await db.insert('rutina_alimenticia', {
      'id': int.tryParse(rutina.id) ?? 0,
      'nombre': rutina.nombre,
      'descripcion': rutina.descripcion,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // Insertar alimentos
    for (var alimento in rutina.alimentos) {
      await db.insert(
        'rutina_alimenticia_alimentos',
        {
          'rutina_alimenticia_id': int.tryParse(rutina.id) ?? 0,
          'dia': alimento.dia,
          'horario': alimento.horario,
          'alimento': alimento.alimento,
          'cantidad': alimento.cantidad,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    _provider.recordDatabaseUpdate();
  }

  Future<void> actualizarRutina(Rutina rutina) async {
    final db = await _provider.database;

    // Actualizar rutina
    await db.update(
      'rutina_alimenticia',
      {'nombre': rutina.nombre, 'descripcion': rutina.descripcion},
      where: 'id = ?',
      whereArgs: [int.tryParse(rutina.id) ?? 0],
    );

    // Eliminar alimentos viejos
    await db.delete(
      'rutina_alimenticia_alimentos',
      where: 'rutina_alimenticia_id = ?',
      whereArgs: [int.tryParse(rutina.id) ?? 0],
    );

    // Insertar alimentos nuevos
    for (var alimento in rutina.alimentos) {
      await db.insert('rutina_alimenticia_alimentos', {
        'rutina_alimenticia_id': int.tryParse(rutina.id) ?? 0,
        'dia': alimento.dia,
        'horario': alimento.horario,
        'alimento': alimento.alimento,
        'cantidad': alimento.cantidad,
      });
    }

    _provider.recordDatabaseUpdate();
  }

  Future<void> eliminarRutina(String id) async {
    final db = await _provider.database;

    // Eliminar alimentos asociados (cascada)
    await db.delete(
      'rutina_alimenticia_alimentos',
      where: 'rutina_alimenticia_id = ?',
      whereArgs: [int.tryParse(id) ?? 0],
    );

    // Eliminar rutina
    await db.delete(
      'rutina_alimenticia',
      where: 'id = ?',
      whereArgs: [int.tryParse(id) ?? 0],
    );

    _provider.recordDatabaseUpdate();
  }

  @override
  Future<void> marcarDiaCompletado(String rutinaId, int dia, bool completada) async {
    try {
      final db = await _provider.database;
      print('📝 Marcando día $dia de rutina $rutinaId como completada: $completada');
      
      await db.update(
        'rutina_alimenticia_alimentos',
        {'completada': completada ? 1 : 0},
        where: 'rutina_alimenticia_id = ? AND dia = ?',
        whereArgs: [int.tryParse(rutinaId) ?? 0, dia],
      );
      
      _provider.recordDatabaseUpdate();
      print('✅ Día marcado correctamente');
    } catch (e) {
      print('❌ Error marcando día: $e');
      rethrow;
    }
  }
}
