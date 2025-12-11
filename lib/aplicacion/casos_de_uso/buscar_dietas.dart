import '../../dominio/repositorios/repositorio_de_dietas.dart';
import '../../dominio/repositorios/repositorio_de_recetas.dart';
import '../../dominio/entidades/receta.dart';


class BuscarDietas {
  final RepositorioDeDietas repositorioDietas;
  final RepositorioDeRecetas repositorioRecetas;

  BuscarDietas(this.repositorioDietas, this.repositorioRecetas);

  Future<List<Receta>> call(String nombreDieta) async {
    final todasDietas = await repositorioDietas.dietasConIngredientes([]);
    final dieta = todasDietas.firstWhere(
      (d) => d.nombre.toLowerCase().contains(nombreDieta.toLowerCase()),
      orElse: () => throw StateError('Dieta no encontrada'),
    );

    final todasRecetas = await repositorioRecetas.recetasConIngredientes([]);
    final recetas = todasRecetas.where((r) => dieta.recetasIds.contains(r.id)).toList();
    return recetas;
  }
}
