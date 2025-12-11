import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/registro_peso_cubit.dart';

class PantallaRegistroPeso extends StatefulWidget {
  const PantallaRegistroPeso({super.key});

  @override
  State<PantallaRegistroPeso> createState() => _PantallaRegistroPesoState();
}

class _PantallaRegistroPesoState extends State<PantallaRegistroPeso> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegistroPesoCubit>().cargar();
    });
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
        title: const Text("Registro de Peso y Altura"),
      ),
      body: BlocBuilder<RegistroPesoCubit, RegistroPesoState>(
        builder: (context, state) {
          if (state is RegistroPesoInicial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RegistroPesoCargado) {
            if (state.registros.isEmpty) {
              return const Center(child: Text('No hay registros de peso y altura'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: state.registros.length,
              itemBuilder: (context, index) {
                final registro = state.registros[index];
                final fechaFormato = '${registro.fecha.day}/${registro.fecha.month}/${registro.fecha.year}';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.monitor_weight),
                    title: Text('Peso: ${registro.peso.toStringAsFixed(2)} kg'),
                    subtitle: Text('Altura: ${registro.altura.toStringAsFixed(2)} m\nFecha: $fechaFormato'),
                  ),
                );
              },
            );
          } else if (state is RegistroPesoError) {
            return Center(child: Text('Error: ${state.mensaje}'));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: null,
    );
  }
}
