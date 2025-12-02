import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/entidades/balance_peso_altura.dart';
import '../../aplicacion/casos_de_uso/balance_peso_altura.dart';

part 'balance_peso_state.dart';

class BalancePesoCubit extends Cubit<BalancePesoState> {
  final BalancePesoAlturaUC casoDeUso;
  final String usuarioId;

  BalancePesoCubit({
    required this.casoDeUso,
    required this.usuarioId,
  }) : super(BalancePesoInicial());

  void cargar() {
    try {
      final balance = casoDeUso.ejecutar(usuarioId);
      emit(BalancePesoCargado(balance: balance));
    } catch (e) {
      emit(BalancePesoError(mensaje: e.toString()));
    }
  }
}
