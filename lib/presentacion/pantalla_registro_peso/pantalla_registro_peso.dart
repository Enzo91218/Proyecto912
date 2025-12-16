import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/registro_peso_cubit.dart';

class PantallaRegistroPeso extends StatefulWidget {
  const PantallaRegistroPeso({super.key});

  @override
  State<PantallaRegistroPeso> createState() => _PantallaRegistroPesoState();
}

class _PantallaRegistroPesoState extends State<PantallaRegistroPeso> {
  late FocusNode _keyboardFocusNode;

  @override
  void initState() {
    super.initState();
    _keyboardFocusNode = FocusNode();
    // cargar() se ejecuta en el router
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
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
        focusNode: _keyboardFocusNode,
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
            title: const Text("Registro de Peso y Altura"),
          ),
          body: BlocBuilder<RegistroPesoCubit, RegistroPesoState>(
            builder: (context, state) {
              if (state is RegistroPesoInicial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RegistroPesoCargado) {
                if (state.registros.isEmpty) {
                  return const Center(
                    child: Text('No hay registros de peso y altura'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: state.registros.length,
                  itemBuilder: (context, index) {
                    final registro = state.registros[index];
                    final fechaFormato =
                        '${registro.fecha.day}/${registro.fecha.month}/${registro.fecha.year}';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.monitor_weight),
                        title: Text(
                          'Peso: ${registro.peso.toStringAsFixed(2)} kg',
                        ),
                        subtitle: Text(
                          'Altura: ${(registro.altura > 10 ? registro.altura : registro.altura * 100).toStringAsFixed(0)} cm\nFecha: $fechaFormato',
                        ),
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
        ),
      ),
    );
  }
}
