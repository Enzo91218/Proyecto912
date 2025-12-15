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
  String? _culturaSeleccionada;
  List<String> _culturas = ['Todas'];

  @override
  void initState() {
    super.initState();
    // Cargar culturas de la BD cuando se inicia la pantalla
    context.read<RecetasCubit>().cargarCulturas();
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

  void _buscarPorCultura(String? cultura) {
    if (cultura == null || cultura == 'Todas') {
      context.read<RecetasCubit>().buscar([]);
    } else {
      context.read<RecetasCubit>().buscarPorCultura(cultura);
    }
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
        title: const Text("Buscar Receta"),
      ),
      body: BlocListener<RecetasCubit, RecetasState>(
        listener: (context, state) {
          if (state is RecetaAleatoriaLoaded) {
            final receta = state.receta;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Row(
                  children: [
                    const Icon(Icons.casino, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text('Receta Aleatoria'),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receta.titulo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(receta.descripcion),
                      const SizedBox(height: 12),
                      Text(
                        'Cultura: ${receta.cultura}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Ingredientes:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      ...receta.ingredientes
                          .map((i) => Padding(
                                padding: const EdgeInsets.only(left: 8, top: 4),
                                child: Text('• ${i.nombre} (${i.cantidad})'),
                              ))
                          .toList(),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            );
          } else if (state is RecetasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.mensaje),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Dropdown de culturas que se actualiza desde el Cubit
              BlocBuilder<RecetasCubit, RecetasState>(
                builder: (context, state) {
                  if (state is CulturasLoaded) {
                    _culturas = state.culturas;
                  }
                  
                  return PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        _culturaSeleccionada = value;
                      });
                      _buscarPorCultura(value);
                    },
                    itemBuilder: (context) => _culturas
                        .map((cultura) => PopupMenuItem<String>(
                              value: cultura,
                              child: Row(
                                children: [
                                  Icon(
                                    _culturaSeleccionada == cultura
                                        ? Icons.check_circle
                                        : Icons.public,
                                    color: _culturaSeleccionada == cultura
                                        ? Colors.blue
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    cultura,
                                    style: TextStyle(
                                      fontWeight: _culturaSeleccionada == cultura
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.public, color: Colors.grey),
                              const SizedBox(width: 12),
                              Text(
                                _culturaSeleccionada ?? 'Selecciona una cultura',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _culturaSeleccionada != null
                                      ? Colors.black87
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Buscar por ingredientes (separados por coma)",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _buscarReceta,
                  ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Botón de receta aleatoria
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<RecetasCubit>().mostrarAleatoria();
                },
                icon: const Icon(Icons.casino),
                label: const Text('Sorpréndeme con una receta aleatoria'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                                Text(
                                  'Cultura: ${r.cultura}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
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
                  return const Center(child: Text('Selecciona una cultura o busca por ingredientes'));
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
