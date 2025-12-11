import 'package:sqflite/sqflite.dart';

import '../../dominio/entidades/usuario.dart';
import '../../dominio/repositorios/repositorio_de_usuario.dart';
import 'database_provider.dart';

class RepositorioDeUsuarioSqlite implements RepositorioDeUsuario {
  final DatabaseProvider _provider;

  RepositorioDeUsuarioSqlite(this._provider);

  @override
  Future<List<Usuario>> obtenerUsuarios() async {
    final db = await _provider.database;
    final data = await db.query('usuarios');
    return data
        .map(
          (row) => Usuario(
            id: row['id'] as String,
            nombre: row['nombre'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            edad: row['edad'] as int,
            peso: (row['peso'] as num).toDouble(),
            altura: (row['altura'] as num).toDouble(),
          ),
        )
        .toList();
  }

  @override
  Future<void> agregarUsuario(Usuario usuario) async {
    final db = await _provider.database;
    await db.insert(
      'usuarios',
      {
        'id': usuario.id,
        'nombre': usuario.nombre,
        'email': usuario.email,
        'password': usuario.password,
        'edad': usuario.edad,
        'peso': usuario.peso,
        'altura': usuario.altura,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> actualizarUsuario(Usuario usuario) async {
    final db = await _provider.database;
    await db.update(
      'usuarios',
      {
        'nombre': usuario.nombre,
        'email': usuario.email,
        'password': usuario.password,
        'edad': usuario.edad,
        'peso': usuario.peso,
        'altura': usuario.altura,
      },
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }
}
