import 'package:go_router/go_router.dart';

import 'calcularIMC/CalcularIMC.dart';
import 'pantalla menu/menu.dart';
import 'pantalla receta/BuscarReceta.dart';
import 'pantalla dieta/BuscarDieta.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'menu',
      builder: (context, state) => const PantallaMenu(),
    ),
    GoRoute(
      path: '/recetas',
      name: 'recetas',
      builder: (context, state) => const PantallaRecetas(),
    ),
    GoRoute(
      path: '/dietas',
      name: 'dietas',
      builder: (context, state) => const PantallaDietas(),
    ),
    GoRoute(
      path: '/imc',
      name: 'imc',
      builder: (context, state) => const PantallaIMC(),
    ),
  ],
);
