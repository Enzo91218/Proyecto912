import 'package:proyecto/adaptadores/sqlite/database_provider.dart';
import 'package:proyecto/dominio/entidades/registro_peso_altura_entidad.dart';
import 'package:proyecto/dominio/repositorios/repositorio_de_registro_peso_altura.dart';

class RepositorioDeRegistroPesoAlturaSQLite
    implements RepositorioDeRegistroPesoAltura {
  RepositorioDeRegistroPesoAlturaSQLite({DatabaseProvider? provider})
      : _provider = provider ?? DatabaseProvider.instance;

  final DatabaseProvider _provider;

  @override
  List<RegistroPesoAltura> obtenerRegistros(String usuarioId) {
    final db = _provider.database;
    final rows = db.select(
      '''
      SELECT id, usuario_id, peso, altura, fecha
      FROM registro_peso_altura
      WHERE usuario_id = ?
      ORDER BY fecha ASC
      ''',
      [usuarioId],
    );

    return rows
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

  @override
  void agregarRegistro(RegistroPesoAltura registro) {
    final db = _provider.database;
    db.execute(
      'INSERT INTO registro_peso_altura (id, usuario_id, peso, altura, fecha) VALUES (?, ?, ?, ?, ?)',
      [
        registro.id,
        registro.usuarioId,
        registro.peso,
        registro.altura,
        registro.fecha.toIso8601String(),
      ],
    );
  }
}
