import '../../dominio/repositorios/repositorio_de_recetas.dart';
import '../../dominio/entidades/receta.dart';

class FiltrarRecetasPorCultura {
  final RepositorioDeRecetas repositorio;
  FiltrarRecetasPorCultura(this.repositorio);

  Future<List<Receta>> call(String cultura) {
    return repositorio.recetasPorCultura(cultura);
  }
}