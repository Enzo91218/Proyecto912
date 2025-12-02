import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../dominio/entidades/balance_peso_altura.dart';
import '../cubit/balance_peso_cubit.dart';

class PantallaBalancePeso extends StatefulWidget {
  const PantallaBalancePeso({super.key});

  @override
  State<PantallaBalancePeso> createState() => _PantallaBalancePesoState();
}

class _PantallaBalancePesoState extends State<PantallaBalancePeso> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BalancePesoCubit>().cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
        title: const Text("Balance de Peso y Hidratación"),
      ),
      body: BlocBuilder<BalancePesoCubit, BalancePesoState>(
        builder: (context, state) {
          if (state is BalancePesoInicial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BalancePesoCargado) {
            final balance = state.balance;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tarjeta de datos actuales
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, -20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Datos Actuales',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _DatoActual(
                                  label: 'Peso',
                                  valor: '${balance.pesoActual.toStringAsFixed(2)} kg',
                                  icono: Icons.monitor_weight,
                                ),
                                _DatoActual(
                                  label: 'Altura',
                                  valor:
                                      '${balance.alturaActual.toStringAsFixed(2)} m',
                                  icono: Icons.height,
                                ),
                                _DatoActual(
                                  label: 'IMC',
                                  valor: balance.imc.toStringAsFixed(2),
                                  icono: Icons.calculate,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _obtenerColorCategoria(balance.categoria),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Categoría: ${balance.categoria}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tarjeta de progreso de peso
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, -20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Progreso de Peso',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 250,
                              child: _GraficoProgresoLineal(
                                puntos: balance.puntos,
                                onPuntoSeleccionado: (index) {
                                  context.read<BalancePesoCubit>().seleccionarPunto(index);
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (state.puntoSeleccionado != null)
                              _DetallePuntoSeleccionado(
                                puntos: balance.puntos,
                                indicePuntoSeleccionado: state.puntoSeleccionado!,
                                onDeseleccionar: () {
                                  context.read<BalancePesoCubit>().deseleccionarPunto();
                                },
                              )
                            else
                              _ResumenProgreso(
                                puntos: balance.puntos,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tarjeta de hidratación
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, -20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Plan de Hidratación',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.blue.shade300,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Agua diaria recomendada:',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        '${balance.litrosAgua.toStringAsFixed(2)} L',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Intervalo entre vasos:',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        '${balance.minutosIntervalo} minutos',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Divider(),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Horario sugerido de consumo:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _HorarioAgua(
                                    minutosIntervalo: balance.minutosIntervalo,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          } else if (state is BalancePesoError) {
            return Center(
              child: Text('Error: ${state.mensaje}'),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/'),
        tooltip: 'Volver al menú',
        child: const Icon(Icons.home),
      ),
    );
  }

  Color _obtenerColorCategoria(String categoria) {
    switch (categoria) {
      case 'Bajo peso':
        return Colors.orange;
      case 'Normal':
        return Colors.green;
      case 'Sobrepeso':
        return Colors.amber;
      case 'Obesidad':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _DatoActual extends StatefulWidget {
  final String label;
  final String valor;
  final IconData icono;

  const _DatoActual({
    required this.label,
    required this.valor,
    required this.icono,
  });

  @override
  State<_DatoActual> createState() => _DatoActualState();
}

class _DatoActualState extends State<_DatoActual> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: Icon(widget.icono, size: 32, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          widget.valor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _GraficoProgresoLineal extends StatelessWidget {
  final List<RegistroPesoAlturaPunto> puntos;
  final Function(int)? onPuntoSeleccionado;

  const _GraficoProgresoLineal({
    required this.puntos,
    this.onPuntoSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    if (puntos.length < 2) {
      return const Center(
        child: Text('Se necesitan al menos 2 registros para mostrar el gráfico'),
      );
    }

    return GestureDetector(
      onTapDown: (details) {
        // Calcular qué punto fue tocado
        final painter = _GraficoPainter(puntos);
        final posicion = details.localPosition;
        final indice = painter.obtenerIndicePuntoEnPosicion(posicion);
        if (indice != -1) {
          onPuntoSeleccionado?.call(indice);
        }
      },
      child: CustomPaint(
        painter: _GraficoPainter(puntos),
        child: Container(),
      ),
    );
  }
}

class _GraficoPainter extends CustomPainter {
  final List<RegistroPesoAlturaPunto> puntos;

  _GraficoPainter(this.puntos);

  List<Offset> posicionesPuntos = [];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final circlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    // Encontrar min y max de peso
    final pesos = puntos.map((p) => p.peso).toList();
    final pesoMin = pesos.reduce((a, b) => a < b ? a : b);
    final pesoMax = pesos.reduce((a, b) => a > b ? a : b);
    final diferencia = pesoMax - pesoMin == 0 ? 1 : pesoMax - pesoMin;

    // Dibujar líneas de referencia
    const padding = 40.0;
    final graphWidth = size.width - 2 * padding;
    final graphHeight = size.height - 2 * padding;

    // Dibujar ejes
    canvas.drawLine(
      Offset(padding, size.height - padding),
      Offset(size.width - padding, size.height - padding),
      linePaint,
    );
    canvas.drawLine(
      Offset(padding, padding),
      Offset(padding, size.height - padding),
      linePaint,
    );

    posicionesPuntos.clear();

    // Dibujar línea del gráfico
    for (int i = 0; i < puntos.length - 1; i++) {
      final x1 = padding + (i / (puntos.length - 1)) * graphWidth;
      final y1 = size.height -
          padding -
          ((puntos[i].peso - pesoMin) / diferencia) * graphHeight;

      final x2 = padding + ((i + 1) / (puntos.length - 1)) * graphWidth;
      final y2 = size.height -
          padding -
          ((puntos[i + 1].peso - pesoMin) / diferencia) * graphHeight;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // Dibujar puntos
    for (int i = 0; i < puntos.length; i++) {
      final x = padding + (i / (puntos.length - 1)) * graphWidth;
      final y = size.height -
          padding -
          ((puntos[i].peso - pesoMin) / diferencia) * graphHeight;

      posicionesPuntos.add(Offset(x, y));

      canvas.drawCircle(Offset(x, y), 4, circlePaint);
    }
  }

  int obtenerIndicePuntoEnPosicion(Offset posicion) {
    const tolerancia = 20.0;
    for (int i = 0; i < posicionesPuntos.length; i++) {
      final distancia = (posicion - posicionesPuntos[i]).distance;
      if (distancia < tolerancia) {
        return i;
      }
    }
    return -1;
  }

  @override
  bool shouldRepaint(_GraficoPainter oldDelegate) => false;
}

class _ResumenProgreso extends StatelessWidget {
  final List<RegistroPesoAlturaPunto> puntos;

  const _ResumenProgreso({required this.puntos});

  @override
  Widget build(BuildContext context) {
    if (puntos.length < 2) {
      return const SizedBox();
    }

    final pesoInicial = puntos.first.peso;
    final pesoActual = puntos.last.peso;
    final diferencia = pesoActual - pesoInicial;
    final porcentaje = (diferencia / pesoInicial * 100);

    return Column(
      children: [
        Text(
          'Peso inicial: ${pesoInicial.toStringAsFixed(2)} kg',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          'Peso actual: ${pesoActual.toStringAsFixed(2)} kg',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          'Cambio: ${diferencia > 0 ? '+' : ''}${diferencia.toStringAsFixed(2)} kg (${porcentaje > 0 ? '+' : ''}${porcentaje.toStringAsFixed(2)}%)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: diferencia > 0 ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}

class _HorarioAgua extends StatelessWidget {
  final int minutosIntervalo;

  const _HorarioAgua({required this.minutosIntervalo});

  @override
  Widget build(BuildContext context) {
    final horas = <String>[];
    int horaActual = 6; // Comenzar a las 6:00 AM
    int minutoActual = 0;

    for (int i = 0; i < 8; i++) {
      horas.add(
          '${horaActual.toString().padLeft(2, '0')}:${minutoActual.toString().padLeft(2, '0')}');

      minutoActual += minutosIntervalo;
      if (minutoActual >= 60) {
        horaActual += minutoActual ~/ 60;
        minutoActual = minutoActual % 60;
      }
      if (horaActual >= 23) break;
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        horas.length,
        (index) => TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (index * 100)),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              horas[index],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetallePuntoSeleccionado extends StatelessWidget {
  final List<RegistroPesoAlturaPunto> puntos;
  final int indicePuntoSeleccionado;
  final VoidCallback onDeseleccionar;

  const _DetallePuntoSeleccionado({
    required this.puntos,
    required this.indicePuntoSeleccionado,
    required this.onDeseleccionar,
  });

  @override
  Widget build(BuildContext context) {
    if (indicePuntoSeleccionado < 0 || indicePuntoSeleccionado >= puntos.length) {
      return const SizedBox();
    }

    final punto = puntos[indicePuntoSeleccionado];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Datos del Punto Seleccionado',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onDeseleccionar,
                tooltip: 'Deseleccionar',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Peso',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${punto.peso.toStringAsFixed(2)} kg',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Altura',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${punto.altura.toStringAsFixed(2)} m',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Fecha',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${punto.fecha.day}/${punto.fecha.month}/${punto.fecha.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
