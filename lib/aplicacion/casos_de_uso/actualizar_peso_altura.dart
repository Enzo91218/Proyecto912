import '../../dominio/entidades/usuario.dart';
import '../../dominio/repositorios/repositorio_de_usuario.dart';

class ActualizarPesoAltura {
  final RepositorioDeUsuario repositorio;

  ActualizarPesoAltura({required this.repositorio});

  Future<void> ejecutar(String usuarioId, double nuevoPeso, double nuevaAltura) async {
    final usuarios = await repositorio.obtenerUsuarios();
    final usuario = usuarios.firstWhere((u) => u.id == usuarioId);
    
    final usuarioActualizado = Usuario(
      id: usuario.id,
      nombre: usuario.nombre,
      email: usuario.email,
      password: usuario.password,
      edad: usuario.edad,
      peso: nuevoPeso,
      altura: nuevaAltura,
    );
    
    await repositorio.actualizarUsuario(usuarioActualizado);
  }
}
