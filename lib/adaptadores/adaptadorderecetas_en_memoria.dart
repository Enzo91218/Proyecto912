
import '../dominio/entidades/receta.dart';
import '../dominio/entidades/ingrediente.dart';
import '../dominio/repositorios/repositorio_de_recetas.dart';

class RepositorioDeRecetasA implements RepositorioDeRecetas {
  @override
  List<Receta> recetasConIngredientes(List<Ingrediente> ingredientes) {
    // aca empiezan los ejemplos
    return [
      Receta(
        id: '1',
        titulo: 'Ensalada',
        descripcion: 'Ensalada de tomate y lechuga',
        ingredientes: ingredientes,
      ),
      Receta(
        id: '2',
        titulo: 'Tortilla',
        descripcion: 'Tortilla de papas',
        ingredientes: ingredientes,
      ),
    ];
  }
}
