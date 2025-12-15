import '../../dominio/repositorios/repositorio_de_registroIMC.dart';
import '../../dominio/entidades/resultado_imc.dart';

class CalcularIMC {
  final RepositorioDeRegistroIMC repositorio;
  CalcularIMC(this.repositorio);

  Future<List<ResultadoIMC>> call(String usuarioId) {
    return repositorio.obtenerRegistros(usuarioId);
  }
}

