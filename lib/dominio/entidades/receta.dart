import 'ingrediente.dart';

class Receta {
  final String id;
  final String titulo;
  final String descripcion;
  final List<Ingrediente> ingredientes;
  final String cultura;

  Receta({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.ingredientes,
    required this.cultura,
  });
}
