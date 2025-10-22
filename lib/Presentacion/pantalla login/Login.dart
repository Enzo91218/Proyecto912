import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/login_cubit.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Iniciar sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 10),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
            const SizedBox(height: 20),
            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  // al iniciar sesión volver al menú
                  context.go('/');
                }
                if (state is LoginFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.mensaje)));
                }
              },
              builder: (context, state) {
                if (state is LoginLoading) return const CircularProgressIndicator();
                return ElevatedButton(
                  onPressed: () => context.read<LoginCubit>().login(emailCtrl.text, passCtrl.text),
                  child: const Text('Ingresar'),
                );
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => context.go('/registrar'),
              child: const Text('No tienes cuenta, registrar usuario', style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
