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
  final String usuarioId;
  
  IMCCubit(this.casoUso, {required this.usuarioId}) : super(IMCInitial());

  Future<void> cargar() async {
    emit(IMCLoading());
    try {
      print('📥 IMCCubit: Cargando registros para usuario: $usuarioId');
      final regs = await casoUso.repositorio.obtenerRegistros(usuarioId);
      print('✓ IMCCubit: Se cargaron ${regs.length} registros');
      emit(IMCLoaded(regs));
    } catch (e) {
      print('❌ IMCCubit Error: $e');
      emit(IMCError(e.toString()));
    }
  }

  Future<void> guardarRegistro(String usuarioId, double imc, String categoria) async {
    try {
      print('📥 Cubit: Guardando IMC para usuario $usuarioId: $imc, categoría: $categoria');
      await casoUso.repositorio.guardarRegistroIMC(usuarioId, imc, categoria);
      print('✅ Cubit: IMC guardado. Recargando...');
      // Recargar lista
      await cargar();
    } catch (e) {
      print('❌ Cubit Error: $e');
      emit(IMCError('Error al guardar: $e'));
    }
  }}