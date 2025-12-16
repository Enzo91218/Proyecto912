import '../entidades/dieta.dart';
import '../entidades/ingrediente.dart';

abstract class RepositorioDeDietas {
  Future<List<Dieta>> dietasConIngredientes(List<Ingrediente> ingredientes);
  Future<List<Dieta>> obtenerTodasLasDietas();
}
