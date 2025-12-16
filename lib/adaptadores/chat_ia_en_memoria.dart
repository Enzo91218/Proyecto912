import '../dominio/entidades/mensaje_chat.dart';
import '../dominio/entidades/receta.dart';
import '../dominio/repositorios/repositorio_chat_ia.dart';

class ChatIAEnMemoria implements RepositorioChatIA {
  final List<MensajeChat> _mensajesEnMemoria = [];

  @override
  Future<String> obtenerRespuesta(String pregunta, Receta receta) async {
    // Convertir pregunta a minúsculas para búsqueda
    final preguntaLower = pregunta.toLowerCase();

    // Respuestas predefinidas basadas en palabras clave
    if (preguntaLower.contains('calor') || preguntaLower.contains('energía')) {
      return 'Esta receta es ideal para proporcionar energía. '
          'Contiene ingredientes nutritivos que te ayudarán durante el día.';
    }

    if (preguntaLower.contains('ingrediente')) {
      final ingredientes =
          receta.ingredientes.map((i) => i.nombre).join(', ');
      return 'Esta receta "${receta.titulo}" contiene los siguientes ingredientes: $ingredientes';
    }

    if (preguntaLower.contains('tiempo') || preguntaLower.contains('prepara')) {
      return 'El tiempo de preparación de "${receta.titulo}" varía según tu experiencia en la cocina. '
          'Generalmente, recetas de esta cultura toman entre 20-40 minutos.';
    }

    if (preguntaLower.contains('diabetic') || preguntaLower.contains('azúcar')) {
      return 'Esta receta puede adaptarse para personas con diabetes. '
          'Recomendamos consultar con un nutricionista para asegurar que sea adecuada para tu dieta.';
    }

    if (preguntaLower.contains('vegetarian') || preguntaLower.contains('vegan')) {
      return 'Esta receta "${receta.titulo}" puede adaptarse a una dieta vegetariana o vegana. '
          'Considera reemplazar ingredientes de origen animal con alternativas vegetales.';
    }

    if (preguntaLower.contains('cultura') || preguntaLower.contains('origen')) {
      return 'La receta "${receta.titulo}" es de la cultura ${receta.cultura}. '
          'Esta es una excelente opción para explorar sabores de ${receta.cultura}.';
    }

    if (preguntaLower.contains('hola') || preguntaLower.contains('buenos')) {
      return 'Hola 👋 Bienvenido al chat de recetas. '
          'Puedo ayudarte con preguntas sobre "${receta.titulo}". '
          'Pregunta sobre ingredientes, tiempo de preparación, adaptaciones dietarias, o cualquier duda que tengas.';
    }

    if (preguntaLower.contains('ayuda') || preguntaLower.contains('qué puedo')) {
      return 'Puedo ayudarte con:\n'
          '• Información de ingredientes\n'
          '• Tiempo de preparación\n'
          '• Adaptaciones para dietas especiales\n'
          '• Información nutricional\n'
          '• Origen cultural de la receta\n\n'
          '¿Qué te gustaría saber de "${receta.titulo}"?';
    }

    // Respuesta por defecto si no coincide ninguna palabra clave
    return 'Entendido. "${receta.titulo}" es una deliciosa receta de la cultura ${receta.cultura}. '
        'Para una respuesta más precisa, pregunta sobre ingredientes, tiempo de preparación, '
        'adaptaciones dietarias, o cualquier otro aspecto que te interese.';
  }

  @override
  Future<void> guardarMensaje(MensajeChat mensaje) async {
    _mensajesEnMemoria.add(mensaje);
  }

  @override
  Future<List<MensajeChat>> obtenerHistorial(String recetaId) async {
    return _mensajesEnMemoria
        .where((m) => m.recetaId == recetaId)
        .toList();
  }

  @override
  Future<void> limpiarHistorial(String recetaId) async {
    _mensajesEnMemoria.removeWhere((m) => m.recetaId == recetaId);
  }
}
