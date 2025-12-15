
import '../dominio/entidades/receta.dart';
import '../dominio/entidades/ingrediente.dart';
import '../dominio/repositorios/repositorio_de_recetas.dart';

class RepositorioDeRecetasA implements RepositorioDeRecetas {
  final List<Receta> _recetas = [
    Receta(
      id: '1',
      titulo: 'Ensalada Mixta',
      descripcion: 'Ensalada de tomate, lechuga y cebolla con aderezo ligero',
      ingredientes: [
        Ingrediente(id: '1', nombre: 'Tomate', cantidad: '2 unidades'),
        Ingrediente(id: '2', nombre: 'Lechuga', cantidad: '1 unidad'),
        Ingrediente(id: '3', nombre: 'Cebolla', cantidad: '1/2 unidad'),
        Ingrediente(id: '4', nombre: 'Aceite de oliva', cantidad: '1 cucharada'),
      ],
      cultura: 'Mediterránea',
    ),
    Receta(
      id: '2',
      titulo: 'Tortilla de Papas',
      descripcion: 'Clásica tortilla española con papas y huevo',
      ingredientes: [
        Ingrediente(id: '5', nombre: 'Papa', cantidad: '4 unidades'),
        Ingrediente(id: '6', nombre: 'Huevo', cantidad: '3 unidades'),
        Ingrediente(id: '7', nombre: 'Aceite', cantidad: 'Al gusto'),
        Ingrediente(id: '8', nombre: 'Sal', cantidad: 'Al gusto'),
      ],
      cultura: 'Española',
    ),
    Receta(
      id: '3',
      titulo: 'Bowl de Quinoa',
      descripcion: 'Quinoa con verduras asadas y pollo a la plancha',
      ingredientes: [
        Ingrediente(id: '9', nombre: 'Quinoa', cantidad: '100g'),
        Ingrediente(id: '10', nombre: 'Zucchini', cantidad: '1 unidad'),
        Ingrediente(id: '11', nombre: 'Pechuga de pollo', cantidad: '150g'),
      ],
      cultura: 'Internacional',
    ),
  ];
  @override
  Future<List<Receta>> recetasPorCultura(String cultura) async {
    return _recetas
        .where((r) => r.cultura.toLowerCase() == cultura.toLowerCase())
        .toList();
  }

  @override
  Future<List<Receta>> recetasConIngredientes(List<Ingrediente> ingredientes) async {
    if (ingredientes.isEmpty) return _recetas;
    final buscados = ingredientes.map((i) => i.nombre.toLowerCase()).toList();
    return _recetas.where((r) {
      final nombres = r.ingredientes.map((i) => i.nombre.toLowerCase()).toList();
      return buscados.every((b) => nombres.contains(b));
    }).toList();
  }

  @override
  Future<void> agregarReceta(Receta receta) async {
    _recetas.add(receta);
  }
  
  @override
  Future<Receta?> obtenerRecetaAleatoria() async {
    if (_recetas.isEmpty) return null;
    _recetas.shuffle();
    return _recetas.first;
  }

  @override
  Future<List<String>> obtenerCulturasUnicas() async {
    final culturas = <String>{};
    for (final receta in _recetas) {
      culturas.add(receta.cultura);
    }
    return culturas.toList()..sort();
  }
}
