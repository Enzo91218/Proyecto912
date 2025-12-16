import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../dominio/entidades/receta.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

class ChatRecetaScreen extends StatefulWidget {
  final Receta receta;
  final String usuarioId;

  const ChatRecetaScreen({
    super.key,
    required this.receta,
    required this.usuarioId,
  });

  @override
  State<ChatRecetaScreen> createState() => _ChatRecetaScreenState();
}

class _ChatRecetaScreenState extends State<ChatRecetaScreen> {
  late FocusNode _keyboardFocusNode;
  final TextEditingController _preguntaCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _keyboardFocusNode = FocusNode();
    
    // Cargar historial cuando se abre la pantalla
    context.read<ChatCubit>().cargarHistorial(widget.receta.id);
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    _preguntaCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _enviarMensaje() {
    final pregunta = _preguntaCtrl.text.trim();
    if (pregunta.isEmpty) return;

    context.read<ChatCubit>().enviarMensaje(
      pregunta,
      widget.receta,
      widget.usuarioId,
    );

    _preguntaCtrl.clear();
    _scrollAlFinal();
  }

  void _scrollAlFinal() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          context.read<ChatCubit>().limpiarChat();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat: ${widget.receta.titulo}'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<ChatCubit>().limpiarChat();
              context.pop();
            },
          ),
        ),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is ChatInitialState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ChatErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.mensaje,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ChatCubit>()
                              .cargarHistorial(widget.receta.id),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (state is ChatCargadoState) {
              return Column(
                children: [
                  // Lista de mensajes
                  Expanded(
                    child: state.mensajes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Inicia una conversación sobre esta receta',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(12),
                            itemCount: state.mensajes.length,
                            itemBuilder: (context, index) {
                              final mensaje = state.mensajes[index];
                              return _MensajeBubble(
                                mensaje: mensaje.contenido,
                                esUsuario: mensaje.esUsuario,
                              );
                            },
                          ),
                  ),
                  // Indicador de IA pensando con puntos animados
                  if (state.esperandoRespuesta)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: _PuntosAnimados(),
                    ),
                  // Input de pregunta
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey[300]!,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _preguntaCtrl,
                            focusNode: _keyboardFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Pregunta sobre esta receta...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            maxLines: null,
                            onSubmitted: (_) => _enviarMensaje(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FloatingActionButton(
                          mini: true,
                          onPressed: state.esperandoRespuesta ? null : _enviarMensaje,
                          child: state.esperandoRespuesta
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class _MensajeBubble extends StatelessWidget {
  final String mensaje;
  final bool esUsuario;

  const _MensajeBubble({
    required this.mensaje,
    required this.esUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: esUsuario ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          mensaje,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

/// Widget que muestra puntos animados mientras la IA está escribiendo
class _PuntosAnimados extends StatefulWidget {
  const _PuntosAnimados();

  @override
  State<_PuntosAnimados> createState() => _PuntosAnimadosState();
}

class _PuntosAnimadosState extends State<_PuntosAnimados>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final dots = '.' * (((_controller.value * 3).floor() % 3) + 1);
            return Text(
              dots,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            );
          },
        ),
      ),
    );
  }
}
