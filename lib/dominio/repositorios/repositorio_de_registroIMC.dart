import '../entidades/resultado_imc.dart';

abstract class RepositorioDeRegistroIMC {
  Future<void> guardarRegistroIMC(String usuarioId, double imc, String categoria);
  Future<List<ResultadoIMC>> obtenerRegistros(String usuarioId);
}