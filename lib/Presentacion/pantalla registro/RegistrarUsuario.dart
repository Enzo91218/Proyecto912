import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/registrar_cubit.dart';
import '../../dominio/entidades/usuario.dart';

class PantallaRegistrarUsuario extends StatefulWidget {
  const PantallaRegistrarUsuario({super.key});

  @override
  State<PantallaRegistrarUsuario> createState() => _PantallaRegistrarUsuarioState();
}

class _PantallaRegistrarUsuarioState extends State<PantallaRegistrarUsuario> {
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final edadCtrl = TextEditingController();
  final pesoCtrl = TextEditingController();
  final alturaCtrl = TextEditingController();

  @override
  void dispose() {
    nombreCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    edadCtrl.dispose();
    pesoCtrl.dispose();
    alturaCtrl.dispose();
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
        title: const Text('Registrar usuario'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: nombreCtrl,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passCtrl,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: edadCtrl,
                decoration: InputDecoration(
                  labelText: 'Edad',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: pesoCtrl,
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: alturaCtrl,
                decoration: InputDecoration(
                  labelText: 'Altura (m)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),
              BlocConsumer<RegistrarCubit, RegistrarState>(
                listener: (context, state) {
                  if (state is RegistrarSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario registrado exitosamente')),
                    );
                    context.go('/');
                  }
                  if (state is RegistrarFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.mensaje)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is RegistrarLoading) {
                    return const CircularProgressIndicator();
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final edad = int.tryParse(edadCtrl.text) ?? 18;
                        final peso = double.tryParse(pesoCtrl.text) ?? 60.0;
                        final altura = double.tryParse(alturaCtrl.text) ?? 1.7;

                        context.read<RegistrarCubit>().registrar(
                          Usuario(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            nombre: nombreCtrl.text,
                            email: emailCtrl.text,
                            password: passCtrl.text,
                            edad: edad,
                            peso: peso,
                            altura: altura,
                          ),
                        );
                      },
                      child: const Text('Registrar'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
