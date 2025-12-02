import '../entidades/registro_peso_altura_entidad.dart';

abstract class RepositorioDeRegistroPesoAltura {
  List<RegistroPesoAltura> obtenerRegistros(String usuarioId);
  void agregarRegistro(RegistroPesoAltura registro);
}
