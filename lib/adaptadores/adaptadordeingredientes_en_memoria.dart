import '../dominio/entidades/ingrediente.dart';
import '../dominio/repositorios/repositorio_de_ingredientes.dart';

class RepositorioDeIngredientesA implements RepositorioDeIngredientes {
  @override
  List<Ingrediente> obtenerIngredientes() {
    // aca empiezan los ejemplos
    return [
      Ingrediente(id: '1', nombre: 'Tomate', cantidad: '2'),
      Ingrediente(id: '2', nombre: 'Lechuga', cantidad: '1'),
      Ingrediente(id: '3', nombre: 'Papa', cantidad: '3'),
    ];
  }
}
