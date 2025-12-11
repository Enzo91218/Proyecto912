import '../entidades/usuario.dart';

abstract class RepositorioDeUsuario {
  Future<List<Usuario>> obtenerUsuarios();
  Future<void> agregarUsuario(Usuario usuario);
  Future<void> actualizarUsuario(Usuario usuario);
}
