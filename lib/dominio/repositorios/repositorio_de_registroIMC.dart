import '../entidades/resultado_imc.dart';

abstract class RepositorioDeRegistroIMC {
  Future<List<ResultadoIMC>> obtenerRegistrosIMC();
}
