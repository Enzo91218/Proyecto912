import 'package:bloc/bloc.dart';
import '../../aplicacion/casos_de_uso/buscar_dietas.dart';
import '../../dominio/entidades/ingrediente.dart';
import '../../dominio/entidades/receta.dart';

abstract class DietasState {}
class DietasInitial extends DietasState {}
class DietasLoading extends DietasState {}
class DietasLoaded extends DietasState {
  final List<Receta> recetas;
  DietasLoaded(this.recetas);
}
class DietasError extends DietasState {
  final String mensaje;
  DietasError(this.mensaje);
}

class DietasCubit extends Cubit<DietasState> {
  final BuscarDietas casoUso;
  DietasCubit(this.casoUso) : super(DietasInitial());

  Future<void> buscar(String nombreDieta, {List<Ingrediente> ingredientes = const []}) async {
    emit(DietasLoading());
    try {
      final recetas = casoUso.call(nombreDieta, ingredientes: ingredientes);
      emit(DietasLoaded(recetas));
    } catch (e) {
      emit(DietasError(e.toString()));
    }
  }
}
