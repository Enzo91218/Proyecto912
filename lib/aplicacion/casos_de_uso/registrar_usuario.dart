import 'dart:math';
import '../../dominio/entidades/usuario.dart';
import '../../dominio/entidades/registro_peso_altura_entidad.dart';
import '../../dominio/repositorios/repositorio_de_usuario.dart';
import '../../dominio/repositorios/repositorio_de_registro_peso_altura.dart';
import '../../servicios/database_sync_service.dart';

class RegistrarUsuario {
  final RepositorioDeUsuario repositorio;
  final RepositorioDeRegistroPesoAltura repositorioPesoAltura;

  RegistrarUsuario(this.repositorio, {required this.repositorioPesoAltura});

  String _generarId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(10000).toString();
  }

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
    final existentes = repositorio.obtenerUsuarios();
    final existeEmail = existentes.any((u) => u.email.toLowerCase() == usuario.email.toLowerCase());
    if (existeEmail) {
      throw StateError('Ya existe un usuario con ese email');
    }

    // Si pasó validaciones, guardar usuario
    repositorio.agregarUsuario(usuario);

    // Guardar el registro inicial de peso y altura
    final registroInicial = RegistroPesoAltura(
      id: _generarId(),
      usuarioId: usuario.id,
      peso: usuario.peso,
      altura: usuario.altura,
      fecha: DateTime.now(),
    );
    repositorioPesoAltura.agregarRegistro(registroInicial);

    // Sincronizar BD automáticamente
    await DatabaseSyncService.instance.sincronizarConLog('Nuevo usuario registrado: ${usuario.email}');
  }
}

