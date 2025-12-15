import '../../dominio/repositorios/repositorio_de_rutinas.dart';
import '../../dominio/entidades/rutina.dart';

class ObtenerRutinas {
  final RepositorioDeRutinas repositorio;

  ObtenerRutinas(this.repositorio);

  Future<List<Rutina>> call() {
    return repositorio.obtenerRutinas();
  }
}