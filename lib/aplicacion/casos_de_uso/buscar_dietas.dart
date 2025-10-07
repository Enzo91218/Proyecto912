import '../../dominio/repositorios/repositorio_de_dietas.dart';
import '../../dominio/entidades/ingrediente.dart';
import '../../dominio/entidades/dieta.dart';

class BuscarDietas {
  final RepositorioDeDietas repositorio;
  BuscarDietas(this.repositorio);

  List<Dieta> call(List<Ingrediente> ingredientes) {
    return repositorio.dietasConIngredientes(ingredientes);
  }
}
