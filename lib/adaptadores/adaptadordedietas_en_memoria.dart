
import '../dominio/entidades/dieta.dart';
import '../dominio/entidades/ingrediente.dart';
import '../dominio/repositorios/repositorio_de_dietas.dart';

class RepositorioDeDietasA implements RepositorioDeDietas {
  @override
  List<Dieta> dietasConIngredientes(List<Ingrediente> ingredientes) {
    // aca empiezan los ejemplos
    final todas = [
      Dieta(
        id: '1',
        nombre: 'Dieta Keto',
        recetasIds: ['1', '2'],
        ingredientes: [
          Ingrediente(id: '12', nombre: 'Aguacate', cantidad: '1 unidad'),
          Ingrediente(id: '13', nombre: 'Huevos', cantidad: '3 unidades'),
          Ingrediente(id: '14', nombre: 'Queso', cantidad: '50g'),
        ],
      ),
      Dieta(
        id: '2',
        nombre: 'Dieta Vegana',
        recetasIds: ['3'],
        ingredientes: [
          Ingrediente(id: '15', nombre: 'Tofu', cantidad: '150g'),
          Ingrediente(id: '16', nombre: 'Lentejas', cantidad: '100g'),
        ],
      ),
      Dieta(
        id: '3',
        nombre: 'Dieta Balanceada',
        recetasIds: ['1', '3'],
        ingredientes: [
          Ingrediente(id: '17', nombre: 'Pollo', cantidad: '150g'),
          Ingrediente(id: '18', nombre: 'Arroz integral', cantidad: '100g'),
        ],
      ),
    ];

    if (ingredientes.isEmpty) {
      return todas;
    }

    final buscados = ingredientes.map((i) => i.nombre.toLowerCase()).toList();
    return todas.where((d) {
      final nombres = d.ingredientes.map((i) => i.nombre.toLowerCase()).toList();
      return buscados.every((b) => nombres.contains(b));
    }).toList();
  }
}
