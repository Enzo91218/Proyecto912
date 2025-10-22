import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../inyector/main.dart' as inyector;
import 'cubit/recetas_cubit.dart';
import 'cubit/dietas_cubit.dart';
import 'cubit/imc_cubit.dart';
import 'calcularIMC/CalcularIMC.dart';
import 'pantalla menu/menu.dart';
import 'pantalla receta/BuscarReceta.dart';
import 'pantalla dieta/BuscarDieta.dart';
import 'pantalla login/Login.dart';
import 'cubit/login_cubit.dart';
import 'pantalla registro/RegistrarUsuario.dart';
import 'cubit/registrar_cubit.dart';

final GoRouter appRouter = GoRouter(
  // Iniciar la app en la pantalla de login
  initialLocation: '/login',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'menu',
      builder: (context, state) => const PantallaMenu(),
    ),
    GoRoute(
      path: '/recetas',
      name: 'recetas',
      builder: (context, state) => BlocProvider(
        create: (_) => inyector.getIt<RecetasCubit>(),
        child: const PantallaRecetas(),
      ),
    ),
    GoRoute(
      path: '/dietas',
      name: 'dietas',
      builder: (context, state) => BlocProvider(
        create: (_) => inyector.getIt<DietasCubit>(),
        child: const PantallaDietas(),
      ),
    ),
    GoRoute(
      path: '/imc',
      name: 'imc',
      builder: (context, state) => BlocProvider(
        create: (_) => inyector.getIt<IMCCubit>(),
        child: const PantallaIMC(),
      ),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => BlocProvider(
        create: (_) => inyector.getIt<LoginCubit>(),
        child: const PantallaLogin(),
      ),
    ),
    GoRoute(
      path: '/registrar',
      name: 'registrar',
      builder: (context, state) => BlocProvider(
        create: (_) => inyector.getIt<RegistrarCubit>(),
        child: const PantallaRegistrarUsuario(),
      ),
    ),
  ],
);
