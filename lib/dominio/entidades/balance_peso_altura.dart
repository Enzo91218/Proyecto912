class BalancePesoAltura {
  final List<RegistroPesoAlturaPunto> puntos;
  final double pesoActual;
  final double alturaActual;
  final double imc;
  final String categoria;
  final double litrosAgua;
  final int minutosIntervalo;

  BalancePesoAltura({
    required this.puntos,
    required this.pesoActual,
    required this.alturaActual,
    required this.imc,
    required this.categoria,
    required this.litrosAgua,
    required this.minutosIntervalo,
  });
}

class RegistroPesoAlturaPunto {
  final DateTime fecha;
  final double peso;
  final double altura;

  RegistroPesoAlturaPunto({
    required this.fecha,
    required this.peso,
    required this.altura,
  });
}
