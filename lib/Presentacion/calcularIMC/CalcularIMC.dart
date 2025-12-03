import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'dart:math';

import '../cubit/imc_cubit.dart';
import '../../servicios/usuario_actual.dart';
import '../../aplicacion/casos_de_uso/registro_peso_altura.dart';

class PantallaIMC extends StatefulWidget {
  const PantallaIMC({super.key});

  @override
  State<PantallaIMC> createState() => _PantallaIMCState();
}

class _PantallaIMCState extends State<PantallaIMC> {
  final pesoCtrl = TextEditingController();
  final alturaCtrl = TextEditingController();
  String resultado = "";
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    // cargar registros previos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IMCCubit>().cargar();
    });
  }

  @override
  void dispose() {
    pesoCtrl.dispose();
    alturaCtrl.dispose();
    super.dispose();
  }

  Future<void> _calcularIMC() async {
    final peso = double.tryParse(pesoCtrl.text);
    final altura = double.tryParse(alturaCtrl.text);

    if (peso == null || altura == null || altura <= 0) {
      setState(() {
        resultado = "Por favor, ingrese valores válidos.";
      });
      return;
    }

    final imc = peso / pow(altura / 100, 2);

    String estado;
    if (imc < 18.5) {
      estado = "Bajo peso";
    } else if (imc < 25) {
      estado = "Normal";
    } else if (imc < 30) {
      estado = "Sobrepeso";
    } else {
      estado = "Obesidad";
    }

    setState(() {
      resultado = "IMC: ${imc.toStringAsFixed(2)} ($estado)";
    });

    // Guardar el registro de peso y altura en la BD
    await _guardarRegistro(peso, altura);
  }

  Future<void> _guardarRegistro(double peso, double altura) async {
    try {
      setState(() {
        _guardando = true;
      });

      // Obtener el usuario actual
      final usuarioActual = GetIt.instance.get<UsuarioActual>();
      final usuarioId = usuarioActual.id;

      // Obtener el caso de uso para registrar peso/altura
      final registroPesoUC = GetIt.instance.get<RegistroPesoAlturaUC>();

      // Guardar el registro
      await registroPesoUC.ejecutar(usuarioId, peso, altura / 100); // Convertir cm a metros

      setState(() {
        _guardando = false;
      });

      // Mostrar confirmación
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Peso y altura registrados exitosamente'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _guardando = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
        title: const Text("Calcular IMC"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: pesoCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Peso (kg)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: alturaCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Altura (cm)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _guardando
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.calculate),
                    label: const Text("Calcular y Guardar"),
                    onPressed: _calcularIMC,
                  ),
            const SizedBox(height: 20),
            // Mostrar el resultado calculado inmediatamente (si existe)
            if (resultado.isNotEmpty)
              Text(
                resultado,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),
            BlocBuilder<IMCCubit, IMCState>(builder: (context, state) {
              if (state is IMCLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is IMCLoaded) {
                return Column(
                  children: state.registros
                      .map((r) => Text('IMC: ${r.imc} - ${r.categoria}'))
                      .toList(),
                );
              } else if (state is IMCError) {
                return Text('Error: ${state.mensaje}');
              }
              return const SizedBox.shrink();
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
                  icon: const Icon(Icons.history),
                  label: const Text("Ver Registro"),
                  onPressed: () => context.go('/registro-peso'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

