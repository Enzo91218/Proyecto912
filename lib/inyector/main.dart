import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import '../presentacion/router.dart';
import '../servicios/usuario_actual.dart';
import '../servicios/tema_servicio.dart';
// Importar repositorios y adaptadores
import '../dominio/repositorios/repositorio_de_recetas.dart';
import '../dominio/repositorios/repositorio_de_dietas.dart';
import '../dominio/repositorios/repositorio_de_usuario.dart';
import '../dominio/repositorios/repositorio_de_registroIMC.dart';
import '../dominio/repositorios/repositorio_de_registro_peso_altura.dart';

import '../adaptadores/adaptadorderecetas_en_memoria.dart';
import '../adaptadores/adaptadordedietas_en_memoria.dart';
import '../adaptadores/adaptadordeusuario_en_memoria.dart';
import '../adaptadores/adaptadorderegistroIMC_en_memoria.dart';
import '../adaptadores/adaptador_registro_peso_altura_en_memoria.dart';

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
import '../presentacion/cubit/recetas_cubit.dart';
import '../presentacion/cubit/dietas_cubit.dart';
import '../presentacion/cubit/imc_cubit.dart';
import '../presentacion/cubit/login_cubit.dart';
import '../presentacion/cubit/registrar_cubit.dart';
import '../presentacion/cubit/publicar_receta_cubit.dart';


// El registro de casos de uso se realiza con las clases implementadas en aplicacion/casos_de_uso

final getIt = GetIt.instance;

void setupInyector() {
	// Servicio de usuario actual
	getIt.registerSingleton<UsuarioActual>(UsuarioActual());
	
	// Servicio de tema
	getIt.registerSingleton<TemaServicio>(TemaServicio());

		// Caso de uso para mostrar receta aleatoria
		getIt.registerLazySingleton(() => MostrarRecetaAleatoria(getIt<RepositorioDeRecetas>()));
	// Repositorios -> Adaptadores
	getIt.registerLazySingleton<RepositorioDeRecetas>(() => RepositorioDeRecetasA());
	getIt.registerLazySingleton<RepositorioDeDietas>(() => RepositorioDeDietasA());
	getIt.registerLazySingleton<RepositorioDeUsuario>(() => RepositorioDeUsuarioA());
	getIt.registerLazySingleton<RepositorioDeRegistroIMC>(() => RepositorioDeRegistroIMCA());
	getIt.registerLazySingleton<RepositorioDeRegistroPesoAltura>(() => RepositorioDeRegistroPesoAlturaA());


	// Casos de uso reales
	getIt.registerLazySingleton(() => BuscarRecetas(getIt<RepositorioDeRecetas>()));
	getIt.registerLazySingleton(() => FiltrarRecetasPorCultura(getIt<RepositorioDeRecetas>()));
	getIt.registerLazySingleton(() => PublicarReceta(getIt<RepositorioDeRecetas>()));
	// BuscarDietas ahora necesita el repositorio de dietas y el de recetas
	getIt.registerLazySingleton(() => BuscarDietas(getIt<RepositorioDeDietas>(), getIt<RepositorioDeRecetas>()));
	getIt.registerLazySingleton(() => CalcularIMC(getIt<RepositorioDeRegistroIMC>()));
	getIt.registerLazySingleton(() => BuscarUsuarios(getIt<RepositorioDeUsuario>()));
	getIt.registerLazySingleton(() => RegistrarUsuario(getIt<RepositorioDeUsuario>()));
	getIt.registerLazySingleton(() => ActualizarPesoAltura(repositorio: getIt<RepositorioDeUsuario>()));
	getIt.registerLazySingleton(() => RegistroPesoAlturaUC(repositorio: getIt<RepositorioDeRegistroPesoAltura>()));
	getIt.registerLazySingleton(() => BalancePesoAlturaUC(repositorio: getIt<RepositorioDeRegistroPesoAltura>()));
	getIt.registerLazySingleton(() => CerrarSesion());

		// Cubits (registrar como factory para crear instancias nuevas cuando BlocProvider las pida)
		getIt.registerFactory(() => RecetasCubit(getIt<BuscarRecetas>()));
		getIt.registerFactory(() => PublicarRecetaCubit(getIt<PublicarReceta>()));
		getIt.registerFactory(() => DietasCubit(getIt<BuscarDietas>()));
		getIt.registerFactory(() => IMCCubit(getIt<CalcularIMC>()));
		getIt.registerFactory(() => LoginCubit(getIt<BuscarUsuarios>()));
}

void main() {
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
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(12),
				),
			),
			elevatedButtonTheme: ElevatedButtonThemeData(
				style: ElevatedButton.styleFrom(
					backgroundColor: Colors.blue.shade600,
					foregroundColor: Colors.white,
					padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(8),
					),
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
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(12),
				),
			),
			elevatedButtonTheme: ElevatedButtonThemeData(
				style: ElevatedButton.styleFrom(
					backgroundColor: Colors.blue.shade600,
					foregroundColor: Colors.white,
					padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(8),
					),
				),
			),
		);
	}
}