import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import '../cubit/login_cubit.dart';

class PantallaLogin extends StatelessWidget {
  const PantallaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => exit(0),
        ),
        title: const Text('Iniciar sesión'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenido',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 25),
              BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    context.go('/');
                  }
                  if (state is LoginFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.mensaje)));
                  }
                },
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const CircularProgressIndicator();
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Completa todos los campos'),
                            ),
                          );
                          return;
                        }
                        context.read<LoginCubit>().login(
                          emailCtrl.text,
                          passCtrl.text,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('Ingresar', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context.go('/registrar'),
                child: const Text(
                  'No tienes cuenta? Registrarse',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
