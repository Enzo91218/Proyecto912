import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'dart:math';

import '../cubit/imc_cubit.dart';
import '../cubit/registro_peso_cubit.dart';
import '../../servicios/usuario_actual.dart';
import '../../servicios/database_update_service.dart';

class PantallaIMC extends StatefulWidget {
  const PantallaIMC({super.key});

  @override
  State<PantallaIMC> createState() => _PantallaIMCState();
}

class _PantallaIMCState extends State<PantallaIMC> {
  final pesoCtrl = TextEditingController();
  final alturaCtrl = TextEditingController();
  String resultado = "";
  double? imc;

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

  void _calcularYGuardar() async {
    final peso = double.tryParse(pesoCtrl.text);
    final altura = double.tryParse(alturaCtrl.text);

    if (peso == null || altura == null || altura <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingrese valores válidos')),
      );
      return;
    }

    final usuarioActual = GetIt.instance.get<UsuarioActual>();
    final usuario = usuarioActual.usuario;

    if (usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no autenticado')),
      );
      return;
    }

    // Calcular IMC
    final imcValue = peso / pow(altura / 100, 2);

    String categoria;
    if (imcValue < 18.5) {
      categoria = "Bajo peso";
    } else if (imcValue < 25) {
      categoria = "Normal";
    } else if (imcValue < 30) {
      categoria = "Sobrepeso";
    } else {
      categoria = "Obesidad";
    }

    print('💾 Calculando y guardando: peso=$peso, altura=$altura, imc=$imcValue, categoría=$categoria');

    // Guardar en registros_peso_altura
    await context.read<RegistroPesoCubit>().agregarRegistro(
      usuario.id,
      peso,
      altura,
    );

    // Guardar en registros_imc
    await context.read<IMCCubit>().guardarRegistro(usuario.id, imcValue, categoria);

    // Notificar que la BD fue actualizada
    GetIt.instance.get<DatabaseUpdateService>().recordUpdate();

    // Mostrar resultado
    setState(() {
      resultado = "IMC: ${imcValue.toStringAsFixed(2)} ($categoria) - ✅ Guardado";
      imc = imcValue;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro guardado exitosamente')),
    );

    // Limpiar campos después de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        pesoCtrl.clear();
        alturaCtrl.clear();
        setState(() {
          resultado = "";
          imc = null;
        });
      }
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
        title: const Text("Calcular IMC"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Calcular y Guardar"),
                  onPressed: _calcularYGuardar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Mostrar el resultado calculado inmediatamente (si existe)
              if (resultado.isNotEmpty)
                Text(resultado, style: const TextStyle(fontSize: 18)),
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
            ],
          ),
        ),
      ),
    );
  }
}
