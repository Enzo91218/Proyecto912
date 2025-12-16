import '../../dominio/entidades/dieta.dart';
import '../../dominio/entidades/ingrediente.dart';
import '../../dominio/repositorios/repositorio_de_dietas.dart';
import 'database_provider.dart';
import 'recetas_sqlite_adaptador.dart';

class RepositorioDeDietasSqlite implements RepositorioDeDietas {
  final DatabaseProvider _provider;
  final RepositorioDeRecetasSqlite _recetasRepositorio;

  RepositorioDeDietasSqlite(this._provider, this._recetasRepositorio);

  @override
  Future<List<Dieta>> dietasConIngredientes(List<Ingrediente> ingredientes) async {
    final db = await _provider.database;
    final dietasData = await db.query('dietas');

    final dietas = <Dieta>[];
    for (final dieta in dietasData) {
      final dietaId = dieta['id'] as String;
      final recetasRelacionadas = await db.query(
        'dieta_recetas',
        where: 'dieta_id = ?',
        whereArgs: [dietaId],
      );
      final recetasIds = recetasRelacionadas.map((r) => r['receta_id'] as String).toList();
      final recetas = <Ingrediente>[];
      for (final recetaId in recetasIds) {
        final recetaRow = await db.query(
          'recetas',
          where: 'id = ?',
          whereArgs: [recetaId],
          limit: 1,
        );
        if (recetaRow.isNotEmpty) {
          final receta =
              await _recetasRepositorio.mapearReceta(recetaRow.first, db);
          recetas.addAll(receta.ingredientes);
        }
      }

      final ingredientesCoinciden = ingredientes.isEmpty
          ? true
          : ingredientes
              .map((i) => i.nombre.toLowerCase())
              .every((nombre) => recetas.map((ing) => ing.nombre.toLowerCase()).contains(nombre));

      if (ingredientesCoinciden) {
        dietas.add(
          Dieta(
            id: dietaId,
            nombre: dieta['nombre'] as String,
            recetasIds: recetasIds,
            ingredientes: recetas,
          ),
        );
      }
    }

    return dietas;
  }

  @override
  Future<List<Dieta>> obtenerTodasLasDietas() async {
    final db = await _provider.database;
    final dietasData = await db.query('dietas');

    final dietas = <Dieta>[];
    for (final dieta in dietasData) {
      final dietaId = dieta['id'] as String;
      final recetasRelacionadas = await db.query(
        'dieta_recetas',
        where: 'dieta_id = ?',
        whereArgs: [dietaId],
      );
      final recetasIds = recetasRelacionadas.map((r) => r['receta_id'] as String).toList();
      final recetas = <Ingrediente>[];
      for (final recetaId in recetasIds) {
        final recetaRow = await db.query(
          'recetas',
          where: 'id = ?',
          whereArgs: [recetaId],
          limit: 1,
        );
        if (recetaRow.isNotEmpty) {
          final receta = await _recetasRepositorio.mapearReceta(recetaRow.first, db);
          recetas.addAll(receta.ingredientes);
        }
      }

      dietas.add(
        Dieta(
          id: dietaId,
          nombre: dieta['nombre'] as String,
          recetasIds: recetasIds,
          ingredientes: recetas,
        ),
      );
    }

    return dietas;
  }
}
