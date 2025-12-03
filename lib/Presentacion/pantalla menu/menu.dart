import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'dart:io';
import '../../aplicacion/casos_de_uso/cerrar_sesion.dart';

class PantallaMenu extends StatelessWidget {
  const PantallaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Menú Principal',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              const Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              
              // --- Sección de botones horizontales centrados ---
              SizedBox(
                height: 120, // Altura fija para el listado horizontal
                // Envolvemos el ListView en Center para centrarlo si hay espacio extra
                // Aunque al ser horizontal, el ListView ya toma el ancho completo disponible
                // La alineación se logra centrando el contenido de la Columna principal
                child: ListView(
                  shrinkWrap: true, // Importante: ajusta el tamaño al contenido
                  scrollDirection: Axis.horizontal, 
                  // Para centrar los elementos de la lista cuando no ocupan todo el ancho:
                  // 1. Envolver el ListView en un Center y usar un Row con MainAxisAlignment.center
                  //    o, más simple, dejar el ListView y centrar el Column principal.
                  // 2. Aquí, el truco es usar 'mainAxisSize: MainAxisSize.min' en el Column y el Center en el Body.
                  children: [
                    _MenuCardHorizontal(
                      icon: Icons.restaurant_menu,
                      text: 'Recetas',
                      color: Colors.amber.shade600,
                      onTap: () => context.go('/recetas'),
                    ),
                    _MenuCardHorizontal(
                      icon: Icons.local_dining,
                      text: 'Dietas',
                      color: Colors.amber.shade600,
                      onTap: () => context.go('/dietas'),
                    ),
                    _MenuCardHorizontal(
                      icon: Icons.monitor_weight,
                      text: 'IMC',
                      color: Colors.amber.shade600,
                      onTap: () => context.go('/imc'),
                    ),
                    _MenuCardHorizontal(
                      icon: Icons.history,
                      text: 'Registro Peso',
                      color: Colors.amber.shade600,
                      onTap: () => context.go('/registro-peso'),
                    ),
                    _MenuCardHorizontal(
                      icon: Icons.balance_sharp,
                      text: 'Balance Peso',
                      color: Colors.amber.shade600,
                      onTap: () => context.go('/balance-peso'),
                    ),
                    _MenuCardHorizontal(
                      icon: Icons.build,
                      text: 'Herramientas',
                      color: Colors.amber.shade600,
                      onTap: () => context.go('/herramientas'),
                    ),
                    _MenuCardHorizontal(
                      icon: Icons.logout,
                      text: 'Cerrar Sesión',
                      color: Colors.orange,
                      onTap: () {
                        // Cerrar sesión y volver a login
                        GetIt.instance.get<CerrarSesion>().cerrarSesion();
                        context.go('/login');
                      },
                    ),
                    _MenuCardHorizontal(
                      icon: Icons.exit_to_app,
                      text: 'Salir',
                      color: Colors.redAccent,
                      onTap: () {
                        // Cierra la aplicación completamente
                        exit(0);
                      },
                    ),
                  ],
                ),
              ),
              // --- Fin de la sección de botones ---
              
              const SizedBox(height: 40),
              
              // Elemento visual de relleno (opcional)
              Opacity(
                opacity: 0.3,
                child: Icon(
                  Icons.food_bank_outlined,
                  size: 150,
                  color: Colors.amber.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para el formato horizontal y pequeño con animaciones
class _MenuCardHorizontal extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _MenuCardHorizontal({
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  State<_MenuCardHorizontal> createState() => _MenuCardHorizontalState();
}

class _MenuCardHorizontalState extends State<_MenuCardHorizontal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 2, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
          widget.onTap();
        });
      },
      onTapDown: (_) {
        _controller.forward();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _elevationAnimation,
          builder: (context, child) {
            return Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, _elevationAnimation.value),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: widget.color, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}