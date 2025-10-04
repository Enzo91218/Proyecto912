import 'ingrediente.dart';

class Dieta {
  final String id;
  final String nombre;
  final List<String> recetasIds;
  final List<Ingrediente> ingredientes;

  Dieta({
    required this.id,
    required this.nombre,
    required this.recetasIds,
    required this.ingredientes,
  });
}
