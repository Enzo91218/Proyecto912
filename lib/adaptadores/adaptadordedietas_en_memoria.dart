
import '../dominio/entidades/dieta.dart';
import '../dominio/entidades/ingrediente.dart';
import '../dominio/repositorios/repositorio_de_dietas.dart';

class RepositorioDeDietasA implements RepositorioDeDietas {
  @override
  List<Dieta> dietasConIngredientes(List<Ingrediente> ingredientes) {
    // aca empiezan los ejemplos
    return [
      Dieta(
        id: '1',
        nombre: 'Dieta Keto',
        recetasIds: ['1', '2'],
        ingredientes: ingredientes,
      ),
      Dieta(
        id: '2',
        nombre: 'Dieta Vegana',
        recetasIds: ['3'],
        ingredientes: ingredientes,
      ),
    ];
  }
}
