import 'package:proyecto/adaptadores/sqlite/database_provider.dart';
import 'package:proyecto/dominio/entidades/ingrediente.dart';
import 'package:proyecto/dominio/entidades/receta.dart';
import 'package:proyecto/dominio/repositorios/repositorio_de_recetas.dart';

class RepositorioDeRecetasSQLite implements RepositorioDeRecetas {
  RepositorioDeRecetasSQLite({DatabaseProvider? provider})
      : _provider = provider ?? DatabaseProvider.instance;

  final DatabaseProvider _provider;

  @override
  List<Receta> recetasConIngredientes(List<Ingrediente> ingredientes) {
    final db = _provider.database;
    final recetasRows = db.select(
      'SELECT id, titulo, descripcion FROM recetas',
    );

    final recetas = recetasRows
        .map(
          (row) => Receta(
            id: row['id'] as String,
            titulo: row['titulo'] as String,
            descripcion: row['descripcion'] as String,
            ingredientes: _ingredientesDeReceta(row['id'] as String),
          ),
        )
        .toList();

    if (ingredientes.isEmpty) {
      return recetas;
    }

    final buscados = ingredientes.map((i) => i.nombre.toLowerCase()).toList();
    return recetas.where((receta) {
      final nombres = receta.ingredientes.map((i) => i.nombre.toLowerCase()).toList();
      return buscados.every(nombres.contains);
    }).toList();
  }

  List<Ingrediente> _ingredientesDeReceta(String recetaId) {
    final db = _provider.database;
    final rows = db.select(
      '''
      SELECT i.id, i.nombre, ri.cantidad
      FROM receta_ingredientes ri
      INNER JOIN ingredientes i ON i.id = ri.ingrediente_id
      WHERE ri.receta_id = ?
      ''',
      [recetaId],
    );

    return rows
        .map(
          (row) => Ingrediente(
            id: row['id'] as String,
            nombre: row['nombre'] as String,
            cantidad: row['cantidad'] as String,
          ),
        )
        .toList();
  }
}
