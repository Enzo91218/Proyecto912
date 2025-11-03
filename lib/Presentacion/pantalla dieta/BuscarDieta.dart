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
  String resultado = "";

  void _buscarDieta() {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) return;
    context.read<DietasCubit>().buscar(nombre);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarDieta,
                ),
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<DietasCubit, DietasState>(builder: (context, state) {
              if (state is DietasLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DietasLoaded) {
                return Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: state.recetas
                        .map((r) => ListTile(title: Text(r.titulo), subtitle: Text(r.descripcion)))
                        .toList(),
                  ),
                );
              } else if (state is DietasError) {
                return Text('Error: ${state.mensaje}');
              }
              return Text(resultado, style: const TextStyle(fontSize: 18));
            }),
            const Spacer(),
            Row(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
