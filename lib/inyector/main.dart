import 'package:get_it/get_it.dart';
// Importar repositorios y adaptadores
import '../dominio/repositorios/repositorio_de_recetas.dart';
import '../dominio/repositorios/repositorio_de_dietas.dart';
import '../dominio/repositorios/repositorio_de_usuario.dart';
import '../dominio/repositorios/repositorio_de_registroIMC.dart';
import '../dominio/repositorios/repositorio_de_ingredientes.dart';
import '../adaptadores/adaptadorderecetas_en_memoria.dart';
import '../adaptadores/adaptadordedietas_en_memoria.dart';
import '../adaptadores/adaptadordeusuario_en_memoria.dart';
import '../adaptadores/adaptadorderegistroIMC_en_memoria.dart';
import '../adaptadores/adaptadordeingredientes_en_memoria.dart';

// Casos de uso (solo declaración, implementa los archivos luego)
class BuscarRecetas {}
class BuscarDietas {}
class BuscarUsuario {}
class RegistrarUsuario {}
class CalcularIMC {}

final getIt = GetIt.instance;

void setupInyector() {
	// Repositorios -> Adaptadores
	getIt.registerLazySingleton<RepositorioDeRecetas>(() => RepositorioDeRecetasA());
	getIt.registerLazySingleton<RepositorioDeDietas>(() => RepositorioDeDietasA());
	getIt.registerLazySingleton<RepositorioDeUsuario>(() => RepositorioDeUsuarioA());
	getIt.registerLazySingleton<RepositorioDeRegistroIMC>(() => RepositorioDeRegistroIMCA());
	getIt.registerLazySingleton<RepositorioDeIngredientes>(() => RepositorioDeIngredientesA());

	// Casos de uso (ejemplo, implementa la lógica real en sus archivos)
	getIt.registerLazySingleton(() => BuscarRecetas());
	getIt.registerLazySingleton(() => BuscarDietas());
	getIt.registerLazySingleton(() => BuscarUsuario());
	getIt.registerLazySingleton(() => RegistrarUsuario());
	getIt.registerLazySingleton(() => CalcularIMC());
}
