import 'package:uuid/uuid.dart';
import '../../dominio/entidades/mensaje_chat.dart';
import '../../dominio/entidades/receta.dart';
import '../../dominio/repositorios/repositorio_chat_ia.dart';

class ObtenerRespuestaIACasoDeUso {
  final RepositorioChatIA _repositorioChatIA;

  ObtenerRespuestaIACasoDeUso(this._repositorioChatIA);

  Future<MensajeChat> ejecutar({
    required String pregunta,
    required Receta receta,
    required String usuarioId,
  }) async {
    print('\n📝 ===== EJECUTAR CASO DE USO =====');
    
    // 1. Guardar pregunta del usuario
    print('1️⃣  Guardando mensaje del usuario...');
    final mensajeUsuario = MensajeChat(
      id: const Uuid().v4(),
      recetaId: receta.id,
      usuarioId: usuarioId,
      contenido: pregunta,
      esUsuario: true,
      fecha: DateTime.now(),
    );
    await _repositorioChatIA.guardarMensaje(mensajeUsuario);
    print('   ✅ Mensaje del usuario guardado: ${mensajeUsuario.id}');

    // 2. Obtener respuesta de IA
    print('2️⃣  Obteniendo respuesta de IA...');
    final contenidoRespuesta =
        await _repositorioChatIA.obtenerRespuesta(pregunta, receta);
    print('   ✅ Respuesta de IA obtenida (${contenidoRespuesta.length} caracteres)');

    // 3. Guardar respuesta de IA
    print('3️⃣  Guardando respuesta de IA...');
    final mensajeIA = MensajeChat(
      id: const Uuid().v4(),
      recetaId: receta.id,
      usuarioId: usuarioId,
      contenido: contenidoRespuesta,
      esUsuario: false,
      fecha: DateTime.now(),
    );
    await _repositorioChatIA.guardarMensaje(mensajeIA);
    print('   ✅ Respuesta de IA guardada: ${mensajeIA.id}');

    // 4. Retornar respuesta de IA para mostrar en UI
    print('4️⃣  Retornando respuesta');
    print('===== FIN CASO DE USO =====\n');
    return mensajeIA;
  }

  Future<List<MensajeChat>> obtenerHistorial(String recetaId) async {
    return _repositorioChatIA.obtenerHistorial(recetaId);
  }
}
