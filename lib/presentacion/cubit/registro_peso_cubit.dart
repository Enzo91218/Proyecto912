import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/entidades/registro_peso_altura_entidad.dart';
import '../../dominio/repositorios/repositorio_de_registro_peso_altura.dart';

part 'registro_peso_state.dart';

class RegistroPesoCubit extends Cubit<RegistroPesoState> {
  final RepositorioDeRegistroPesoAltura repositorio;
  final String usuarioId;

  RegistroPesoCubit({required this.repositorio, required this.usuarioId})
    : super(RegistroPesoInicial());

  Future<void> cargar() async {
    try {
      print('📥 Cargando registros de peso para usuario: $usuarioId');
      final registros = await repositorio.obtenerRegistros(usuarioId);
      print('📥 Registros cargados: ${registros.length}');
      emit(RegistroPesoCargado(registros: registros));
    } catch (e) {
      print('❌ Error cargando registros: $e');
      emit(RegistroPesoError(mensaje: 'Error al cargar: $e'));
    }
  }

  Future<void> agregarRegistro(
    String usuarioId,
    double peso,
    double altura,
  ) async {
    try {
      print('💾 Agregando registro de peso: $peso kg, altura: $altura m');
      final registro = RegistroPesoAltura(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        usuarioId: usuarioId,
        peso: peso,
        altura: altura,
        fecha: DateTime.now(),
      );
      await repositorio.agregarRegistro(registro);
      print('✅ Registro guardado. Recargando lista...');
      // Recargar la lista
      await cargar();
    } catch (e) {
      print('❌ Error al agregar registro: $e');
      emit(RegistroPesoError(mensaje: 'Error al agregar registro: $e'));
    }
  }
}
