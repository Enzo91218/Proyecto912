import 'package:bloc/bloc.dart';
import '../../aplicacion/casos_de_uso/buscar_recetas.dart';
import '../../dominio/entidades/receta.dart';
import '../../dominio/entidades/ingrediente.dart';

abstract class RecetasState {}

class RecetaAleatoriaLoaded extends RecetasState {
  final Receta receta;
  RecetaAleatoriaLoaded(this.receta);
}

class RecetasInitial extends RecetasState {}

class RecetasLoading extends RecetasState {}

class RecetasLoaded extends RecetasState {
  final List<Receta> recetas;
  RecetasLoaded(this.recetas);
}

class RecetasError extends RecetasState {
  final String mensaje;
  RecetasError(this.mensaje);
}

class RecetasCubit extends Cubit<RecetasState> {
  final BuscarRecetas casoUso;
  RecetasCubit(this.casoUso) : super(RecetasInitial());

  Future<void> buscar(List<Ingrediente> ingredientes) async {
    emit(RecetasLoading());
    try {
      final recetas = await casoUso.call(ingredientes);
      if (recetas.isEmpty) {
        emit(
          RecetasError(
            'No se encontraron recetas para los ingredientes proporcionados',
          ),
        );
        return;
      }
      emit(RecetasLoaded(recetas));
    } catch (e) {
      emit(RecetasError(e.toString()));
    }
  }

  Future<void> mostrarAleatoria() async {
    final receta = await casoUso.repositorio.obtenerRecetaAleatoria();
    if (receta != null) {
      emit(RecetaAleatoriaLoaded(receta));
    } else {
      emit(RecetasError('No hay recetas disponibles.'));
    }
  }
}
