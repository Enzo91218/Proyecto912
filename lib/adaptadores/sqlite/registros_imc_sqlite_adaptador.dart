import '../../dominio/entidades/resultado_imc.dart';
import '../../dominio/repositorios/repositorio_de_registroIMC.dart';
import 'database_provider.dart';

class RepositorioDeRegistroIMCSqlite implements RepositorioDeRegistroIMC {
  final DatabaseProvider _provider;

  RepositorioDeRegistroIMCSqlite(this._provider);

  @override
  Future<List<ResultadoIMC>> obtenerRegistrosIMC() async {
    final db = await _provider.database;
    final data = await db.query('registros_imc', orderBy: 'id DESC');
    return data
        .map(
          (row) => ResultadoIMC(
            imc: (row['imc'] as num).toDouble(),
            categoria: row['categoria'] as String,
          ),
        )
        .toList();
  }
}
