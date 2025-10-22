import '../entidades/usuario.dart';

abstract class RepositorioDeUsuario {
  List<Usuario> obtenerUsuarios();
  void agregarUsuario(Usuario usuario);
}
