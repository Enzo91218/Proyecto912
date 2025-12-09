import '../entidades/receta.dart';
import '../entidades/ingrediente.dart';

abstract class RepositorioDeRecetas {
  List<Receta> recetasConIngredientes(List<Ingrediente> ingredientes);

  List<Receta> recetasPorCultura(String cultura);

  void agregarReceta(Receta receta);
  Receta? obtenerRecetaAleatoria();
}
