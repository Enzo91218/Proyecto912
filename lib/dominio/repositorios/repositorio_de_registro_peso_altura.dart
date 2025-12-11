import '../entidades/registro_peso_altura_entidad.dart';

abstract class RepositorioDeRegistroPesoAltura {
  Future<List<RegistroPesoAltura>> obtenerRegistros(String usuarioId);
  Future<void> agregarRegistro(RegistroPesoAltura registro);
}
