import 'package:proyecto/adaptadores/sqlite/database_provider.dart';
import 'package:proyecto/dominio/entidades/dieta.dart';
import 'package:proyecto/dominio/entidades/ingrediente.dart';
import 'package:proyecto/dominio/repositorios/repositorio_de_dietas.dart';

class RepositorioDeDietasSQLite implements RepositorioDeDietas {
  RepositorioDeDietasSQLite({DatabaseProvider? provider})
      : _provider = provider ?? DatabaseProvider.instance;

  final DatabaseProvider _provider;

  @override
  List<Dieta> dietasConIngredientes(List<Ingrediente> ingredientes) {
    final db = _provider.database;
    final dietasRows = db.select(
      'SELECT id, nombre FROM dietas',
    );

    final dietas = dietasRows
        .map(
          (row) => Dieta(
            id: row['id'] as String,
            nombre: row['nombre'] as String,
            recetasIds: _recetasDeDieta(row['id'] as String),
            ingredientes: _ingredientesDeDieta(row['id'] as String),
          ),
        )
        .toList();

    if (ingredientes.isEmpty) {
      return dietas;
    }

    final buscados = ingredientes.map((i) => i.nombre.toLowerCase()).toList();
    return dietas.where((dieta) {
      final nombres = dieta.ingredientes.map((i) => i.nombre.toLowerCase()).toList();
      return buscados.every(nombres.contains);
    }).toList();
  }

  List<String> _recetasDeDieta(String dietaId) {
    final db = _provider.database;
    final rows = db.select(
      'SELECT receta_id FROM dieta_recetas WHERE dieta_id = ?',
      [dietaId],
    );

    return rows.map((row) => row['receta_id'] as String).toList();
  }

  List<Ingrediente> _ingredientesDeDieta(String dietaId) {
    final db = _provider.database;
    final rows = db.select(
      '''
      SELECT i.id, i.nombre, di.cantidad
      FROM dieta_ingredientes di
      INNER JOIN ingredientes i ON i.id = di.ingrediente_id
      WHERE di.dieta_id = ?
      ''',
      [dietaId],
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
