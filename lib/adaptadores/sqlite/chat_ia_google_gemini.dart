import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sqflite/sqflite.dart';
import '../../dominio/entidades/mensaje_chat.dart';
import '../../dominio/entidades/receta.dart';
import '../../dominio/repositorios/repositorio_chat_ia.dart';
import 'database_provider.dart';

class ChatIAGoogleGemini implements RepositorioChatIA {
  final DatabaseProvider _databaseProvider;
  final String apiKey;
  late GenerativeModel _model;

  ChatIAGoogleGemini({
    required this.apiKey,
    required DatabaseProvider databaseProvider,
  }) : _databaseProvider = databaseProvider {
    _validarYInicializarModelo();
  }

  void _validarYInicializarModelo() {
    print('🔍 Validando API key de Gemini...');
    print('   API Key recibida: ${apiKey.substring(0, 15)}...');
    if (apiKey.isEmpty) {
      print('⚠️ API key está vacía');
      throw Exception('API key de Google Gemini no configurada');
    }

    print('✓ API key encontrada: ${apiKey.substring(0, 10)}...');

    try {
      _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
      print('✓ Modelo Gemini 2.0 Flash inicializado correctamente');
    } catch (e) {
      print('✗ Error inicializando modelo: $e');
      rethrow;
    }
  }

  @override
  Future<String> obtenerRespuesta(String pregunta, Receta receta) async {
    try {
      print('📤 Enviando pregunta a Gemini: $pregunta');

      // Crear prompt contextualizado con información de la receta
      final prompt = '''
Eres un asistente culinario amable y experto en recetas. El usuario está consultando sobre la siguiente receta:

**Receta: ${receta.titulo}**
Descripción: ${receta.descripcion}
Cultura: ${receta.cultura}
Ingredientes: ${receta.ingredientes.map((i) => '${i.nombre} (${i.cantidad})').join(', ')}

Pregunta del usuario: $pregunta

Proporciona una respuesta útil, concisa y en español. Si la pregunta es sobre la receta, usa la información proporcionada. Si es una pregunta más general sobre cocina, proporciona consejos útiles.
      ''';

      print('🔄 Llamando a API de Gemini...');

      // Intentar con reintentos en caso de error 429
      int intentos = 0;
      const maxIntentos = 3;

      while (intentos < maxIntentos) {
        try {
          intentos++;
          print('   Intento $intentos/$maxIntentos...');

          final content = [Content.text(prompt)];
          final response = await _model
              .generateContent(content)
              .timeout(
                const Duration(seconds: 60), // Aumentado a 60 segundos
              );

          print('📥 Respuesta recibida de Gemini');

          if (response.text != null && response.text!.isNotEmpty) {
            print('✓ Respuesta de Gemini procesada correctamente');
            return response.text!;
          } else {
            print('⚠️ Respuesta vacía de Gemini');
            return 'Lo siento, no pude generar una respuesta. Intenta con otra pregunta.';
          }
        } on GenerativeAIException catch (e) {
          if (e.message.contains('429') || e.message.contains('exhausted')) {
            print('⚠️ Error 429 (Cuota agotada) - Intento $intentos');
            if (intentos < maxIntentos) {
              final espera = Duration(
                seconds: intentos,
              ); // 1s, 2s, 3s (reducido)
              print('   Esperando ${espera.inSeconds}s antes de reintentar...');
              await Future.delayed(espera);
            } else {
              throw Exception(
                'Gemini API: Cuota de solicitudes agotada. Por favor, intenta más tarde.',
              );
            }
          } else {
            print('✗ Error en Google Gemini: ${e.message}');
            return 'Error en Google Gemini: ${e.message}. Por favor, intenta más tarde.';
          }
        }
      }

      return 'Error: No se pudo obtener respuesta después de varios intentos.';
    } catch (e) {
      print('✗ Error desconocido en Google Gemini: $e');
      print('   Tipo: ${e.runtimeType}');
      // Fallback a respuesta local si falla la API
      return 'Hubo un error al procesar tu pregunta. '
          'Por favor, intenta de nuevo más tarde. Error: ${e.toString()}';
    }
  }

  @override
  Future<void> guardarMensaje(MensajeChat mensaje) async {
    try {
      final db = await _databaseProvider.database;
      await db.insert(
        'chat_mensajes',
        mensaje.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('✓ Mensaje de chat guardado: ${mensaje.id}');
    } catch (e) {
      print('✗ Error guardando mensaje de chat: $e');
      rethrow;
    }
  }

  @override
  Future<List<MensajeChat>> obtenerHistorial(String recetaId) async {
    try {
      final db = await _databaseProvider.database;
      final results = await db.query(
        'chat_mensajes',
        where: 'receta_id = ?',
        whereArgs: [recetaId],
        orderBy: 'fecha ASC',
      );

      return results.map((map) => MensajeChat.fromMap(map)).toList();
    } catch (e) {
      print('✗ Error obtiendo historial de chat: $e');
      return [];
    }
  }

  @override
  Future<void> limpiarHistorial(String recetaId) async {
    try {
      final db = await _databaseProvider.database;
      await db.delete(
        'chat_mensajes',
        where: 'receta_id = ?',
        whereArgs: [recetaId],
      );
      print('✓ Historial de chat limpiado para receta: $recetaId');
    } catch (e) {
      print('✗ Error limpiando historial de chat: $e');
      rethrow;
    }
  }
}
