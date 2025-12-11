import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/dietas_cubit.dart';

class PantallaDietas extends StatefulWidget {
  const PantallaDietas({super.key});

  @override
  State<PantallaDietas> createState() => _PantallaDietasState();
}

class _PantallaDietasState extends State<PantallaDietas> {
  final TextEditingController _controller = TextEditingController();

  void _buscarDieta() {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) return;
    context.read<DietasCubit>().buscar(nombre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
          tooltip: 'Volver al menú',
        ),
        title: const Text("Buscar Dieta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Tipo de dieta (ej. keto, vegana, etc.)",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarDieta,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<DietasCubit, DietasState>(
                builder: (context, state) {
                  if (state is DietasLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DietasLoaded) {
                    return ListView.builder(
                      itemCount: state.recetas.length,
                      itemBuilder: (context, index) {
                        final receta = state.recetas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(receta.titulo),
                            subtitle: Text(receta.descripcion),
                          ),
                        );
                      },
                    );
                  } else if (state is DietasError) {
                    return Center(child: Text('Error: ${state.mensaje}'));
                  }
                  return const Center(child: Text('Busca una dieta para comenzar'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
