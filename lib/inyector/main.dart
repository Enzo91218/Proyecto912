import 'package:get_it/get_it.dart';
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


// El registro de casos de uso se realiza con las clases implementadas en aplicacion/casos_de_uso

final getIt = GetIt.instance;

void setupInyector() {
	// Repositorios -> Adaptadores
	getIt.registerLazySingleton<RepositorioDeRecetas>(() => RepositorioDeRecetasA());
	getIt.registerLazySingleton<RepositorioDeDietas>(() => RepositorioDeDietasA());
	getIt.registerLazySingleton<RepositorioDeUsuario>(() => RepositorioDeUsuarioA());
	getIt.registerLazySingleton<RepositorioDeRegistroIMC>(() => RepositorioDeRegistroIMCA());


	// Casos de uso reales
	getIt.registerLazySingleton(() => BuscarRecetas(getIt<RepositorioDeRecetas>()));
	getIt.registerLazySingleton(() => BuscarDietas(getIt<RepositorioDeDietas>()));
	getIt.registerLazySingleton(() => CalcularIMC(getIt<RepositorioDeRegistroIMC>()));
	getIt.registerLazySingleton(() => BuscarUsuarios(getIt<RepositorioDeUsuario>()));
	getIt.registerLazySingleton(() => RegistrarUsuario());
}
