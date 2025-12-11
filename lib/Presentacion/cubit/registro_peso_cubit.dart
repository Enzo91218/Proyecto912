import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/entidades/registro_peso_altura_entidad.dart';
import '../../dominio/repositorios/repositorio_de_registro_peso_altura.dart';

part 'registro_peso_state.dart';

class RegistroPesoCubit extends Cubit<RegistroPesoState> {
  final RepositorioDeRegistroPesoAltura repositorio;
  final String usuarioId;

  RegistroPesoCubit({
    required this.repositorio,
    required this.usuarioId,
  }) : super(RegistroPesoInicial());

  void cargar() {
    final registros = repositorio.obtenerRegistros(usuarioId);
    emit(RegistroPesoCargado(registros: registros));
  }
}
