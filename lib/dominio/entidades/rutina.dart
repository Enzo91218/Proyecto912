import 'package:flutter/foundation.dart';

class Rutina {
  final String id;
  final String nombre;
  final String descripcion;
  final List<String> ejercicios;
  final bool favorito;

  Rutina({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ejercicios,
    this.favorito = false,
  });
}
