import 'package:bloc/bloc.dart';
import '../../aplicacion/casos_de_uso/calcular_imc.dart';
import '../../dominio/entidades/resultado_imc.dart';

abstract class IMCState {}
class IMCInitial extends IMCState {}
class IMCLoading extends IMCState {}
class IMCLoaded extends IMCState {
  final List<ResultadoIMC> registros;
  IMCLoaded(this.registros);
}
class IMCError extends IMCState {
  final String mensaje;
  IMCError(this.mensaje);
}

class IMCCubit extends Cubit<IMCState> {
  final CalcularIMC casoUso;
  IMCCubit(this.casoUso) : super(IMCInitial());

  Future<void> cargar() async {
    emit(IMCLoading());
    try {
      final regs = await casoUso.call();
      emit(IMCLoaded(regs));
    } catch (e) {
      emit(IMCError(e.toString()));
    }
  }
}
