import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/recetas_cubit.dart';
import '../../dominio/entidades/ingrediente.dart';

class PantallaRecetas extends StatefulWidget {
  const PantallaRecetas({super.key});

  @override
  State<PantallaRecetas> createState() => _PantallaRecetasState();
}

class _PantallaRecetasState extends State<PantallaRecetas> {
  final TextEditingController _controller = TextEditingController();
  String resultado = "";
  String? culturaSeleccionada;
  List<String> culturasDisponibles = [];

  @override
  void initState() {
    super.initState();
    // Obtener culturas únicas del repositorio
    final recetas = context.read<RecetasCubit>().casoUso.repositorio.recetasConIngredientes([]);
    culturasDisponibles = recetas.map((r) => r.cultura).toSet().toList();
    culturasDisponibles.sort();
  }

  void _buscarReceta() {
    final ingredientes = _controller.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map((s) => Ingrediente(id: s, nombre: s, cantidad: 'a gusto'))
        .toList();
    context.read<RecetasCubit>().buscar(ingredientes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
        title: const Text("Buscar Receta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Ingrese uno o más ingredientes",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarReceta,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Filtrar por cultura: "),
                Expanded(
                  child: DropdownButton<String>(
                    value: culturaSeleccionada,
                    hint: const Text("Selecciona una cultura"),
                    isExpanded: true,
                    items: culturasDisponibles.map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        culturaSeleccionada = value;
                      });
                      if (value != null) {
                        // Filtrar recetas por cultura usando el caso de uso
                        final filtrar = context.read<RecetasCubit>().casoUso.repositorio.recetasPorCultura;
                        final recetasFiltradas = filtrar(value);
                        context.read<RecetasCubit>().emit(RecetasLoaded(recetasFiltradas));
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            BlocBuilder<RecetasCubit, RecetasState>(builder: (context, state) {
              if (state is RecetasLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RecetasLoaded) {
                return Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: state.recetas.map((r) => ListTile(
                      title: Text(r.titulo),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.descripcion),
                          const SizedBox(height: 4),
                          Text(
                            'Ingredientes:',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...r.ingredientes.map((ing) => Text('- ${ing.nombre} (${ing.cantidad})')).toList(),
                        ],
                      ),
                    )).toList(),
                  ),
                );
              } else if (state is RecetasError) {
                return Text('Error: ${state.mensaje}');
              }
              return Text(resultado, style: const TextStyle(fontSize: 18));
            }),
            const Spacer(),
            BlocConsumer<RecetasCubit, RecetasState>(
              listener: (context, state) {
                if (state is RecetaAleatoriaLoaded) {
                  final receta = state.receta;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Receta Aleatoria'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(receta.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(receta.descripcion),
                            const SizedBox(height: 8),
                            const Text('Ingredientes:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...receta.ingredientes.map((i) => Text('- ${i.nombre} (${i.cantidad})')).toList(),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (state is RecetasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.mensaje)),
                  );
                }
              },
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Volver al Menú"),
                      onPressed: () => context.go('/'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.monitor_weight),
                      label: const Text("Calcular IMC"),
                      onPressed: () => context.go('/imc'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("Publicar Receta"),
                      onPressed: () => context.go('/publicar-receta'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.casino),
                      label: const Text('Receta aleatoria'),
                      onPressed: () {
                        context.read<RecetasCubit>().mostrarAleatoria();
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
