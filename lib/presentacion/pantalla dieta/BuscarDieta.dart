import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/dietas_cubit.dart';

class PantallaDietas extends StatefulWidget {
  const PantallaDietas({super.key});

  @override
  State<PantallaDietas> createState() => _PantallaDietasState();
}

class _PantallaDietasState extends State<PantallaDietas> {
  @override
  void initState() {
    super.initState();
    // Cargar dietas disponibles al iniciar
    context.read<DietasCubit>().cargarDietasDisponibles();
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
        focusNode: FocusNode(),
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
            title: const Text("Seleccionar Dieta"),
          ),
          body: BlocBuilder<DietasCubit, DietasState>(
            builder: (context, state) {
              if (state is DietasLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DietasDisponiblesLoaded) {
                // Mostrar opciones de dietas disponibles
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selecciona una dieta:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: state.dietas.length,
                          itemBuilder: (context, index) {
                            final dieta = state.dietas[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () {
                                  context.read<DietasCubit>().seleccionarDieta(
                                    dieta,
                                    state.dietas,
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getIconForDieta(dieta.nombre),
                                      size: 48,
                                      color: Colors.green.shade700,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      dieta.nombre,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is DietasLoaded) {
                // Mostrar recetas de la dieta seleccionada
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.green.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Dieta: ${state.dietaSeleccionada}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  context
                                      .read<DietasCubit>()
                                      .cargarDietasDisponibles();
                                },
                                tooltip: 'Volver a seleccionar dieta',
                              ),
                            ],
                          ),
                          if (state.clasificaciones != null &&
                              state.clasificaciones!.isNotEmpty)
                            Text(
                              'Gemini clasificó ${state.clasificaciones!.length} recetas',
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.recetas.length,
                        itemBuilder: (context, index) {
                          final receta = state.recetas[index];
                          final dietaClasificada =
                              state.clasificaciones?[receta];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              title: Text(receta.titulo),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(receta.descripcion),
                                  if (dietaClasificada != null) ...[
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Clasificada: $dietaClasificada',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is DietasError) {
                return Center(child: Text('Error: ${state.mensaje}'));
              }
              return const Center(child: Text('Cargando dietas...'));
            },
          ),
        ),
      ),
    );
  }

  IconData _getIconForDieta(String nombre) {
    final nombreLower = nombre.toLowerCase();
    if (nombreLower.contains('vegana') || nombreLower.contains('vegetariana')) {
      return Icons.eco;
    } else if (nombreLower.contains('keto')) {
      return Icons.restaurant_menu;
    } else if (nombreLower.contains('balanceada')) {
      return Icons.balance;
    }
    return Icons.fastfood;
  }
}
