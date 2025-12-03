import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import '../presentacion/router.dart';
import '../servicios/usuario_actual.dart';
// Importar repositorios y adaptadores
import '../dominio/repositorios/repositorio_de_recetas.dart';
import '../dominio/repositorios/repositorio_de_dietas.dart';
import '../dominio/repositorios/repositorio_de_usuario.dart';
import '../dominio/repositorios/repositorio_de_registroIMC.dart';
import '../dominio/repositorios/repositorio_de_registro_peso_altura.dart';

import '../adaptadores/sqlite/dietas/dieta_sqlite_adaptador.dart';
import '../adaptadores/sqlite/recetas/receta_sqlite_adaptador.dart';
import '../adaptadores/sqlite/registro_imc/registro_imc_sqlite_adaptador.dart';
import '../adaptadores/sqlite/registro_peso_altura/registro_peso_altura_sqlite_adaptador.dart';
import '../adaptadores/sqlite/usuarios/usuario_sqlite_adaptador.dart';

// Importar casos de uso reales
import '../aplicacion/casos_de_uso/buscar_recetas.dart';
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


// El registro de casos de uso se realiza con las clases implementadas en aplicacion/casos_de_uso

final getIt = GetIt.instance;

void setupInyector() {
	// Servicio de usuario actual
	getIt.registerSingleton<UsuarioActual>(UsuarioActual());

	// Repositorios -> Adaptadores
        getIt.registerLazySingleton<RepositorioDeRecetas>(() => RepositorioDeRecetasSQLite());
        getIt.registerLazySingleton<RepositorioDeDietas>(() => RepositorioDeDietasSQLite());
        getIt.registerLazySingleton<RepositorioDeUsuario>(() => RepositorioDeUsuarioSQLite());
        getIt.registerLazySingleton<RepositorioDeRegistroIMC>(() => RepositorioDeRegistroIMCSQLite());
        getIt.registerLazySingleton<RepositorioDeRegistroPesoAltura>(() => RepositorioDeRegistroPesoAlturaSQLite());


	// Casos de uso reales
	getIt.registerLazySingleton(() => BuscarRecetas(getIt<RepositorioDeRecetas>()));
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
		return MaterialApp.router(
			title: 'Proyecto912',
			routerConfig: appRouter,
			debugShowCheckedModeBanner: false,
		);
	}
}
