import '../dominio/entidades/ingrediente.dart';
import '../dominio/repositorios/repositorio_de_ingredientes.dart';

class RepositorioDeIngredientesA implements RepositorioDeIngredientes {
  @override
  List<Ingrediente> obtenerIngredientes() {
    // aca empiezan los ejemplos
    return [
      Ingrediente(id: '1', nombre: 'Tomate', cantidad: '2 unidades'),
      Ingrediente(id: '2', nombre: 'Lechuga', cantidad: '1 unidad'),
      Ingrediente(id: '3', nombre: 'Papa', cantidad: '3 unidades'),
      Ingrediente(id: '4', nombre: 'Cebolla', cantidad: '1/2 unidad'),
      Ingrediente(id: '5', nombre: 'Aceite de oliva', cantidad: '1 cucharada'),
      Ingrediente(id: '6', nombre: 'Quinoa', cantidad: '100g'),
    ];
  }
}
