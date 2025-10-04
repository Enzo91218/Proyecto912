import '../dominio/entidades/usuario.dart';
import '../dominio/repositorios/repositorio_de_usuario.dart';

class RepositorioDeUsuarioA implements RepositorioDeUsuario {
  @override
  List<Usuario> obtenerUsuarios() {
    // aca empiezan los ejemplos
    return [
      Usuario(
        id: '1',
        nombre: 'Juan',
        email: 'juan@mail.com',
        password: '1234',
        edad: 30,
        peso: 75.0,
        altura: 1.75,
      ),
      Usuario(
        id: '2',
        nombre: 'Ana',
        email: 'ana@mail.com',
        password: 'abcd',
        edad: 28,
        peso: 62.0,
        altura: 1.65,
      ),
    ];
  }
}
