import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../presentacion/router.dart';
import '../servicios/usuario_actual.dart';
import '../servicios/tema_servicio.dart';
import '../servicios/audio_service.dart';
import '../servicios/database_update_service.dart';
// Importar repositorios y adaptadores
import '../dominio/repositorios/repositorio_de_recetas.dart';
import '../dominio/repositorios/repositorio_de_dietas.dart';
import '../dominio/repositorios/repositorio_de_usuario.dart';
import '../dominio/repositorios/repositorio_de_registroIMC.dart';
import '../dominio/repositorios/repositorio_de_registro_peso_altura.dart';
import '../dominio/repositorios/repositorio_de_rutinas.dart';
import '../dominio/repositorios/repositorio_chat_ia.dart';

import '../adaptadores/sqlite/database_provider.dart';
import '../adaptadores/sqlite/recetas_sqlite_adaptador.dart';
import '../adaptadores/sqlite/dietas_sqlite_adaptador.dart';
import '../adaptadores/sqlite/usuarios_sqlite_adaptador.dart';
import '../adaptadores/sqlite/registros_imc_sqlite_adaptador.dart';
import '../adaptadores/sqlite/registros_peso_altura_sqlite_adaptador.dart';
import '../adaptadores/sqlite/rutinas_sqlite_adaptador.dart';

import '../adaptadores/sqlite/chat_ia_google_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../config/app_config.dart';

// Importar casos de uso reales
import '../aplicacion/casos_de_uso/mostrar_receta_aleatoria.dart';
import '../aplicacion/casos_de_uso/buscar_recetas.dart';
import '../aplicacion/casos_de_uso/filtrar_recetas_por_cultura.dart';
import '../aplicacion/casos_de_uso/publicar_receta.dart';
import '../aplicacion/casos_de_uso/buscar_dietas.dart';
import '../aplicacion/casos_de_uso/calcular_imc.dart';
import '../aplicacion/casos_de_uso/buscar_usuarios.dart';
import '../aplicacion/casos_de_uso/registrar_usuario.dart';
import '../aplicacion/casos_de_uso/actualizar_peso_altura.dart';
import '../aplicacion/casos_de_uso/registro_peso_altura.dart';
import '../aplicacion/casos_de_uso/balance_peso_altura.dart';
import '../aplicacion/casos_de_uso/cerrar_sesion.dart';
import '../aplicacion/casos_de_uso/obtener_rutinas.dart';
import '../aplicacion/casos_de_uso/obtener_respuesta_ia_caso_de_uso.dart';
import '../aplicacion/casos_de_uso/buscar_recetas_con_gemini.dart';
import '../aplicacion/casos_de_uso/clasificar_recetas_a_dieta.dart';
import '../presentacion/cubit/recetas_cubit.dart';
import '../presentacion/cubit/dietas_cubit.dart';
import '../presentacion/cubit/imc_cubit.dart';
import '../presentacion/cubit/login_cubit.dart';
import '../presentacion/cubit/registrar_cubit.dart';
import '../presentacion/cubit/publicar_receta_cubit.dart';
import '../presentacion/cubit/rutinas_cubit.dart';
import '../presentacion/cubit/registro_peso_cubit.dart';
import '../presentacion/cubit/peso_altura_actual_cubit.dart';
import '../presentacion/cubit/chat_cubit.dart';

// El registro de casos de uso se realiza con las clases implementadas en aplicacion/casos_de_uso

final getIt = GetIt.instance;

