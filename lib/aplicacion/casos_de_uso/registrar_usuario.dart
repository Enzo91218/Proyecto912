import '../../dominio/entidades/usuario.dart';
import '../../dominio/repositorios/repositorio_de_usuario.dart';

class RegistrarUsuario {
  final RepositorioDeUsuario repositorio;
  RegistrarUsuario(this.repositorio);

  Future<void> call(Usuario usuario) async {
    // Validaciones simples
    if (usuario.nombre.isEmpty) {
      throw ArgumentError('El nombre es obligatorio');
    }
    if (usuario.email.isEmpty || !usuario.email.contains('@')) {
      throw ArgumentError('Email inválido');
    }
    if (usuario.password.isEmpty || usuario.password.length < 4) {
      throw ArgumentError('La contraseña debe tener al menos 4 caracteres');
    }

    // email único
    final existentes = await repositorio.obtenerUsuarios();
    final existeEmail =
        existentes.any((u) => u.email.toLowerCase() == usuario.email.toLowerCase());
    if (existeEmail) {
      throw StateError('Ya existe un usuario con ese email');
    }

    // Si pasó validaciones, guardar
    await repositorio.agregarUsuario(usuario);
  }
}
