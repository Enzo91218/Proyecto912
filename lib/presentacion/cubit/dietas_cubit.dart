import 'package:bloc/bloc.dart';
import '../../aplicacion/casos_de_uso/buscar_dietas.dart';
import '../../aplicacion/casos_de_uso/clasificar_recetas_a_dieta.dart';
import '../../dominio/entidades/receta.dart';
import '../../dominio/entidades/dieta.dart';

abstract class DietasState {}

class DietasInitial extends DietasState {}

class DietasLoading extends DietasState {}

class DietasDisponiblesLoaded extends DietasState {
  final List<Dieta> dietas;
  DietasDisponiblesLoaded(this.dietas);
}

class DietasLoaded extends DietasState {
  final List<Receta> recetas;
  final String dietaSeleccionada;
  final Map<Receta, String>? clasificaciones; // Gemini classifications
  DietasLoaded(this.recetas, this.dietaSeleccionada, {this.clasificaciones});
}

class DietasError extends DietasState {
  final String mensaje;
  DietasError(this.mensaje);
}

class DietasCubit extends Cubit<DietasState> {
  final BuscarDietas casoUso;
  final ClasificarRecetasADieta clasificador;

  DietasCubit(this.casoUso, this.clasificador) : super(DietasInitial());

  Future<void> cargarDietasDisponibles() async {
    emit(DietasLoading());
    try {
      final dietas = await casoUso.repositorioDietas.obtenerTodasLasDietas();
      emit(DietasDisponiblesLoaded(dietas));
    } catch (e) {
      emit(DietasError('Error al cargar dietas: $e'));
    }
  }

  Future<void> buscar(String nombreDieta) async {
    emit(DietasLoading());
    try {
      final recetas = await casoUso.call(nombreDieta);
      emit(DietasLoaded(recetas, nombreDieta));
    } catch (e) {
      emit(DietasError(e.toString()));
    }
  }

  Future<void> seleccionarDieta(Dieta dieta, List<Dieta> todasLasDietas) async {
    emit(DietasLoading());
    try {
      // Obtener recetas de la dieta seleccionada
      final recetas = await casoUso.call(dieta.nombre);

      // Clasificar cada receta a su dieta correspondiente usando Gemini
      final clasificaciones = await clasificador.clasificarMultiplesRecetas(
        recetas,
        todasLasDietas,
      );

      emit(
        DietasLoaded(recetas, dieta.nombre, clasificaciones: clasificaciones),
      );
    } catch (e) {
      emit(DietasError(e.toString()));
    }
  }
}