void setupInyector() {
  // Servicio de usuario actual
  getIt.registerSingleton<UsuarioActual>(UsuarioActual());

  // Servicio de tema
  getIt.registerSingleton<TemaServicio>(TemaServicio());

  // Servicio de audio para música de fondo
  getIt.registerSingleton<AudioService>(AudioService());

  // Base de datos SQLite
  getIt.registerSingleton<DatabaseProvider>(DatabaseProvider());

  // Servicio de actualización de base de datos
  final updateService = DatabaseUpdateService(getIt<DatabaseProvider>());
  updateService.initialize();
  getIt.registerSingleton<DatabaseUpdateService>(updateService);

  // Caso de uso para mostrar receta aleatoria
  getIt.registerLazySingleton(
    () => MostrarRecetaAleatoria(getIt<RepositorioDeRecetas>()),
  );
  // Repositorios -> Adaptadores
  getIt.registerLazySingleton<RepositorioDeRecetas>(
    () => RepositorioDeRecetasSqlite(getIt<DatabaseProvider>()),
  );
  getIt.registerLazySingleton<RepositorioDeDietas>(
    () => RepositorioDeDietasSqlite(
      getIt<DatabaseProvider>(),
      getIt<RepositorioDeRecetas>() as RepositorioDeRecetasSqlite,
    ),
  );
  getIt.registerLazySingleton<RepositorioDeUsuario>(
    () => RepositorioDeUsuarioSqlite(getIt<DatabaseProvider>()),
  );
  getIt.registerLazySingleton<RepositorioDeRegistroIMC>(
    () => RepositorioDeRegistroIMCSqlite(getIt<DatabaseProvider>()),
  );
  getIt.registerLazySingleton<RepositorioDeRegistroPesoAltura>(
    () => RepositorioDeRegistroPesoAlturaSqlite(getIt<DatabaseProvider>()),
  );
  getIt.registerLazySingleton<RepositorioDeRutinas>(
    () => RepositorioDeRutinasSqlite(getIt<DatabaseProvider>()),
  );
  getIt.registerLazySingleton<RepositorioChatIA>(
    () => ChatIAGoogleGemini(
      apiKey: AppConfig.googleGeminiApiKey,
      databaseProvider: getIt<DatabaseProvider>(),
    ),
  );

  // Casos de uso reales
  getIt.registerLazySingleton(
    () => BuscarRecetas(getIt<RepositorioDeRecetas>()),
  );
  getIt.registerLazySingleton(
    /// Registra la fábrica de [FiltrarRecetasPorCultura] en el contenedor de inyección de dependencias.
    ///
    /// Esta función crea una nueva instancia de [FiltrarRecetasPorCultura] cada vez que es solicitada,
    /// inyectando automáticamente una instancia de [RepositorioDeRecetas] obtenida del contenedor [getIt].
    ///
    /// **Caso de uso:** Filtrar recetas según criterios culturales específicos.
    ///
    /// **Dependencias:**
    /// - Requiere que [RepositorioDeRecetas] esté previamente registrado en [getIt].
    () => FiltrarRecetasPorCultura(getIt<RepositorioDeRecetas>()),
  );
  getIt.registerLazySingleton(
    () => PublicarReceta(getIt<RepositorioDeRecetas>()),
  );
  // BuscarDietas ahora necesita el repositorio de dietas y el de recetas
  getIt.registerLazySingleton(
    () => BuscarDietas(
      getIt<RepositorioDeDietas>(),
      getIt<RepositorioDeRecetas>(),
    ),
  );
  getIt.registerLazySingleton(
    () => CalcularIMC(getIt<RepositorioDeRegistroIMC>()),
  );
  getIt.registerLazySingleton(
    () => BuscarUsuarios(getIt<RepositorioDeUsuario>()),
  );
  getIt.registerLazySingleton(
    () => RegistrarUsuario(getIt<RepositorioDeUsuario>()),
  );
  getIt.registerLazySingleton(
    () => ActualizarPesoAltura(repositorio: getIt<RepositorioDeUsuario>()),
  );
  getIt.registerLazySingleton(
    () => RegistroPesoAlturaUC(
      repositorio: getIt<RepositorioDeRegistroPesoAltura>(),
    ),
  );
  getIt.registerLazySingleton(
    () => BalancePesoAlturaUC(
      repositorio: getIt<RepositorioDeRegistroPesoAltura>(),
      repositorioIMC: getIt<RepositorioDeRegistroIMC>(),
    ),
  );
  getIt.registerLazySingleton(() => CerrarSesion());
  getIt.registerLazySingleton(
    () => ObtenerRutinas(getIt<RepositorioDeRutinas>()),
  );
  getIt.registerLazySingleton(
    () => ObtenerRespuestaIACasoDeUso(getIt<RepositorioChatIA>()),
  );
  getIt.registerLazySingleton(
    () => BuscarRecetasConGemini(
      getIt<RepositorioDeRecetas>(),
      getIt<RepositorioChatIA>(),
    ),
  );
  getIt.registerLazySingleton(
    () => ClasificarRecetasADieta(getIt<RepositorioChatIA>()),
  );

  // Cubits (registrar como factory para crear instancias nuevas cuando BlocProvider las pida)
  getIt.registerFactory(
    () =>
        RecetasCubit(
          getIt<BuscarRecetas>(),
          getIt<FiltrarRecetasPorCultura>(),
          getIt<BuscarRecetasConGemini>(),
        ),
  );
  getIt.registerFactory(() => PublicarRecetaCubit(getIt<PublicarReceta>()));
  getIt.registerFactory(() => DietasCubit(
    getIt<BuscarDietas>(),
    getIt<ClasificarRecetasADieta>(),
  ));
  getIt.registerFactoryParam<IMCCubit, String, void>(
    (usuarioId, _) => IMCCubit(getIt<CalcularIMC>(), usuarioId: usuarioId),
  );
  getIt.registerFactory(() => LoginCubit(getIt<BuscarUsuarios>()));
  getIt.registerFactory(
    () => RegistrarCubit(
      getIt<RegistrarUsuario>(),
      getIt<RepositorioDeRegistroPesoAltura>(),
    ),
  );
  getIt.registerFactory(() => RutinasCubit(getIt<ObtenerRutinas>()));
  getIt.registerFactoryParam<RegistroPesoCubit, String, void>(
    (usuarioId, _) => RegistroPesoCubit(
      repositorio: getIt<RepositorioDeRegistroPesoAltura>(),
      usuarioId: usuarioId,
    ),
  );
  getIt.registerFactoryParam<PesoAlturaActualCubit, String, void>(
    (usuarioId, _) => PesoAlturaActualCubit(
      repositorio: getIt<RepositorioDeRegistroPesoAltura>(),
    ),
  );
  getIt.registerFactory(
    () => ChatCubit(getIt<ObtenerRespuestaIACasoDeUso>()),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno desde .env
  try {
    await dotenv.load(fileName: '.env');
    print('✅ .env cargado correctamente');
    final apiKey = dotenv.env['GOOGLE_GEMINI_API_KEY'];
    print('🔑 API Key cargada: ${apiKey?.substring(0, 15)}...');
  } catch (e) {
    print('⚠️ Error cargando .env: $e');
  }

  // Inicializar sqflite para plataformas de escritorio (no en web)
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      print('✓ SQLite FFI initialized for ${Platform.operatingSystem}');
    }
  }

  setupInyector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: getIt.get<TemaServicio>(),
      builder: (context, _) {
        final temaServicio = getIt.get<TemaServicio>();

        return MaterialApp.router(
          title: 'Proyecto912',
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: temaServicio.modoOscuro ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue.shade600,
      scaffoldBackgroundColor: Colors.grey.shade50,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue.shade400,
      scaffoldBackgroundColor: Colors.grey.shade900,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.grey.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
