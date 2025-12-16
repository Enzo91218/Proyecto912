import '../entidades/mensaje_chat.dart';
import '../../dominio/entidades/receta.dart';

abstract class RepositorioChatIA {
  /// Obtiene respuesta de IA basada en la pregunta y la receta
  Future<String> obtenerRespuesta(String pregunta, Receta receta);

  /// Guarda un mensaje en el historial
  Future<void> guardarMensaje(MensajeChat mensaje);

  /// Obtiene el historial de chat de una receta específica
  Future<List<MensajeChat>> obtenerHistorial(String recetaId);

  /// Elimina el historial de una receta
  Future<void> limpiarHistorial(String recetaId);
}
