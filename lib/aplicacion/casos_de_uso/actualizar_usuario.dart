import '../../dominio/entidades/usuario.dart';
import '../../dominio/repositorios/repositorio_de_usuario.dart';

class ActualizarUsuario {
  final RepositorioDeUsuario repositorio;
  ActualizarUsuario(this.repositorio);

  void call(Usuario usuario) {
    if (usuario.peso <= 0) {
      throw ArgumentError('El peso debe ser mayor a cero');
    }
    if (usuario.altura <= 0) {
      throw ArgumentError('La altura debe ser mayor a cero');
    }

    repositorio.actualizarUsuario(usuario);
  }
}
