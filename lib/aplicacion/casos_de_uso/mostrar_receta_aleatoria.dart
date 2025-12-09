import '../../dominio/entidades/receta.dart';
import '../../dominio/repositorios/repositorio_de_recetas.dart';

class MostrarRecetaAleatoria {
  final RepositorioDeRecetas repositorio;
  MostrarRecetaAleatoria(this.repositorio);

  Receta? call() {
    return repositorio.obtenerRecetaAleatoria();
  }
}
