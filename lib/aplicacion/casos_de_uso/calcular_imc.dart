import '../../dominio/repositorios/repositorio_de_registroIMC.dart';
import '../../dominio/entidades/resultado_imc.dart';

class CalcularIMC {
  final RepositorioDeRegistroIMC repositorio;
  CalcularIMC(this.repositorio);

  Future<List<ResultadoIMC>> call() {
    return repositorio.obtenerRegistrosIMC();
  }
}
