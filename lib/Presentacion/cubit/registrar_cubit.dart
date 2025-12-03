import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../aplicacion/casos_de_uso/registrar_usuario.dart';
import '../../dominio/entidades/usuario.dart';
import '../../servicios/usuario_actual.dart';

abstract class RegistrarState {}
class RegistrarInitial extends RegistrarState {}
class RegistrarLoading extends RegistrarState {}
class RegistrarSuccess extends RegistrarState {
  final Usuario usuario;
  RegistrarSuccess(this.usuario);
}
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
      await casoUso.call(usuario);
      // Guardar el usuario actual después de registrarse
      GetIt.instance.get<UsuarioActual>().setUsuario(usuario);
      emit(RegistrarSuccess(usuario));
    } catch (e) {
      emit(RegistrarFailure(e.toString()));
    }
  }
}
