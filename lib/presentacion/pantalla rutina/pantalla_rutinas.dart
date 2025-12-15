import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../dominio/entidades/rutina.dart';
import '../cubit/rutinas_cubit.dart';
import '../../dominio/repositorios/repositorio_de_rutinas.dart';

class PantallaRutinas extends StatefulWidget {
  const PantallaRutinas({Key? key}) : super(key: key);

  @override
  State<PantallaRutinas> createState() => _PantallaRutinasState();
}

class _PantallaRutinasState extends State<PantallaRutinas> {
  final Map<String, Map<int, bool>> _diasCompletados = {};

  @override
  void initState() {
    super.initState();
    print('🖥️ PantallaRutinas: initState llamado');
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 PantallaRutinas: build llamado');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutinas Alimenticias'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RutinasCubit, RutinasState>(
        builder: (context, state) {
          print('🔄 PantallaRutinas: BlocBuilder llamado - Estado: ${state.runtimeType}');
          if (state is RutinasLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RutinasLoaded) {
            final rutinas = state.rutinas;
            
            if (rutinas.isEmpty) {
              return const Center(
                child: Text('No hay rutinas alimenticias disponibles'),
              );
            }

            for (var rutina in rutinas) {
              if (!_diasCompletados.containsKey(rutina.id)) {
                _diasCompletados[rutina.id] = {};
                for (int dia = 1; dia <= 7; dia++) {
                  _diasCompletados[rutina.id]![dia] = false;
                }
              }
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rutinas.length,
              itemBuilder: (context, index) {
                final rutina = rutinas[index];
                return _buildRutinaCard(rutina);
              },
            );
          } else if (state is RutinasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.mensaje,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<RutinasCubit>().cargar(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Cargando rutinas...'));
        },
      ),
    );
  }

  Widget _buildRutinaCard(Rutina rutina) {
    // Calcular días completados basado en los alimentos de la BD
    final diasCompletados = <int, bool>{};
    for (int dia = 1; dia <= 7; dia++) {
      // Un día se considera completado si todos sus alimentos están completados
      final alimentosDelDia = rutina.alimentos.where((a) => a.dia == dia).toList();
      if (alimentosDelDia.isEmpty) {
        diasCompletados[dia] = false;
      } else {
        diasCompletados[dia] = alimentosDelDia.every((a) => a.completada);
      }
    }
    
    final totalCompletados = diasCompletados.values.where((e) => e).length;
    final porcentaje = ((totalCompletados / 7) * 100).toInt();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: porcentaje == 100 ? Colors.green : Colors.blue,
          child: Text(
            '$totalCompletados/7',
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
        title: Text(
          rutina.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rutina.descripcion),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: totalCompletados / 7,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                porcentaje == 100 ? Colors.green : Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Progreso: $porcentaje%',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plan Semanal:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  7,
                  (dia) => _buildDiaItem(rutina, dia + 1, diasCompletados[dia + 1]!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaItem(Rutina rutina, int dia, bool completado) {
    final dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    final alimentosDelDia = rutina.alimentos.where((a) => a.dia == dia).toList();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () async {
          // Obtener el estado actual del primer alimento del día
          final estadoActual = alimentosDelDia.isNotEmpty ? alimentosDelDia.first.completada : completado;
          
          // Actualizar en BD
          final repositorio = GetIt.instance.get<RepositorioDeRutinas>();
          await repositorio.marcarDiaCompletado(rutina.id, dia, !estadoActual);
          
          // Recargar rutinas
          if (mounted) {
            context.read<RutinasCubit>().cargar();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: completado ? Colors.green.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: completado ? Colors.green : Colors.grey.shade300,
              width: completado ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: completado ? Colors.green : Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        completado ? Icons.check : Icons.restaurant_menu,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      dias[dia - 1],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: completado ? TextDecoration.lineThrough : null,
                        color: completado ? Colors.grey : Colors.black87,
                      ),
                    ),
                  ),
                  if (completado)
                    const Icon(Icons.check_circle, color: Colors.green, size: 24),
                ],
              ),
              if (alimentosDelDia.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                ...alimentosDelDia.map((alimento) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: completado ? Colors.grey : Colors.blue.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        alimento.horario,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: completado ? Colors.grey : Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${alimento.alimento} - ${alimento.cantidad}',
                          style: TextStyle(
                            fontSize: 13,
                            color: completado ? Colors.grey : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ] else ...[
                const SizedBox(height: 8),
                Text(
                  'Sin alimentos registrados para este día',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
