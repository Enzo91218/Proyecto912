import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../inyector/main.dart' as inyector;
import '../servicios/usuario_actual.dart';
import 'cubit/recetas_cubit.dart';
import 'cubit/dietas_cubit.dart';
import 'cubit/imc_cubit.dart';
import 'cubit/registro_peso_cubit.dart';
import 'cubit/balance_peso_cubit.dart';
import 'cubit/login_cubit.dart';
import 'cubit/publicar_receta_cubit.dart';
import 'calcularIMC/CalcularIMC.dart';
import 'pantalla menu/menu.dart';
import 'pantalla dieta/BuscarDieta.dart';
import 'pantalla login/Login.dart';
import 'pantalla registro/RegistrarUsuario.dart';
import 'cubit/registrar_cubit.dart';
import 'pantalla_registro_peso/pantalla_registro_peso.dart';
import 'pantalla_balance_peso/pantalla_balance_peso.dart';

import 'pantalla rutina/pantalla_rutinas.dart';
import 'pantalla receta/publicar_receta.dart';
import 'pantalla receta/BuscarReceta.dart';
import 'pantalla perfil/perfil.dart';

final GoRouter appRouter = GoRouter(
  // Iniciar la app en el login
  initialLocation: '/login',
  routes: <GoRoute>[
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
    GoRoute(
      path: '/',
      name: 'menu',
      builder: (context, state) => const PantallaMenu(),
    ),
    GoRoute(
      path: '/publicar-receta',
      name: 'publicar-receta',
      builder:
          (context, state) => BlocProvider(
            create: (_) => inyector.getIt<PublicarRecetaCubit>(),
            child: const PantallaPublicarReceta(),
          ),
    ),
    GoRoute(
      path: '/recetas',
      name: 'recetas',
      builder:
          (context, state) => BlocProvider(
            create: (_) => inyector.getIt<RecetasCubit>(),
            child: const PantallaRecetas(),
          ),
    ),
    GoRoute(
      path: '/dietas',
      name: 'dietas',
      builder:
          (context, state) => BlocProvider(
            create: (_) => inyector.getIt<DietasCubit>(),
            child: const PantallaDietas(),
          ),
    ),
    GoRoute(
      path: '/rutinas',
      name: 'rutinas',
      builder: (context, state) => const PantallaRutinas(),
    ),
    GoRoute(
      path: '/perfil',
      name: 'perfil',
      builder: (context, state) => const PantallaPerfil(),
    ),
    GoRoute(
      path: '/imc',
      name: 'imc',
      builder:
          (context, state) => BlocProvider(
            create: (_) => inyector.getIt<IMCCubit>(),
            child: const PantallaIMC(),
          ),
    ),
    GoRoute(
      path: '/registro-peso',
      name: 'registro-peso',
      builder: (context, state) {
        final usuarioActual = GetIt.instance.get<UsuarioActual>();
        final usuarioId = usuarioActual.id;
        return BlocProvider(
          create:
              (_) => RegistroPesoCubit(
                repositorio: inyector.getIt(),
                usuarioId: usuarioId,
              ),
          child: const PantallaRegistroPeso(),
        );
      },
    ),
    GoRoute(
      path: '/balance-peso',
      name: 'balance-peso',
      builder: (context, state) {
        final usuarioActual = GetIt.instance.get<UsuarioActual>();
        final usuarioId = usuarioActual.id;
        return BlocProvider(
          create:
              (_) => BalancePesoCubit(
                casoDeUso: inyector.getIt(),
                usuarioId: usuarioId,
              ),
          child: const PantallaBalancePeso(),
        );
      },
    ),
    // RUTAS DE LOGIN Y REGISTRO COMENTADAS - La app inicia directamente en el menú
    /*
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
    */
  ],
);
