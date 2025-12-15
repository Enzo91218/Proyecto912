import '../../dominio/entidades/registro_peso_altura_entidad.dart';
import '../../dominio/entidades/balance_peso_altura.dart';
import '../../dominio/repositorios/repositorio_de_registro_peso_altura.dart';
import '../../dominio/repositorios/repositorio_de_registroIMC.dart';
import 'dart:math';

class BalancePesoAlturaUC {
  final RepositorioDeRegistroPesoAltura repositorio;
  final RepositorioDeRegistroIMC repositorioIMC;

  BalancePesoAlturaUC({
    required this.repositorio,
    required this.repositorioIMC,
  });

  Future<BalancePesoAltura> ejecutar(String usuarioId) async {
    final registros = await repositorio.obtenerRegistros(usuarioId);

    if (registros.isEmpty) {
      throw Exception('No hay registros disponibles');
    }

    // Ordenar por fecha
    final registrosOrdenados = List<RegistroPesoAltura>.from(registros);
    registrosOrdenados.sort((a, b) => a.fecha.compareTo(b.fecha));

    // Obtener peso y altura actuales
    final registroActual = registrosOrdenados.last;
    final pesoActual = registroActual.peso;
    final alturaActual = registroActual.altura;

    // Obtener IMC del último registro de registros_imc
    double imc = 0.0;
    String categoria = 'Normal';
    
    print('📊 Buscando IMC de registros_imc para usuario: $usuarioId');
    try {
      final registrosIMC = await repositorioIMC.obtenerRegistros(usuarioId);
      print('📊 Se encontraron ${registrosIMC.length} registros de IMC');
      
      if (registrosIMC.isNotEmpty) {
        // Obtener el último registro de IMC (primero en la lista porque está ordenado DESC)
        final ultimoIMC = registrosIMC.first;
        imc = ultimoIMC.imc;
        categoria = ultimoIMC.categoria;
        print('✓ IMC obtenido de registros_imc: $imc ($categoria)');
      } else {
        // Si no hay registros de IMC, calcularlo desde peso/altura
        print('⚠ No hay registros de IMC, calculando desde peso ($pesoActual kg) y altura ($alturaActual m)');
        imc = _calcularIMC(pesoActual, alturaActual);
        categoria = _obtenerCategoria(imc);
        print('📊 IMC calculado: $imc ($categoria)');
      }
    } catch (e) {
      // Si hay error, calcular IMC desde peso/altura
      print('❌ Error obteniendo IMC de registros: $e');
      print('⚠ Calculando IMC desde peso ($pesoActual kg) y altura ($alturaActual m)');
      imc = _calcularIMC(pesoActual, alturaActual);
      categoria = _obtenerCategoria(imc);
      print('📊 IMC calculado como fallback: $imc ($categoria)');
    }

    // Calcular litros de agua diaria
    final litrosAgua = _calcularLitrosAgua(pesoActual);

    // Calcular intervalo en minutos
    final minutosIntervalo = _calcularIntervalo(litrosAgua);

    // Convertir a puntos para la gráfica
    final puntos = registrosOrdenados
        .map((r) => RegistroPesoAlturaPunto(
              fecha: r.fecha,
              peso: r.peso,
              altura: r.altura,
            ))
        .toList();

    return BalancePesoAltura(
      puntos: puntos,
      pesoActual: pesoActual,
      alturaActual: alturaActual,
      imc: imc,
      categoria: categoria,
      litrosAgua: litrosAgua,
      minutosIntervalo: minutosIntervalo,
    );
  }

  double _calcularIMC(double peso, double altura) {
    if (altura <= 0) {
      print('⚠ Altura inválida: $altura, retornando 0.0');
      return 0.0;
    }
    final resultado = peso / pow(altura, 2);
    print('📐 Cálculo IMC: $peso kg / ($altura m)² = $resultado');
    return resultado;
  }

  String _obtenerCategoria(double imc) {
    if (imc < 18.5) {
      return 'Bajo peso';
    } else if (imc < 25) {
      return 'Normal';
    } else if (imc < 30) {
      return 'Sobrepeso';
    } else {
      return 'Obesidad';
    }
  }

  /// Calcula los litros de agua basado en el peso
  /// Fórmula: peso en kg * 35 ml/kg = mililitros diarios
  /// Convertimos a litros: mililitros / 1000
  double _calcularLitrosAgua(double peso) {
    final mlDiarios = peso * 35;
    final litrosDiarios = mlDiarios / 1000;
    return litrosDiarios.roundToDouble();
  }

  /// Calcula el intervalo en minutos para tomar agua
  /// Basado en los litros que debe tomar (aproximadamente 8 vasos de 250ml)
  /// Se calcula: 1440 minutos / número de vasos
  int _calcularIntervalo(double litrosAgua) {
    const mlPorVaso = 250;
    const minutosPorDia = 1440;
    
    // Calcular cuántos vasos necesita tomar
    final mlTotales = litrosAgua * 1000;
    final vasosNecesarios = (mlTotales / mlPorVaso).ceil();
    
    // Calcular intervalo entre vasos
    final intervalo = (minutosPorDia / vasosNecesarios).round();
    
    return intervalo;
  }
}

extension RoundDouble on double {
  double roundToDouble() {
    return (this * 100).round() / 100;
  }
}
