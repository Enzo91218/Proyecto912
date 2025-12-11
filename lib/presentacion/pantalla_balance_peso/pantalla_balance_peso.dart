import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../dominio/entidades/balance_peso_altura.dart';
import '../cubit/balance_peso_cubit.dart';

class PantallaBalancePeso extends StatefulWidget {
  const PantallaBalancePeso({super.key});

  @override
  State<PantallaBalancePeso> createState() => _PantallaBalancePesoState();
}

class _PantallaBalancePesoState extends State<PantallaBalancePeso> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BalancePesoCubit>().cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
        title: const Text("Balance de Peso y Hidratación"),
      ),
      body: BlocBuilder<BalancePesoCubit, BalancePesoState>(
        builder: (context, state) {
          if (state is BalancePesoInicial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BalancePesoCargado) {
            final balance = state.balance;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Datos actuales
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Datos Actuales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Text('Peso: ${balance.pesoActual.toStringAsFixed(2)} kg'),
                          Text('Altura: ${balance.alturaActual.toStringAsFixed(2)} m'),
                          Text('IMC: ${balance.imc.toStringAsFixed(2)}'),
                          Text('Categoría: ${balance.categoria}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Hidratación
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Plan de Hidratación', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Text('Agua diaria: ${balance.litrosAgua.toStringAsFixed(2)} L'),
                          Text('Intervalo entre vasos: ${balance.minutosIntervalo} minutos'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Lista de registros
                  const Text('Historial de Registros', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...balance.puntos.map((punto) => Card(
                    child: ListTile(
                      title: Text('Peso: ${punto.peso.toStringAsFixed(2)} kg'),
                      subtitle: Text('Altura: ${punto.altura.toStringAsFixed(2)} m\nFecha: ${punto.fecha.day}/${punto.fecha.month}/${punto.fecha.year}'),
                    ),
                  )).toList(),
                ],
              ),
            );
          } else if (state is BalancePesoError) {
            return Center(child: Text('Error: ${state.mensaje}'));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/'),
        child: const Icon(Icons.home),
      ),
    );
  }
}
