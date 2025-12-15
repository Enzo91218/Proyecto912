import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../dominio/repositorios/repositorio_de_registro_peso_altura.dart';
import '../../servicios/database_update_service.dart';

class PesoAlturaActual {
  final double peso;
  final double altura;

  PesoAlturaActual({required this.peso, required this.altura});
}

abstract class PesoAlturaActualState {}

class PesoAlturaActualLoading extends PesoAlturaActualState {}

class PesoAlturaActualLoaded extends PesoAlturaActualState {
  final PesoAlturaActual datos;

  PesoAlturaActualLoaded(this.datos);
}

class PesoAlturaActualError extends PesoAlturaActualState {
  final String mensaje;

  PesoAlturaActualError(this.mensaje);
}

class PesoAlturaActualCubit extends Cubit<PesoAlturaActualState> {
  final RepositorioDeRegistroPesoAltura repositorio;
  late String _usuarioId;

  PesoAlturaActualCubit({required this.repositorio})
      : super(PesoAlturaActualLoading()) {
    // Escuchar cambios en la BD
    final updateService = GetIt.instance.get<DatabaseUpdateService>();
    updateService.addListener(_onDatabaseUpdate);
  }

  void _onDatabaseUpdate() {
    if (_usuarioId.isNotEmpty) {
      cargar(_usuarioId);
    }
  }

  Future<void> cargar(String usuarioId) async {
    _usuarioId = usuarioId;
    try {
      emit(PesoAlturaActualLoading());
      final registros = await repositorio.obtenerRegistros(usuarioId);

      if (registros.isEmpty) {
        emit(PesoAlturaActualError('No hay registros'));
        return;
      }

      // Obtener el último registro
      final ultimoRegistro = registros.last;
      emit(
        PesoAlturaActualLoaded(
          PesoAlturaActual(
            peso: ultimoRegistro.peso,
            altura: ultimoRegistro.altura,
          ),
        ),
      );
    } catch (e) {
      emit(PesoAlturaActualError('Error: $e'));
    }
  }

  @override
  Future<void> close() {
    // Dejar de escuchar cambios
    final updateService = GetIt.instance.get<DatabaseUpdateService>();
    updateService.removeListener(_onDatabaseUpdate);
    return super.close();
  }
}
