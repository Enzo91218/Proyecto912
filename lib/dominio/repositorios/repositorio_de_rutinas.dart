import '../entidades/rutina.dart';

abstract class RepositorioDeRutinas {
  Future<List<Rutina>> obtenerRutinas();
  Future<void> marcarDiaCompletado(String rutinaId, int dia, bool completada);
}
