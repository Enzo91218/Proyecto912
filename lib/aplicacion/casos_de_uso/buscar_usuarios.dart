import '../../dominio/repositorios/repositorio_de_usuario.dart';
import '../../dominio/entidades/usuario.dart';

class BuscarUsuarios {
  final RepositorioDeUsuario repositorio;
  BuscarUsuarios(this.repositorio);

  List<Usuario> call() {
    return repositorio.obtenerUsuarios();
  }
}
