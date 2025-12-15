class Alimento {
  final int dia;
  final String horario;
  final String alimento;
  final String cantidad;
  bool completada;

  Alimento({
    required this.dia,
    required this.horario,
    required this.alimento,
    required this.cantidad,
    this.completada = false,
  });
}

class Rutina {
  final String id;
  final String nombre;
  final String descripcion;
  final List<Alimento> alimentos;
  final bool favorito;

  Rutina({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.alimentos,
    this.favorito = false,
  });
}
