import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../adaptadores/adaptadorderutinas_en_memoria.dart';
import '../../dominio/entidades/rutina.dart';

class PantallaRutinas extends StatefulWidget {
  const PantallaRutinas({Key? key}) : super(key: key);

  @override
  State<PantallaRutinas> createState() => _PantallaRutinasState();
}

class _PantallaRutinasState extends State<PantallaRutinas>
    with TickerProviderStateMixin {
  late Future<List<Rutina>> _rutinasFuture;
  late Map<String, List<bool>> _ejerciciosCompletados;
  int _diaActual = 0;

  @override
  void initState() {
    super.initState();
    _rutinasFuture = AdaptadorDeRutinasEnMemoria().obtenerRutinas();
    _ejerciciosCompletados = {};
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Rutina Semanal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
          tooltip: 'Volver al menú',
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Rutina>>(
        future: _rutinasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay rutinas disponibles.'));
          }
          final rutinas = snapshot.data!;
          return CustomScrollView(
            slivers: [
              // Indicador de progreso semanal
              SliverToBoxAdapter(
                child: _buildProgressHeader(isDark),
              ),
              // Gráfico de actividad
              SliverToBoxAdapter(
                child: _buildActivityChart(isDark),
              ),
              // Selector de días
              SliverToBoxAdapter(
                child: _buildDaySelector(isDark),
              ),
              // Rutinas
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final rutina = rutinas[index];
                    if (!_ejerciciosCompletados.containsKey(rutina.id)) {
                      _ejerciciosCompletados[rutina.id] =
                          List.filled(rutina.ejercicios.length, false);
                    }
                    return _buildRutinaCard(context, rutina, isDark);
                  },
                  childCount: rutinas.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressHeader(bool isDark) {
    final completados = _ejerciciosCompletados.values
        .fold<int>(0, (sum, list) => sum + (list.where((e) => e).length));
    final total = _ejerciciosCompletados.values
        .fold<int>(0, (sum, list) => sum + list.length);
    final porcentaje = total > 0 ? (completados / total * 100).toInt() : 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepOrange.shade400,
            Colors.orange.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progreso Semanal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$completados/$total ejercicios completados',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$porcentaje%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Completado',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: total > 0 ? completados / total : 0,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actividad de la Semana',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final dias = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                final altura = 30.0 + (index * 10);
                final isToday = index == _diaActual;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 35,
                      height: altura,
                      decoration: BoxDecoration(
                        color: isToday
                            ? Colors.deepOrange.shade400
                            : Colors.blue.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dias[index],
                      style: TextStyle(
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector(bool isDark) {
    final dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona el Día',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final isSelected = index == _diaActual;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _diaActual = index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  Colors.blue.shade400,
                                  Colors.blue.shade600,
                                ],
                              )
                            : null,
                        color: isSelected ? null : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          dias[index].substring(0, 3),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRutinaCard(
    BuildContext context,
    Rutina rutina,
    bool isDark,
  ) {
    final ejercicios = rutina.ejercicios;
    final completados = _ejerciciosCompletados[rutina.id] ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepOrange.shade300,
                      Colors.deepOrange.shade600,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${completados.where((e) => e).length}/${ejercicios.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rutina.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      rutina.descripcion,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  ejercicios.length,
                  (index) => _buildEjercicioItem(
                    rutina,
                    index,
                    ejercicios[index],
                    completados[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEjercicioItem(
    Rutina rutina,
    int index,
    String ejercicio,
    bool completado,
  ) {
    final iconos = [
      Icons.fitness_center,
      Icons.directions_run,
      Icons.accessibility,
      Icons.self_improvement,
      Icons.sports_gymnastics,
      Icons.sports_basketball,
      Icons.sports_soccer,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            final lista = _ejerciciosCompletados[rutina.id]!;
            lista[index] = !lista[index];
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: completado
                ? Colors.green.shade50
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: completado
                  ? Colors.green.shade300
                  : Colors.grey.shade300,
              width: completado ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: completado
                      ? Colors.green.shade400
                      : Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    completado ? Icons.check : iconos[index % iconos.length],
                    color: Colors.white,
                    size: completado ? 20 : 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Día ${index + 1}: $ejercicio',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: completado ? TextDecoration.lineThrough : null,
                    color: completado ? Colors.grey.shade600 : Colors.black87,
                  ),
                ),
              ),
              if (completado)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
