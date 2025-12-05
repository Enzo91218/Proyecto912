import 'package:bloc/bloc.dart';
import '../../aplicacion/casos_de_uso/publicar_receta.dart';
import '../../dominio/entidades/ingrediente.dart';

abstract class PublicarRecetaState {}
class PublicarRecetaInitial extends PublicarRecetaState {}
class PublicarRecetaLoading extends PublicarRecetaState {}
class PublicarRecetaSuccess extends PublicarRecetaState {}
class PublicarRecetaError extends PublicarRecetaState {
  final String mensaje;
  PublicarRecetaError(this.mensaje);
}

class PublicarRecetaCubit extends Cubit<PublicarRecetaState> {
  final PublicarReceta casoUso;
  PublicarRecetaCubit(this.casoUso) : super(PublicarRecetaInitial());

  void publicar({
    required String id,
    required String titulo,
    required String descripcion,
    required List<Ingrediente> ingredientes,
  }) async {
    emit(PublicarRecetaLoading());
    try {
      casoUso.ejecutar(
        id: id,
        titulo: titulo,
        descripcion: descripcion,
        ingredientes: ingredientes,
      );
      emit(PublicarRecetaSuccess());
    } catch (e) {
      emit(PublicarRecetaError('Error al publicar receta: $e'));
    }
  }
}
