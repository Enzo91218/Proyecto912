import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/registrar_cubit.dart';
import '../../dominio/entidades/usuario.dart';

class PantallaRegistrarUsuario extends StatefulWidget {
  const PantallaRegistrarUsuario({super.key});

  @override
  State<PantallaRegistrarUsuario> createState() =>
      _PantallaRegistrarUsuarioState();
}

class _PantallaRegistrarUsuarioState extends State<PantallaRegistrarUsuario> {
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final edadCtrl = TextEditingController();
  final pesoCtrl = TextEditingController();
  final alturaCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/login'),
        ),
        title: const Text('Registrar usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: edadCtrl,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: pesoCtrl,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: alturaCtrl,
                decoration: const InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              BlocConsumer<RegistrarCubit, RegistrarState>(
                listener: (context, state) {
                  if (state is RegistrarSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario registrado')),
                    );
                    context.go('/login');
                  }
                  if (state is RegistrarFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.mensaje)));
                  }
                },
                builder: (context, state) {
                  if (state is RegistrarLoading)
                    return const CircularProgressIndicator();
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nombreCtrl.text.isEmpty ||
                            emailCtrl.text.isEmpty ||
                            passCtrl.text.isEmpty ||
                            edadCtrl.text.isEmpty ||
                            pesoCtrl.text.isEmpty ||
                            alturaCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Completa todos los campos'),
                            ),
                          );
                          return;
                        }
                        context.read<RegistrarCubit>().registrar(
                          Usuario(
                            id:
                                DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                            nombre: nombreCtrl.text,
                            email: emailCtrl.text,
                            password: passCtrl.text,
                            edad: int.parse(edadCtrl.text),
                            peso: double.parse(pesoCtrl.text),
                            altura: double.parse(alturaCtrl.text) / 100,
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Registrar',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
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
