import 'package:proyecto/adaptadores/sqlite/database_provider.dart';
import 'package:proyecto/dominio/entidades/usuario.dart';
import 'package:proyecto/dominio/repositorios/repositorio_de_usuario.dart';

class RepositorioDeUsuarioSQLite implements RepositorioDeUsuario {
  RepositorioDeUsuarioSQLite({DatabaseProvider? provider})
      : _provider = provider ?? DatabaseProvider.instance;

  final DatabaseProvider _provider;

  @override
  List<Usuario> obtenerUsuarios() {
    final db = _provider.database;
    final result = db.select(
      'SELECT id, nombre, email, password, edad, peso, altura FROM usuarios',
    );

    return result
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
  void agregarUsuario(Usuario usuario) {
    final db = _provider.database;
    db.execute(
      'INSERT INTO usuarios (id, nombre, email, password, edad, peso, altura) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        usuario.id,
        usuario.nombre,
        usuario.email,
        usuario.password,
        usuario.edad,
        usuario.peso,
        usuario.altura,
      ],
    );
  }

  @override
  void actualizarUsuario(Usuario usuario) {
    final db = _provider.database;
    db.execute(
      'UPDATE usuarios SET nombre = ?, email = ?, password = ?, edad = ?, peso = ?, altura = ? WHERE id = ?',
      [
        usuario.nombre,
        usuario.email,
        usuario.password,
        usuario.edad,
        usuario.peso,
        usuario.altura,
        usuario.id,
      ],
    );
  }
}
