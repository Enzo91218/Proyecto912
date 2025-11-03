import '../../dominio/repositorios/repositorio_de_dietas.dart';
import '../../dominio/repositorios/repositorio_de_recetas.dart';
import '../../dominio/entidades/ingrediente.dart';
import '../../dominio/entidades/receta.dart';


class BuscarDietas {
  final RepositorioDeDietas repositorioDietas;
  final RepositorioDeRecetas repositorioRecetas;

  BuscarDietas(this.repositorioDietas, this.repositorioRecetas);

  List<Receta> call(String nombreDieta, {List<Ingrediente> ingredientes = const []}) {
    final todasDietas = repositorioDietas.dietasConIngredientes(ingredientes);
    final dietasCoincidentes = todasDietas
        .where((d) => d.nombre.toLowerCase().contains(nombreDieta.toLowerCase()))
        .toList();

    if (dietasCoincidentes.isEmpty) {
      return [];
    }

    final dieta = dietasCoincidentes.first;

    final recetasFiltradas = repositorioRecetas.recetasConIngredientes(dieta.ingredientes);
    return recetasFiltradas.where((r) => dieta.recetasIds.contains(r.id)).toList();
  }
}
