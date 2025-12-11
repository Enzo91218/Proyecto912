import '../../dominio/repositorios/repositorio_de_recetas.dart';
import '../../dominio/entidades/ingrediente.dart';
import '../../dominio/entidades/receta.dart';

class BuscarRecetas {
  final RepositorioDeRecetas repositorio;
  BuscarRecetas(this.repositorio);

  Future<List<Receta>> call(List<Ingrediente> ingredientes) {
    return repositorio.recetasConIngredientes(ingredientes);
  }
}
