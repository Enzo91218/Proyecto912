class MensajeChat {
  final String id;
  final String recetaId;
  final String usuarioId;
  final String contenido;
  final bool esUsuario; // true = usuario, false = IA
  final DateTime fecha;

  MensajeChat({
    required this.id,
    required this.recetaId,
    required this.usuarioId,
    required this.contenido,
    required this.esUsuario,
    required this.fecha,
  });

  // Convertir a Map para guardar en BD
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receta_id': recetaId,
      'usuario_id': usuarioId,
      'contenido': contenido,
      'es_usuario': esUsuario ? 1 : 0,
      'fecha': fecha.toIso8601String(),
    };
  }

  // Crear desde Map de BD
  factory MensajeChat.fromMap(Map<String, dynamic> map) {
    return MensajeChat(
      id: map['id'] as String,
      recetaId: map['receta_id'] as String,
      usuarioId: map['usuario_id'] as String,
      contenido: map['contenido'] as String,
      esUsuario: (map['es_usuario'] as int) == 1,
      fecha: DateTime.parse(map['fecha'] as String),
    );
  }
}
