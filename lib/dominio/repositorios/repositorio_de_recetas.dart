import '../entidades/receta.dart';
import '../entidades/ingrediente.dart';

abstract class RepositorioDeRecetas {
  List<Receta> recetasConIngredientes(List<Ingrediente> ingredientes);
}
