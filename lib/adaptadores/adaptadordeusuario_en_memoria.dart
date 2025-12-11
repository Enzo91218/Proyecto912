import '../dominio/entidades/usuario.dart';
import '../dominio/repositorios/repositorio_de_usuario.dart';

class RepositorioDeUsuarioA implements RepositorioDeUsuario {
  final List<Usuario> _usuarios = [
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
    Usuario(
      id: '3',
      nombre: 'Luis',
      email: 'luis@mail.com',
      password: 'pass',
      edad: 45,
      peso: 85.0,
      altura: 1.8,
    ),
    Usuario(
      id: '4',
      nombre: 'Marta',
      email: 'marta@mail.com',
      password: 'marta123',
      edad: 35,
      peso: 68.0,
      altura: 1.68,
    ),
  ];

  @override
  @override
  Future<List<Usuario>> obtenerUsuarios() async => List.unmodifiable(_usuarios);

  @override
  @override
  Future<void> agregarUsuario(Usuario usuario) async {
    _usuarios.add(usuario);
  }

  @override
  Future<void> actualizarUsuario(Usuario usuario) async {
    final index = _usuarios.indexWhere((u) => u.id == usuario.id);
    if (index != -1) {
      _usuarios[index] = usuario;
    }
  }
}
