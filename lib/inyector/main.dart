import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import '../presentacion/router.dart';
// Importar repositorios y adaptadores
import '../dominio/repositorios/repositorio_de_recetas.dart';
import '../dominio/repositorios/repositorio_de_dietas.dart';
import '../dominio/repositorios/repositorio_de_usuario.dart';
import '../dominio/repositorios/repositorio_de_registroIMC.dart';

import '../adaptadores/adaptadorderecetas_en_memoria.dart';
import '../adaptadores/adaptadordedietas_en_memoria.dart';
import '../adaptadores/adaptadordeusuario_en_memoria.dart';
import '../adaptadores/adaptadorderegistroIMC_en_memoria.dart';

// Importar casos de uso reales
import '../aplicacion/casos_de_uso/buscar_recetas.dart';
import '../aplicacion/casos_de_uso/buscar_dietas.dart';
import '../aplicacion/casos_de_uso/calcular_imc.dart';
import '../aplicacion/casos_de_uso/buscar_usuarios.dart';
import '../aplicacion/casos_de_uso/registrar_usuario.dart';
import '../aplicacion/casos_de_uso/actualizar_usuario.dart';
import '../presentacion/cubit/recetas_cubit.dart';
import '../presentacion/cubit/dietas_cubit.dart';
import '../presentacion/cubit/imc_cubit.dart';
import '../presentacion/cubit/login_cubit.dart';
import '../presentacion/cubit/registrar_cubit.dart';


// El registro de casos de uso se realiza con las clases implementadas en aplicacion/casos_de_uso

final getIt = GetIt.instance;

void setupInyector() {
  // Repositorios -> Adaptadores
  getIt.registerLazySingleton<RepositorioDeRecetas>(
      () => RepositorioDeRecetasA());
  getIt.registerLazySingleton<RepositorioDeDietas>(
      () => RepositorioDeDietasA());
  getIt.registerLazySingleton<RepositorioDeUsuario>(
      () => RepositorioDeUsuarioA());
  getIt.registerLazySingleton<RepositorioDeRegistroIMC>(
      () => RepositorioDeRegistroIMCA());

  // Casos de uso reales
  getIt.registerLazySingleton(
      () => BuscarRecetas(getIt<RepositorioDeRecetas>()));
  // BuscarDietas ahora necesita el repositorio de dietas y el de recetas
  getIt.registerLazySingleton(() =>
      BuscarDietas(getIt<RepositorioDeDietas>(), getIt<RepositorioDeRecetas>()));
  getIt.registerLazySingleton(
      () => CalcularIMC(getIt<RepositorioDeRegistroIMC>()));
  getIt.registerLazySingleton(() => BuscarUsuarios(getIt<RepositorioDeUsuario>()));
  getIt.registerLazySingleton(() => RegistrarUsuario(getIt<RepositorioDeUsuario>()));
  getIt.registerLazySingleton(() => ActualizarUsuario(getIt<RepositorioDeUsuario>()));

  // Cubits (registrar como factory para crear instancias nuevas cuando BlocProvider las pida)
  getIt.registerFactory(() => RecetasCubit(getIt<BuscarRecetas>()));
  getIt.registerFactory(() => DietasCubit(getIt<BuscarDietas>()));
  getIt.registerFactory(() => IMCCubit(getIt<CalcularIMC>()));
  getIt.registerFactory(() => LoginCubit(getIt<BuscarUsuarios>()));
  getIt.registerFactory(() => RegistrarCubit(getIt<RegistrarUsuario>()));
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
