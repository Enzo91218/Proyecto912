import 'package:bloc/bloc.dart';
import '../../aplicacion/casos_de_uso/obtener_rutinas.dart';
import '../../dominio/entidades/rutina.dart';

class RutinasCubit extends Cubit<RutinasState> {
  final ObtenerRutinas casoUso;

  RutinasCubit(this.casoUso) : super(RutinasInitial()) {
    print('🎯 RutinasCubit: Constructor llamado');
  }

  Future<void> cargar() async {
    print('🚀 RutinasCubit: Iniciando carga...');
    emit(RutinasLoading());
    try {
      print('📞 RutinasCubit: Llamando al caso de uso...');
      final rutinas = await casoUso.call();
      print('📦 RutinasCubit: Recibidas ${rutinas.length} rutinas');
      
      if (rutinas.isEmpty) {
        print('⚠️ RutinasCubit: Lista vacía, emitiendo error');
        emit(RutinasError('No hay planes alimenticios disponibles'));
        return;
      }
      
      print('✅ RutinasCubit: Emitiendo RutinasLoaded con ${rutinas.length} rutinas');
      emit(RutinasLoaded(rutinas));
    } catch (e) {
      print('❌ RutinasCubit: Error capturado: $e');
      emit(RutinasError('Error al cargar rutinas: $e'));
    }
  }
}

abstract class RutinasState {}

class RutinasInitial extends RutinasState {}

class RutinasLoading extends RutinasState {}

class RutinasLoaded extends RutinasState {
  final List<Rutina> rutinas;
  RutinasLoaded(this.rutinas);
}

class RutinasError extends RutinasState {
  final String mensaje;
  RutinasError(this.mensaje);
}
