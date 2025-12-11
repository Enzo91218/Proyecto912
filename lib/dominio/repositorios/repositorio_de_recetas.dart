import '../entidades/receta.dart';
import '../entidades/ingrediente.dart';

abstract class RepositorioDeRecetas {
  Future<List<Receta>> recetasConIngredientes(List<Ingrediente> ingredientes);

  Future<List<Receta>> recetasPorCultura(String cultura);

  Future<void> agregarReceta(Receta receta);
  Future<Receta?> obtenerRecetaAleatoria();
}
