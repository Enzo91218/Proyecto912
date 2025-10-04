import '../dominio/entidades/receta.dart';
import '../dominio/entidades/ingrediente.dart';
import '../dominio/repositorios/repositorio_de_recetas.dart';

class RepositorioDeRecetasIMP implements RepositorioDeRecetas {
  @override
  List<Receta> recetasConIngredientes(List<Ingrediente> ingredientes) {
    // Implementación de ejemplo
    return [];
  }
}
