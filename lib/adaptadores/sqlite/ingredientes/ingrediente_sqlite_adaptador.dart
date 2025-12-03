import 'package:proyecto/adaptadores/sqlite/database_provider.dart';
import 'package:proyecto/dominio/entidades/ingrediente.dart';
import 'package:proyecto/dominio/repositorios/repositorio_de_ingredientes.dart';

class RepositorioDeIngredientesSQLite implements RepositorioDeIngredientes {
  RepositorioDeIngredientesSQLite({DatabaseProvider? provider})
      : _provider = provider ?? DatabaseProvider.instance;

  final DatabaseProvider _provider;

  @override
  List<Ingrediente> obtenerIngredientes() {
    final db = _provider.database;
    final result = db.select(
      'SELECT id, nombre, cantidad FROM ingredientes',
    );

    return result
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
