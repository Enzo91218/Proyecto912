import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../dominio/entidades/ingrediente.dart';
import '../cubit/publicar_receta_cubit.dart';

class PantallaPublicarReceta extends StatefulWidget {
  const PantallaPublicarReceta({Key? key}) : super(key: key);

  @override
  State<PantallaPublicarReceta> createState() => _PantallaPublicarRecetaState();
}

class _PantallaPublicarRecetaState extends State<PantallaPublicarReceta> {
  final _formKey = GlobalKey<FormState>();
  String titulo = '';
  String descripcion = '';
  List<Ingrediente> ingredientes = [];
  final TextEditingController _ingredienteController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  String cultura = '';

  void _agregarIngrediente() {
    if (_ingredienteController.text.isNotEmpty && _cantidadController.text.isNotEmpty) {
      setState(() {
        ingredientes.add(Ingrediente(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nombre: _ingredienteController.text,
          cantidad: _cantidadController.text,
        ));
        _ingredienteController.clear();
        _cantidadController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicar Receta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
          tooltip: 'Volver al menú',
        ),
      ),
      body: BlocListener<PublicarRecetaCubit, PublicarRecetaState>(
        listener: (context, state) {
          if (state is PublicarRecetaSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Receta publicada exitosamente!')),
            );
            context.go('/');
          } else if (state is PublicarRecetaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.mensaje)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Título'),
                  onChanged: (value) => titulo = value,
                  validator: (value) => value == null || value.isEmpty ? 'Ingrese el título' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  onChanged: (value) => descripcion = value,
                  validator: (value) => value == null || value.isEmpty ? 'Ingrese la descripción' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Cultura'),
                  onChanged: (value) => cultura = value,
                  validator: (value) => value == null || value.isEmpty ? 'Ingrese la cultura' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ingredienteController,
                        decoration: const InputDecoration(labelText: 'Ingrediente'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _cantidadController,
                        decoration: const InputDecoration(labelText: 'Cantidad'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _agregarIngrediente,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...ingredientes.map((ing) => ListTile(
                  title: Text(ing.nombre),
                  subtitle: Text('Cantidad: ${ing.cantidad}'),
                )),
                const SizedBox(height: 24),
                BlocBuilder<PublicarRecetaCubit, PublicarRecetaState>(
                  builder: (context, state) {
                    if (state is PublicarRecetaLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && ingredientes.isNotEmpty) {
                          context.read<PublicarRecetaCubit>().publicar(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            titulo: titulo,
                            descripcion: descripcion,
                            ingredientes: ingredientes,
                            cultura: cultura, // <-- Agrega este argumento
                          );
                        }
                      },
                      child: const Text('Publicar Receta'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
