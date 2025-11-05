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

    final usuarios = repositorio.obtenerUsuarios();
    final existeUsuario =
        usuarios.any((usuarioExistente) => usuarioExistente.id == usuario.id);
    if (!existeUsuario) {
      throw StateError('Usuario con id \'${usuario.id}\' no encontrado');
    }

    final emailDuplicado = usuarios.any((usuarioExistente) =>
        usuarioExistente.id != usuario.id &&
        usuarioExistente.email.toLowerCase() == usuario.email.toLowerCase());
    if (emailDuplicado) {
      throw StateError('Ya existe un usuario con ese email');
    }

    repositorio.actualizarUsuario(usuario);
  }
}
