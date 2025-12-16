import 'package:sqflite/sqflite.dart';
import '../../dominio/entidades/mensaje_chat.dart';
import '../../dominio/entidades/receta.dart';
import '../../dominio/repositorios/repositorio_chat_ia.dart';
import '../chat_ia_en_memoria.dart';
import 'database_provider.dart';

class ChatIASqliteAdaptador implements RepositorioChatIA {
  final DatabaseProvider _databaseProvider;
  final ChatIAEnMemoria _iaLocal; // Para las respuestas inteligentes

  ChatIASqliteAdaptador(this._databaseProvider)
      : _iaLocal = ChatIAEnMemoria();

  @override
  Future<String> obtenerRespuesta(String pregunta, Receta receta) async {
    // Delegar a la IA local (respuestas basadas en palabras clave)
    return _iaLocal.obtenerRespuesta(pregunta, receta);
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
