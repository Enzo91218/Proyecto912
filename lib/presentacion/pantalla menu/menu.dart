import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'dart:io';
import 'dart:convert';
import '../../aplicacion/casos_de_uso/cerrar_sesion.dart';
import '../../servicios/usuario_actual.dart';
import '../../servicios/tema_servicio.dart';
import '../../servicios/audio_service.dart';
import '../cubit/recetas_cubit.dart';
import '../cubit/peso_altura_actual_cubit.dart';

class PantallaMenu extends StatefulWidget {
  const PantallaMenu({super.key});

  @override
  State<PantallaMenu> createState() => _PantallaMenuState();
}

class _PantallaMenuState extends State<PantallaMenu> {
  int _selectedIndex = 0;
  late AudioService _audioService;

  @override
  void initState() {
    super.initState();
    _audioService = GetIt.instance.get<AudioService>();
    // Iniciar reproducción de música
    _audioService.play();

    // Debug: mostrar si se inicializó correctamente
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!_audioService.isInitialized) {
        print(
          '⚠️ Audio no se inicializó, verifica que el archivo esté en assets/audio/background_music.mp3',
        );
      }
    });
  }

  final List<_NavItem> _navItems = [
    _NavItem(
      label: 'Inicio',
      icon: Icons.home,
      route: null, // Stay on home
    ),
    _NavItem(label: 'Recetas', icon: Icons.restaurant_menu, route: '/recetas'),
    _NavItem(label: 'Dietas', icon: Icons.local_dining, route: '/dietas'),
    _NavItem(label: 'Rutinas', icon: Icons.calendar_month, route: '/rutinas'),
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
    final temaServicio = GetIt.instance.get<TemaServicio>();
    final usuarioActual = GetIt.instance.get<UsuarioActual>();
    final usuario = usuarioActual.usuario;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => SingleChildScrollView(
            child: Padding(
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
                    icon: Icons.person_outline,
                    label: 'Mi Perfil',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/perfil');
                    },
                  ),
                  const Divider(height: 24),
                  _OptionButton(
                    icon: Icons.chat,
                    label: 'Chat Recetas',
                    onTap: () {
                      Navigator.pop(context);
                      // Navegar a chat sin receta específica (seleccionar primero)
                      context.go('/recetas');
                    },
                  ),
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
                  ListenableBuilder(
                    listenable: temaServicio,
                    builder:
                        (context, _) => _OptionButton(
                          icon:
                              temaServicio.modoOscuro
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                          label:
                              temaServicio.modoOscuro
                                  ? 'Modo Claro'
                                  : 'Modo Oscuro',
                          color: Colors.purple,
                          onTap: () {
                            temaServicio.toggleTema();
                            Navigator.pop(context);
                          },
                        ),
                  ),
                  _OptionButton(
                    icon: Icons.settings,
                    label: 'Herramientas',
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/herramientas');
                    },
                  ),
                  // Opción Debug solo para administrador (u1)
                  if (usuario?.id == 'u1') ...[
                    _OptionButton(
                      icon: Icons.bug_report,
                      label: 'Debug BD',
                      color: Colors.deepOrange,
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/debug-bd');
                      },
                    ),
                  ],
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
          ),
    );
  }

  Widget _buildProfileAvatar(String? fotoPerfil) {
    if (fotoPerfil != null && fotoPerfil.isNotEmpty) {
      try {
        final bytes = base64Decode(fotoPerfil);
        return CircleAvatar(
          radius: 55,
          backgroundColor: Colors.white,
          backgroundImage: MemoryImage(bytes),
        );
      } catch (e) {
        // Si hay error al decodificar, mostrar el icono por defecto
        return CircleAvatar(
          radius: 55,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 55, color: Colors.blue),
        );
      }
    } else {
      return CircleAvatar(
        radius: 55,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, size: 55, color: Colors.blue),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioActual = GetIt.instance.get<UsuarioActual>();
    final usuario = usuarioActual.usuario;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.instance.get<RecetasCubit>()..cargar(),
        ),
        BlocProvider(
          create:
              (_) => GetIt.instance.get<PesoAlturaActualCubit>(
                param1: usuario?.id ?? '',
              )..cargar(usuario?.id ?? ''),
        ),
      ],
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Header con información
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              actions: [
                // Botón de silencio en esquina superior derecha
                ListenableBuilder(
                  listenable: _audioService,
                  builder: (context, child) {
                    return IconButton(
                      icon: Icon(
                        _audioService.isMuted
                            ? Icons
                                .volume_mute // Icono con X cuando está silenciado
                            : Icons.volume_up,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        _audioService.toggleMute();
                        setState(() {}); // Forzar reconstrucción
                      },
                      tooltip:
                          _audioService.isMuted
                              ? 'Activar sonido'
                              : 'Silenciar',
                    );
                  },
                ),
              ],
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
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProfileAvatar(usuario?.fotoPerfil),
                      const SizedBox(height: 8),
                      Text(
                        usuario?.nombre ?? 'Usuario',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        usuario?.email ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Resumen del usuario
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tu Resumen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Cards de estadísticas
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        BlocBuilder<
                          PesoAlturaActualCubit,
                          PesoAlturaActualState
                        >(
                          builder: (context, state) {
                            if (state is PesoAlturaActualLoaded) {
                              return _StatCard(
                                icon: Icons.scale,
                                label: 'Peso Actual',
                                value:
                                    '${state.datos.peso.toStringAsFixed(1)} kg',
                                color: Colors.blue,
                              );
                            } else {
                              return _StatCard(
                                icon: Icons.scale,
                                label: 'Peso Actual',
                                value:
                                    '${usuario?.peso.toStringAsFixed(1) ?? '--'} kg',
                                color: Colors.blue,
                              );
                            }
                          },
                        ),
                        BlocBuilder<
                          PesoAlturaActualCubit,
                          PesoAlturaActualState
                        >(
                          builder: (context, state) {
                            if (state is PesoAlturaActualLoaded) {
                              // Si altura > 10, está en cm; si < 10, está en metros
                              final alturaEnCm =
                                  state.datos.altura > 10
                                      ? state.datos.altura
                                      : state.datos.altura * 100;
                              return _StatCard(
                                icon: Icons.height,
                                label: 'Altura',
                                value: '${alturaEnCm.toStringAsFixed(0)} cm',
                                color: Colors.green,
                              );
                            } else {
                              double alturaEnCm = 0;
                              if (usuario?.altura != null) {
                                final altura = usuario!.altura;
                                alturaEnCm =
                                    altura > 10 ? altura : altura * 100;
                              }
                              return _StatCard(
                                icon: Icons.height,
                                label: 'Altura',
                                value:
                                    alturaEnCm > 0
                                        ? '${alturaEnCm.toStringAsFixed(0)} cm'
                                        : '-- cm',
                                color: Colors.green,
                              );
                            }
                          },
                        ),
                        _StatCard(
                          icon: Icons.cake,
                          label: 'Edad',
                          value: '${usuario?.edad ?? '--'} años',
                          color: Colors.orange,
                        ),
                        _StatCard(
                          icon: Icons.restaurant_menu,
                          label: 'Recetas Disponibles',
                          value: '5',
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Acciones Rápidas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ActionButton(
                      icon: Icons.add,
                      label: 'Publicar Receta',
                      onTap: () => context.go('/publicar-receta'),
                    ),
                    const SizedBox(height: 8),
                    _ActionButton(
                      icon: Icons.monitor_weight,
                      label: 'Calcular IMC',
                      onTap: () => context.go('/imc'),
                    ),
                    const SizedBox(height: 24),
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
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String? route;

  _NavItem({required this.label, required this.icon, required this.route});
}

class _StatCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final dynamic value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: widget.color.withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.color.withOpacity(0.05),
              widget.color.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withOpacity(0.2),
                ),
                child: Icon(widget.icon, size: 24, color: widget.color),
              ),
              const SizedBox(height: 8),
              widget.value is Widget
                  ? widget.value
                  : Text(
                    widget.value.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(_isHovered ? 0.4 : 0.2),
                    blurRadius: _isHovered ? 15 : 8,
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  AnimatedSlide(
                    offset: _isHovered ? const Offset(0.2, 0) : Offset.zero,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),
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
