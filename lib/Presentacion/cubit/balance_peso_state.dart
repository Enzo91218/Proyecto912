part of 'balance_peso_cubit.dart';

abstract class BalancePesoState {}

class BalancePesoInicial extends BalancePesoState {}

class BalancePesoCargado extends BalancePesoState {
  final BalancePesoAltura balance;

  BalancePesoCargado({required this.balance});
}

class BalancePesoError extends BalancePesoState {
  final String mensaje;

  BalancePesoError({required this.mensaje});
}
