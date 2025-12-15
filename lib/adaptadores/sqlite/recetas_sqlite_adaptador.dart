import 'package:sqflite/sqflite.dart';

import '../../dominio/entidades/ingrediente.dart';
import '../../dominio/entidades/receta.dart';
import '../../dominio/repositorios/repositorio_de_recetas.dart';
import 'database_provider.dart';

class RepositorioDeRecetasSqlite implements RepositorioDeRecetas {
  final DatabaseProvider _provider;

  RepositorioDeRecetasSqlite(this._provider);

  @override
  Future<void> agregarReceta(Receta receta) async {
    final db = await _provider.database;
    await db.insert(
      'recetas',
      {
        'id': receta.id,
        'titulo': receta.titulo,
        'descripcion': receta.descripcion,
        'cultura': receta.cultura,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (final ingrediente in receta.ingredientes) {
      await db.insert(
        'ingredientes',
        {
          'id': ingrediente.id,
          'nombre': ingrediente.nombre,
          'cantidad': ingrediente.cantidad,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await db.insert(
        'receta_ingredientes',
        {
          'receta_id': receta.id,
          'ingrediente_id': ingrediente.id,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Future<Receta?> obtenerRecetaAleatoria() async {
    final db = await _provider.database;
    final recetas = await db.query('recetas');
    if (recetas.isEmpty) return null;
    
    // Crear una lista mutable antes de hacer shuffle
    final recetasMutables = List<Map<String, Object?>>.from(recetas);
    recetasMutables.shuffle();
    final seleccionada = recetasMutables.first;
    return mapearReceta(seleccionada, db);
  }

  @override
  Future<List<Receta>> recetasConIngredientes(List<Ingrediente> ingredientes) async {
    final db = await _provider.database;
    final recetasData = await db.query('recetas');

    final recetas = <Receta>[];
    for (final receta in recetasData) {
      final recetaConstruida = await mapearReceta(receta, db);
      if (ingredientes.isEmpty) {
        recetas.add(recetaConstruida);
        continue;
      }
      final nombresBuscados = ingredientes.map((i) => i.nombre.toLowerCase()).toList();
      final nombresReceta = recetaConstruida.ingredientes.map((i) => i.nombre.toLowerCase()).toList();
      final contieneTodos = nombresBuscados.every(nombresReceta.contains);
      if (contieneTodos) recetas.add(recetaConstruida);
    }
    return recetas;
  }

  @override
  Future<List<Receta>> recetasPorCultura(String cultura) async {
    final db = await _provider.database;
    final recetasData = await db.query(
      'recetas',
      where: 'LOWER(cultura) = ?',
      whereArgs: [cultura.toLowerCase()],
    );

    return Future.wait(recetasData.map((r) => mapearReceta(r, db)));
  }

  Future<Receta> mapearReceta(Map<String, Object?> data, Database db) async {
    final recetaId = data['id'] as String;
    final ingredientesData = await db.rawQuery('''
      SELECT i.id, i.nombre, i.cantidad FROM ingredientes i
      INNER JOIN receta_ingredientes ri ON ri.ingrediente_id = i.id
      WHERE ri.receta_id = ?
    ''', [recetaId]);

    final ingredientes = ingredientesData
        .map(
          (row) => Ingrediente(
            id: row['id'] as String,
            nombre: row['nombre'] as String,
            cantidad: row['cantidad'] as String,
          ),
        )
        .toList();

    return Receta(
      id: recetaId,
      titulo: data['titulo'] as String,
      descripcion: data['descripcion'] as String,
      ingredientes: ingredientes,
      cultura: data['cultura'] as String,
    );
  }

  @override
  Future<List<String>> obtenerCulturasUnicas() async {
    final db = await _provider.database;
    final result = await db.rawQuery(
      'SELECT DISTINCT cultura FROM recetas ORDER BY cultura ASC'
    );
    
    return result
        .map((row) => row['cultura'] as String)
        .toList();
  }
}
