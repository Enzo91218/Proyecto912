import 'package:proyecto/adaptadores/sqlite/database_provider.dart';
import 'package:proyecto/dominio/entidades/resultado_imc.dart';
import 'package:proyecto/dominio/repositorios/repositorio_de_registroIMC.dart';

class RepositorioDeRegistroIMCSQLite implements RepositorioDeRegistroIMC {
  RepositorioDeRegistroIMCSQLite({DatabaseProvider? provider})
      : _provider = provider ?? DatabaseProvider.instance;

  final DatabaseProvider _provider;

  @override
  List<ResultadoIMC> obtenerRegistrosIMC() {
    final db = _provider.database;
    final rows = db.select(
      'SELECT imc, categoria FROM registro_imc ORDER BY fecha ASC',
    );

    return rows
        .map(
          (row) => ResultadoIMC(
            imc: (row['imc'] as num).toDouble(),
            categoria: row['categoria'] as String,
          ),
        )
        .toList();
  }
}
