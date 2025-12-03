import 'dart:math';
import '../../dominio/entidades/registro_peso_altura_entidad.dart';
import '../../dominio/repositorios/repositorio_de_registro_peso_altura.dart';
import '../../servicios/database_sync_service.dart';

class RegistroPesoAlturaUC {
  final RepositorioDeRegistroPesoAltura repositorio;

  RegistroPesoAlturaUC({required this.repositorio});

  String _generarId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(10000).toString();
  }

  Future<void> ejecutar(String usuarioId, double peso, double altura) async {
    final registro = RegistroPesoAltura(
      id: _generarId(),
      usuarioId: usuarioId,
      peso: peso,
      altura: altura,
      fecha: DateTime.now(),
    );
    repositorio.agregarRegistro(registro);
    
    // Sincronizar BD automáticamente
    await DatabaseSyncService.instance.sincronizarConLog('Registro de peso agregado para usuario: $usuarioId');
  }
}
