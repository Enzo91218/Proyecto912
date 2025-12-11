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
                labelText: "Ingrese ingredientes separados por coma",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarReceta,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<RecetasCubit, RecetasState>(
                builder: (context, state) {
                  if (state is RecetasLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RecetasLoaded) {
                    return ListView.builder(
                      itemCount: state.recetas.length,
                      itemBuilder: (context, index) {
                        final r = state.recetas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(r.titulo),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.descripcion),
                                const SizedBox(height: 4),
                                const Text('Ingredientes:', style: TextStyle(fontWeight: FontWeight.bold)),
                                ...r.ingredientes.map((ing) => Text('- ${ing.nombre} (${ing.cantidad})')).toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is RecetasError) {
                    return Center(child: Text('Error: ${state.mensaje}'));
                  }
                  return const Center(child: Text('Busca recetas por ingredientes'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
