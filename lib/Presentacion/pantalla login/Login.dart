import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import '../cubit/login_cubit.dart';

const String _fondoLoginAsset = 'assets/presentacion/pantalla_login/fondo_login.png';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> with SingleTickerProviderStateMixin {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Previene el gesto de retroceso
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // Cierra la aplicación completamente
              exit(0);
            },
          ),
          title: const Text('Iniciar sesión'),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                _fondoLoginAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.35)),
            ),
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-0.5, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
                        ),
                        child: TextField(
                          controller: emailCtrl,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.5, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
                        ),
                        child: TextField(
                          controller: passCtrl,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                        ),
                      ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
