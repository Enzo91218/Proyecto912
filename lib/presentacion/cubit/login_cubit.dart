import 'package:bloc/bloc.dart';
import '../../aplicacion/casos_de_uso/buscar_usuarios.dart';
import '../../dominio/entidades/usuario.dart';
import '../../servicios/usuario_actual.dart';
import 'package:get_it/get_it.dart';

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
      // Validar que los campos no estén vacíos
      if (email.isEmpty || password.isEmpty) {
        emit(LoginFailure('Por favor completa todos los campos'));
        return;
      }

      final usuarios = await casoUso.call();

      // Si no hay usuarios en la BD
      if (usuarios.isEmpty) {
        emit(
          LoginFailure(
            'No hay usuarios registrados. Por favor registrate primero.',
          ),
        );
        return;
      }

      // Buscar el usuario con las credenciales proporcionadas
      final encontrado = usuarios.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.toLowerCase() &&
            u.password == password,
        orElse: () => throw Exception('Email o contraseña incorrectos'),
      );

      // Guardar usuario actual en el servicio
      GetIt.instance.get<UsuarioActual>().setUsuario(encontrado);
      emit(LoginSuccess(encontrado));
    } catch (e) {
      final mensaje = e.toString();
      if (mensaje.contains('Email o contraseña')) {
        emit(LoginFailure('Email o contraseña incorrectos'));
      } else {
        emit(LoginFailure('Error: ${e.toString()}'));
      }
    }
  }
}
