import 'package:bloc/bloc.dart';
import '../../aplicacion/casos_de_uso/registrar_usuario.dart';
import '../../dominio/entidades/usuario.dart';
import '../../dominio/entidades/registro_peso_altura_entidad.dart';
import '../../dominio/repositorios/repositorio_de_registro_peso_altura.dart';

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
  final RepositorioDeRegistroPesoAltura repositorioPeso;
  
  RegistrarCubit(this.casoUso, this.repositorioPeso) : super(RegistrarInitial());

  Future<void> registrar(Usuario usuario) async {
    emit(RegistrarLoading());
    try {
      // Registrar el usuario
      await casoUso.call(usuario);
      
      // Guardar el peso y altura inicial en registros_peso_altura
      print('📝 Guardando peso/altura inicial para usuario ${usuario.id}');
      await repositorioPeso.agregarRegistro(
        RegistroPesoAltura(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          usuarioId: usuario.id,
          peso: usuario.peso,
          altura: usuario.altura,
          fecha: DateTime.now(),
        ),
      );
      
      print('✅ Peso/altura guardado en registros_peso_altura');
      emit(RegistrarSuccess());
    } catch (e) {
      print('❌ Error al registrar: $e');
      emit(RegistrarFailure(e.toString()));
    }
  }
}
