import '../../dominio/entidades/registro_peso_altura_entidad.dart';
import '../../dominio/repositorios/repositorio_de_registro_peso_altura.dart';
import 'database_provider.dart';

class RepositorioDeRegistroPesoAlturaSqlite
    implements RepositorioDeRegistroPesoAltura {
  final DatabaseProvider _provider;

  RepositorioDeRegistroPesoAlturaSqlite(this._provider);

  @override
  Future<void> agregarRegistro(RegistroPesoAltura registro) async {
    final db = await _provider.database;
    await db.insert(
      'registros_peso_altura',
      {
        'id': registro.id,
        'usuario_id': registro.usuarioId,
        'peso': registro.peso,
        'altura': registro.altura,
        'fecha': registro.fecha.toIso8601String(),
      },
    );
  }

  @override
  Future<List<RegistroPesoAltura>> obtenerRegistros(String usuarioId) async {
    final db = await _provider.database;
    final data = await db.query(
      'registros_peso_altura',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      orderBy: 'fecha ASC',
    );

    return data
        .map(
          (row) => RegistroPesoAltura(
            id: row['id'] as String,
            usuarioId: row['usuario_id'] as String,
            peso: (row['peso'] as num).toDouble(),
            altura: (row['altura'] as num).toDouble(),
            fecha: DateTime.parse(row['fecha'] as String),
          ),
        )
        .toList();
  }
}
