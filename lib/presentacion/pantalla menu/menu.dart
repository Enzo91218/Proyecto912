import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'dart:io';
import '../../aplicacion/casos_de_uso/cerrar_sesion.dart';

class PantallaMenu extends StatefulWidget {
  const PantallaMenu({super.key});

  @override
  State<PantallaMenu> createState() => _PantallaMenuState();
}

class _PantallaMenuState extends State<PantallaMenu> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(
      label: 'Inicio',
      icon: Icons.home,
      route: null, // Stay on home
    ),
    _NavItem(
      label: 'Recetas',
      icon: Icons.restaurant_menu,
      route: '/recetas',
    ),
    _NavItem(
      label: 'Dietas',
      icon: Icons.local_dining,
      route: '/dietas',
    ),
    _NavItem(
      label: 'Rutinas',
      icon: Icons.calendar_month,
      route: '/rutinas',
    ),
    _NavItem(
      label: 'Más',
      icon: Icons.more_horiz,
      route: null, // Show bottom sheet
    ),
  ];

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_navItems[index].route != null) {
      context.go(_navItems[index].route!);
      // Volver a índice 0 cuando se regresa
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      });
    } else if (index == _navItems.length - 1) {
      // Mostrar más opciones
      _showMoreOptions();
    }
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Más opciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _OptionButton(
              icon: Icons.add,
              label: 'Publicar Receta',
              onTap: () {
                Navigator.pop(context);
                context.go('/publicar-receta');
              },
            ),
            _OptionButton(
              icon: Icons.monitor_weight,
              label: 'IMC',
              onTap: () {
                Navigator.pop(context);
                context.go('/imc');
              },
            ),
            _OptionButton(
              icon: Icons.history,
              label: 'Registro de Peso',
              onTap: () {
                Navigator.pop(context);
                context.go('/registro-peso');
              },
            ),
            _OptionButton(
              icon: Icons.trending_up,
              label: 'Balance de Peso',
              onTap: () {
                Navigator.pop(context);
                context.go('/balance-peso');
              },
            ),
            const Divider(height: 24),
            _OptionButton(
              icon: Icons.logout,
              label: 'Cerrar Sesión',
              color: Colors.orange,
              onTap: () {
                Navigator.pop(context);
                GetIt.instance.get<CerrarSesion>().cerrarSesion();
                context.go('/login');
              },
            ),
            _OptionButton(
              icon: Icons.exit_to_app,
              label: 'Salir',
              color: Colors.red,
              onTap: () => exit(0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header con información
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade400, Colors.blue.shade700],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.blue),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Bienvenido',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gestiona tu salud y nutrición',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Contenido principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Acceso rápido',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _QuickAccessCard(
                        icon: Icons.restaurant_menu,
                        label: 'Recetas',
                        onTap: () => context.go('/recetas'),
                      ),
                      _QuickAccessCard(
                        icon: Icons.local_dining,
                        label: 'Dietas',
                        onTap: () => context.go('/dietas'),
                      ),
                      _QuickAccessCard(
                        icon: Icons.monitor_weight,
                        label: 'IMC',
                        onTap: () => context.go('/imc'),
                      ),
                      _QuickAccessCard(
                        icon: Icons.history,
                        label: 'Registro Peso',
                        onTap: () => context.go('/registro-peso'),
                      ),
                      _QuickAccessCard(
                        icon: Icons.trending_up,
                        label: 'Balance Peso',
                        onTap: () => context.go('/balance-peso'),
                      ),
                      _QuickAccessCard(
                        icon: Icons.calendar_month,
                        label: 'Rutinas',
                        onTap: () => context.go('/rutinas'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Acciones',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    icon: Icons.add,
                    label: 'Publicar Receta',
                    onTap: () => context.go('/publicar-receta'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateTo,
        type: BottomNavigationBarType.fixed,
        items: [
          for (int i = 0; i < _navItems.length; i++)
            BottomNavigationBarItem(
              icon: Icon(_navItems[i].icon),
              label: _navItems[i].label,
            ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String? route;

  _NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.1),
                ),
                child: Icon(icon, size: 28, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade400, Colors.blue.shade600],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _OptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}