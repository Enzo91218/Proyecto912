import 'package:bloc/bloc.dart';
import '../../aplicacion/casos_de_uso/buscar_usuarios.dart';
import '../../dominio/entidades/usuario.dart';

abstract class LoginState {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final Usuario usuario;
  LoginSuccess(this.usuario);
}
class LoginFailure extends LoginState {
  final String mensaje;
  LoginFailure(this.mensaje);
}

class LoginCubit extends Cubit<LoginState> {
  final BuscarUsuarios casoUso;
  LoginCubit(this.casoUso) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final usuarios = casoUso.call();
      final encontrado = usuarios.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
        orElse: () => throw StateError('Credenciales inválidas'),
      );
      emit(LoginSuccess(encontrado));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
