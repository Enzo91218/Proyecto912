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
      appBar: AppBar(
        title: const Text('Menú Principal'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _MenuCard(
              icon: Icons.restaurant_menu,
              text: 'Recetas',
              onTap: () => context.go('/recetas'),
            ),
            _MenuCard(
              icon: Icons.local_dining,
              text: 'Dietas',
              onTap: () => context.go('/dietas'),
            ),
            _MenuCard(
              icon: Icons.add,
              text: 'Publicar Receta',
              onTap: () => context.go('/publicar-receta'),
            ),
            _MenuCard(
              icon: Icons.search,
              text: 'Buscar Receta',
              onTap: () => context.go('/buscar-receta'),
            ),
            _MenuCard(
              icon: Icons.monitor_weight,
              text: 'IMC',
              onTap: () => context.go('/imc'),
            ),
            _MenuCard(
              icon: Icons.history,
              text: 'Registro Peso',
              onTap: () => context.go('/registro-peso'),
            ),
            _MenuCard(
              icon: Icons.trending_up,
              text: 'Balance Peso',
              onTap: () => context.go('/balance-peso'),
            ),
            _MenuCard(
              icon: Icons.calendar_month,
              text: 'Rutinas',
              onTap: () => context.go('/rutinas'),
            ),
            _MenuCard(
              icon: Icons.logout,
              text: 'Cerrar Sesión',
              onTap: () {
                GetIt.instance.get<CerrarSesion>().cerrarSesion();
                context.go('/login');
              },
            ),
            _MenuCard(
              icon: Icons.exit_to_app,
              text: 'Salir',
              onTap: () => exit(0),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}