import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late FocusNode _keyboardFocusNode;

  @override
  void initState() {
    super.initState();
    _keyboardFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BalancePesoCubit>().cargar();
    });
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          context.go('/');
        }
      },
      child: RawKeyboardListener(
        focusNode: _keyboardFocusNode,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
            context.go('/');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
              tooltip: 'Volver al menú',
            ),
            title: const Text("Balance de Peso y Hidratación"),
          ),
          body: BlocBuilder<BalancePesoCubit, BalancePesoState>(
            builder: (context, state) {
              if (state is BalancePesoInicial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BalancePesoCargado) {
                final balance = state.balance;

                // Calcular hidratación basada en el peso ACTUAL (del último registro)
                final pesoActualBalance = balance.pesoActual;
                final aguaDiariaML = (pesoActualBalance * 35).toInt();
                final aguaDiariaL = (aguaDiariaML / 1000).toStringAsFixed(2);
                final vasosPorDia = (aguaDiariaML / 250).toStringAsFixed(1);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tarjeta de datos actuales
                      _buildDatosActualesCard(balance),
                      const SizedBox(height: 16),

                      // Sección de Hidratación
                      _buildSeccionHidratacion(
                        pesoActualBalance,
                        aguaDiariaML,
                        aguaDiariaL,
                        vasosPorDia,
                      ),
                      const SizedBox(height: 16),

                      // Gráfica simple de progreso de peso
                      _buildGraficaPeso(balance),
                      const SizedBox(height: 16),

                      // Historial de registros
                      _buildHistorialRegistros(balance),
                    ],
                  ),
                );
              } else if (state is BalancePesoError) {
                return Center(child: Text('Error: ${state.mensaje}'));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDatosActualesCard(BalancePesoAltura balance) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos Actuales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  'Peso',
                  '${balance.pesoActual.toStringAsFixed(1)} kg',
                  Colors.blue,
                ),
                _buildStatItem(
                  'Altura',
                  '${balance.alturaActual.toStringAsFixed(2)} cm',
                  Colors.green,
                ),
                _buildStatItem(
                  'IMC',
                  balance.imc.toStringAsFixed(1),
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: _getCategoryColor(balance.categoria).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Categoría: ${balance.categoria}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getCategoryColor(balance.categoria),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionHidratacion(
    double peso,
    int mlDiarios,
    String litrosDiarios,
    String vasos,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plan de Hidratación Personalizado',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Card principal de hidratación
        Card(
          elevation: 2,
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Basado en tu peso',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  '$litrosDiarios L',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '($mlDiarios ml aprox.)',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Fórmula: 35 ml × $peso kg = $mlDiarios ml',
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Intervalo recomendado
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Intervalo Recomendado',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '200-300 ml cada 1 hora\n(o cada 45 minutos si haces ejercicio)',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                Text(
                  '$vasos vasos de 250 ml por día',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Ejemplo de distribución
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ejemplo de Distribución',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildHorarioAgua(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorarioAgua() {
    final horarios = [
      '8:00',
      '9:00',
      '10:00',
      '11:00',
      '13:00',
      '15:00',
      '17:00',
      '19:00',
    ];

    return Column(
      children:
          horarios
              .map(
                (hora) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          hora,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.water_drop,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      const Text('300 ml', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildGraficaPeso(BalancePesoAltura balance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progreso de Peso',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (balance.puntos.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No hay registros de peso aún',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: _CustomLineChart(balance.puntos),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatInfo(
                            'Peso Inicial',
                            '${balance.puntos.first.peso.toStringAsFixed(1)} kg',
                          ),
                          _buildStatInfo(
                            'Peso Actual',
                            '${balance.puntos.last.peso.toStringAsFixed(1)} kg',
                          ),
                          _buildStatInfo(
                            'Diferencia',
                            '${(balance.puntos.last.peso - balance.puntos.first.peso).abs().toStringAsFixed(1)} kg',
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorialRegistros(BalancePesoAltura balance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial de Registros',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (balance.puntos.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No hay registros aún',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          )
        else
          ...balance.puntos.asMap().entries.map((entry) {
            final index = entry.key;
            final punto = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text('${index + 1}'),
                ),
                title: Text('Peso: ${punto.peso.toStringAsFixed(2)} kg'),
                subtitle: Text(
                  'Altura: ${punto.altura.toStringAsFixed(2)} m\n'
                  '${punto.fecha.day}/${punto.fecha.month}/${punto.fecha.year}',
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
          ),
          child: Icon(Icons.trending_up, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStatInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Color _getCategoryColor(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return Colors.blue;
      case 'normal':
        return Colors.green;
      case 'sobrepeso':
        return Colors.orange;
      case 'obesidad':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _CustomLineChart extends StatelessWidget {
  final List<dynamic> puntos;

  const _CustomLineChart(this.puntos);

  @override
  Widget build(BuildContext context) {
    if (puntos.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomPaint(painter: _LineChartPainter(puntos), size: Size.infinite);
  }
}

class _LineChartPainter extends CustomPainter {
  final List<dynamic> puntos;

  _LineChartPainter(this.puntos);

  @override
  void paint(Canvas canvas, Size size) {
    if (puntos.isEmpty) return;

    final paint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 2;

    final pointPaint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 6;

    final gridPaint =
        Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..strokeWidth = 0.5;

    // Encontrar min y max de peso
    final pesos = puntos.map((p) => p.peso as double).toList();
    final minPeso = pesos.reduce((a, b) => a < b ? a : b);
    final maxPeso = pesos.reduce((a, b) => a > b ? a : b);
    final rango = maxPeso - minPeso;

    final xSpacing =
        size.width / (puntos.length - 1 > 0 ? puntos.length - 1 : 1);
    final yPadding = 20.0;

    // Dibujar líneas de grid horizontales
    for (int i = 0; i <= 4; i++) {
      final y = yPadding + (size.height - 2 * yPadding) * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Dibujar puntos y líneas
    for (int i = 0; i < puntos.length; i++) {
      final x = i * xSpacing;
      final normalizedWeight = rango > 0 ? (pesos[i] - minPeso) / rango : 0.5;
      final y =
          yPadding + (size.height - 2 * yPadding) * (1 - normalizedWeight);

      if (i < puntos.length - 1) {
        final nextX = (i + 1) * xSpacing;
        final nextNormalizedWeight =
            rango > 0 ? (pesos[i + 1] - minPeso) / rango : 0.5;
        final nextY =
            yPadding +
            (size.height - 2 * yPadding) * (1 - nextNormalizedWeight);

        canvas.drawLine(Offset(x, y), Offset(nextX, nextY), paint);
      }

      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) => false;
}
