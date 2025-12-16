import 'package:equatable/equatable.dart';
import '../../dominio/entidades/mensaje_chat.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitialState extends ChatState {
  const ChatInitialState();
}

class ChatLoadingState extends ChatState {
  const ChatLoadingState();
}

class ChatCargadoState extends ChatState {
  final List<MensajeChat> mensajes;
  final String recetaId;
  final bool esperandoRespuesta;

  const ChatCargadoState({
    required this.mensajes,
    required this.recetaId,
    this.esperandoRespuesta = false,
  });

  ChatCargadoState copyWith({
    List<MensajeChat>? mensajes,
    String? recetaId,
    bool? esperandoRespuesta,
  }) {
    return ChatCargadoState(
      mensajes: mensajes ?? this.mensajes,
      recetaId: recetaId ?? this.recetaId,
      esperandoRespuesta: esperandoRespuesta ?? this.esperandoRespuesta,
    );
  }

  @override
  List<Object?> get props => [mensajes, recetaId, esperandoRespuesta];
}

class ChatErrorState extends ChatState {
  final String mensaje;

  const ChatErrorState(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}
