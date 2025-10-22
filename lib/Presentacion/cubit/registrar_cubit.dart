import 'package:bloc/bloc.dart';
import '../../aplicacion/casos_de_uso/registrar_usuario.dart';
import '../../dominio/entidades/usuario.dart';

abstract class RegistrarState {}
class RegistrarInitial extends RegistrarState {}
class RegistrarLoading extends RegistrarState {}
class RegistrarSuccess extends RegistrarState {}
class RegistrarFailure extends RegistrarState {
  final String mensaje;
  RegistrarFailure(this.mensaje);
}

class RegistrarCubit extends Cubit<RegistrarState> {
  final RegistrarUsuario casoUso;
  RegistrarCubit(this.casoUso) : super(RegistrarInitial());

  Future<void> registrar(Usuario usuario) async {
    emit(RegistrarLoading());
    try {
      casoUso.call(usuario);
      emit(RegistrarSuccess());
    } catch (e) {
      emit(RegistrarFailure(e.toString()));
    }
  }
}
