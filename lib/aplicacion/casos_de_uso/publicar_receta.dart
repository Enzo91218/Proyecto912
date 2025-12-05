import '../../dominio/entidades/receta.dart';
import '../../dominio/repositorios/repositorio_de_recetas.dart';
import '../../dominio/entidades/ingrediente.dart';

class PublicarReceta {
  final RepositorioDeRecetas repositorio;

  PublicarReceta(this.repositorio);

  void call(Receta receta) {
    repositorio.agregarReceta(receta);
  }

  void ejecutar({
    required String id,
    required String titulo,
    required String descripcion,
    required List<Ingrediente> ingredientes,
  }) {
    final receta = Receta(
      id: id,
      titulo: titulo,
      descripcion: descripcion,
      ingredientes: ingredientes,
    );
    repositorio.agregarReceta(receta);
  }
}
