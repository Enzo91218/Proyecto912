import '../../dominio/entidades/resultado_imc.dart';
import '../../dominio/repositorios/repositorio_de_registroIMC.dart';
import 'database_provider.dart';

class RepositorioDeRegistroIMCSqlite implements RepositorioDeRegistroIMC {
  final DatabaseProvider _provider;

  RepositorioDeRegistroIMCSqlite(this._provider);

  @override
  Future<void> guardarRegistroIMC(String usuarioId, double imc, String categoria) async {
    try {
      print('💾 SQL: Guardando IMC para usuario $usuarioId: $imc, categoría: $categoria');
      final db = await _provider.database;
      await db.insert('registros_imc', {
        'usuario_id': usuarioId,
        'imc': imc,
        'categoria': categoria,
        'fecha': DateTime.now().toIso8601String(),
      });
      print('✅ SQL: IMC guardado exitosamente');
      _provider.recordDatabaseUpdate();
    } catch (e) {
      print('❌ SQL: Error guardando IMC: $e');
      rethrow;
    }
  }

  @override
  Future<List<ResultadoIMC>> obtenerRegistros(String usuarioId) async {
    try {
      print('🔹 SQL: Obteniendo registros IMC para usuario: $usuarioId');
      final db = await _provider.database;
      final data = await db.query(
        'registros_imc',
        where: 'usuario_id = ?',
        whereArgs: [usuarioId],
        orderBy: 'id DESC',
      );
      print('🔹 SQL: Se encontraron ${data.length} registros IMC para el usuario');
      return data
          .map(
            (row) => ResultadoIMC(
              imc: (row['imc'] as num).toDouble(),
              categoria: row['categoria'] as String,
            ),
          )
          .toList();
    } catch (e) {
      print('❌ SQL: Error obteniendo IMC: $e');
      rethrow;
    }
  }
}
