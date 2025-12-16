import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import '../../aplicacion/casos_de_uso/obtener_respuesta_ia_caso_de_uso.dart';
import '../../dominio/entidades/receta.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ObtenerRespuestaIACasoDeUso _obtenerRespuestaIA;

  ChatCubit(this._obtenerRespuestaIA) : super(const ChatInitialState());

  Future<void> cargarHistorial(String recetaId) async {
    try {
      emit(const ChatLoadingState());
      final mensajes = await _obtenerRespuestaIA.obtenerHistorial(recetaId);
      emit(ChatCargadoState(mensajes: mensajes, recetaId: recetaId));
    } catch (e) {
      emit(ChatErrorState('Error cargando historial: $e'));
    }
  }

  Future<void> enviarMensaje(
    String pregunta,
    Receta receta,
    String usuarioId,
  ) async {
    try {
      final estadoActual = state;
      if (estadoActual is! ChatCargadoState) {
        print(
          '❌ Estado actual no es ChatCargadoState: ${estadoActual.runtimeType}',
        );
        return;
      }

      print('\n📨 ===== INICIANDO ENVÍO DE MENSAJE =====');
      print('   Pregunta: "$pregunta"');
      print('   Receta ID: ${receta.id}');
      print('   Usuario ID: $usuarioId');

      // Mostrar estado de carga mientras espera la respuesta
      emit(
        ChatCargadoState(
          mensajes: estadoActual.mensajes,
          recetaId: receta.id,
          esperandoRespuesta: true,
        ),
      );

      print('✅ Estado actualizado a esperandoRespuesta=true');
      print('⏳ Llamando a caso de uso...');

      // El caso de uso maneja: guardar pregunta → obtener respuesta → guardar respuesta
      await _obtenerRespuestaIA.ejecutar(
        pregunta: pregunta,
        receta: receta,
        usuarioId: usuarioId,
      );

      print('✅ Caso de uso completado');
      print('📥 Obteniendo historial actualizado...');

      // Obtener historial actualizado desde la BD
      final mensajesFinal = await _obtenerRespuestaIA.obtenerHistorial(
        receta.id,
      );

      print('✅ Historial obtenido: ${mensajesFinal.length} mensajes totales');
      for (int i = 0; i < mensajesFinal.length; i++) {
        final m = mensajesFinal[i];
        final preview = m.contenido.substring(
          0,
          math.min(50, m.contenido.length),
        );
        print(
          '   [$i] ${m.esUsuario ? "👤 Usuario" : "🤖 IA"}: $preview${m.contenido.length > 50 ? "..." : ""}',
        );
      }

      // Emitir estado final sin espera
      emit(
        ChatCargadoState(
          mensajes: mensajesFinal,
          recetaId: receta.id,
          esperandoRespuesta: false,
        ),
      );

      print('✅ Chat actualizado correctamente');
      print('===== FIN ENVÍO DE MENSAJE =====\n');
    } catch (e) {
      print('\n❌ ERROR EN ENVIAR MENSAJE:');
      print('   Error: $e');
      print('   Tipo: ${e.runtimeType}');
      print('   Stack: ${StackTrace.current}');
      emit(ChatErrorState('Error enviando mensaje: $e'));
    }
  }

  void limpiarChat() {
    emit(const ChatInitialState());
  }
}
