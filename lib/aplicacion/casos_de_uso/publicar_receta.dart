import '../../dominio/entidades/receta.dart';
import '../../dominio/repositorios/repositorio_de_recetas.dart';
import '../../dominio/entidades/ingrediente.dart';

class PublicarReceta {
  final RepositorioDeRecetas repositorio;

  PublicarReceta(this.repositorio);

  Future<void> call(Receta receta) {
    return repositorio.agregarReceta(receta);
  }

  Future<void> ejecutar({
    required String id,
    required String titulo,
    required String descripcion,
    required List<Ingrediente> ingredientes,
    required String cultura, // <-- Agrega este argumento
  }) {
    final receta = Receta(
      id: id,
      titulo: titulo,
      descripcion: descripcion,
      ingredientes: ingredientes,
      cultura: cultura,
    );
    return repositorio.agregarReceta(receta);
  }
}
