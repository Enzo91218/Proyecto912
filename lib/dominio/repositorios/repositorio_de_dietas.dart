import '../entidades/dieta.dart';
import '../entidades/ingrediente.dart';

abstract class RepositorioDeDietas {
  List<Dieta> dietasConIngredientes(List<Ingrediente> ingredientes);
}
