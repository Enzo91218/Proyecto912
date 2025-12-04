import '../entidades/rutina.dart';

abstract class RepositorioDeRutinas {
  Future<List<Rutina>> obtenerRutinas();
}
