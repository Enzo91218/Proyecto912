import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// 🧩 Importar tu router y pantallas
import '../infraestructura/menu.dart';
import '../infraestructura/BuscarReceta.dart';
import '../infraestructura/BuscarDieta.dart';
import '../infraestructura/CalcularIMC.dart';
// 🧠 Importar repositorios y adaptadores
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

// ⚙️ Casos de uso (por ahora como clases vacías)
class BuscarRecetas {}
class BuscarDietas {}
class BuscarUsuario {}
class RegistrarUsuario {}
class CalcularIMC {}

// 🧱 Inyector global
final getIt = GetIt.instance;

void setupInyector() {
  // Repositorios -> Adaptadores en memoria
  getIt.registerLazySingleton<RepositorioDeRecetas>(() => RepositorioDeRecetasA());
  getIt.registerLazySingleton<RepositorioDeDietas>(() => RepositorioDeDietasA());
  getIt.registerLazySingleton<RepositorioDeUsuario>(() => RepositorioDeUsuarioA());
  getIt.registerLazySingleton<RepositorioDeRegistroIMC>(() => RepositorioDeRegistroIMCA());
  getIt.registerLazySingleton<RepositorioDeIngredientes>(() => RepositorioDeIngredientesA());

  // Casos de uso (se implementarán después)
  getIt.registerLazySingleton(() => BuscarRecetas());
  getIt.registerLazySingleton(() => BuscarDietas());
  getIt.registerLazySingleton(() => BuscarUsuario());
  getIt.registerLazySingleton(() => RegistrarUsuario());
  getIt.registerLazySingleton(() => CalcularIMC());
}

// 🚦 Configuración de rutas con GoRouter
final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PantallaMenu(),
    ),
    GoRoute(
      path: '/recetas',
      builder: (context, state) => const PantallaRecetas(),
    ),
    GoRoute(
      path: '/dietas',
      builder: (context, state) => const PantallaDietas(),
    ),
    GoRoute(
      path: '/imc',
      builder: (context, state) => const PantallaIMC(),
    ),
  ],
);

void main() {
  setupInyector(); // Inicializa dependencias
  runApp(const Proyecto912App());
}

class Proyecto912App extends StatelessWidget {
  const Proyecto912App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Proyecto 912',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
    );
  }
}
