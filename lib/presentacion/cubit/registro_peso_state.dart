part of 'registro_peso_cubit.dart';

abstract class RegistroPesoState {}

class RegistroPesoInicial extends RegistroPesoState {}

class RegistroPesoCargado extends RegistroPesoState {
  final List<RegistroPesoAltura> registros;

  RegistroPesoCargado({required this.registros});
}

class RegistroPesoError extends RegistroPesoState {
  final String mensaje;

  RegistroPesoError({required this.mensaje});
}
