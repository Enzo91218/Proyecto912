import 'package:bloc/bloc.dart';
import '../../aplicacion/casos_de_uso/buscar_recetas.dart';
import '../../aplicacion/casos_de_uso/filtrar_recetas_por_cultura.dart';
import '../../aplicacion/casos_de_uso/buscar_recetas_con_gemini.dart';
import '../../dominio/entidades/receta.dart';
import '../../dominio/entidades/ingrediente.dart';

abstract class RecetasState {}

class RecetaAleatoriaLoaded extends RecetasState {
  final Receta receta;
  RecetaAleatoriaLoaded(this.receta);
}

class RecetasInitial extends RecetasState {}

class RecetasLoading extends RecetasState {
  final bool usandoGemini;
  RecetasLoading({this.usandoGemini = false});
}

class RecetasLoaded extends RecetasState {
  final List<Receta> recetas;
  final bool fueDesdeBD;
  RecetasLoaded(this.recetas, {this.fueDesdeBD = true});
}

class CulturasLoaded extends RecetasState {
  final List<String> culturas;
  CulturasLoaded(this.culturas);
}

class RecetasError extends RecetasState {
  final String mensaje;
  RecetasError(this.mensaje);
}

class RecetasCubit extends Cubit<RecetasState> {
  final BuscarRecetas casoUso;
  final FiltrarRecetasPorCultura filtrarPorCultura;
  final BuscarRecetasConGemini buscarConGemini;
  
  RecetasCubit(this.casoUso, this.filtrarPorCultura, this.buscarConGemini) : super(RecetasInitial());

  Future<void> cargar() async {
    emit(RecetasLoading());
    try {
      // Cargar todas las recetas usando búsqueda con lista vacía
      final recetas = await casoUso.call([]);
      emit(RecetasLoaded(recetas));
    } catch (e) {
      emit(RecetasError('Error al cargar recetas: $e'));
    }
  }

  Future<void> cargarCulturas() async {
    try {
      final culturas = await casoUso.repositorio.obtenerCulturasUnicas();
      emit(CulturasLoaded(['Todas', ...culturas]));
    } catch (e) {
      emit(RecetasError('Error al cargar culturas: $e'));
    }
  }

  Future<void> buscar(List<Ingrediente> ingredientes) async {
    emit(RecetasLoading());
    try {
      final recetas = await casoUso.call(ingredientes);
      if (recetas.isEmpty) {
        emit(
          RecetasError(
            'No se encontraron recetas para los ingredientes proporcionados',
          ),
        );
        return;
      }
      emit(RecetasLoaded(recetas));
    } catch (e) {
      emit(RecetasError(e.toString()));
    }
  }

  Future<void> buscarPorCultura(String cultura) async {
    emit(RecetasLoading());
    try {
      final recetas = await filtrarPorCultura.call(cultura);
      if (recetas.isEmpty) {
        emit(RecetasError('No se encontraron recetas de la cultura: $cultura'));
        return;
      }
      emit(RecetasLoaded(recetas));
    } catch (e) {
      emit(RecetasError(e.toString()));
    }
  }

  Future<void> mostrarAleatoria() async {
    try {
      final receta = await casoUso.repositorio.obtenerRecetaAleatoria();
      if (receta != null) {
        emit(RecetaAleatoriaLoaded(receta));
      } else {
        emit(RecetasError('No hay recetas disponibles.'));
      }
    } catch (e) {
      emit(RecetasError('Error al obtener receta aleatoria: $e'));
    }
  }

  /// Busca recetas localmente y si no encuentra, usa Gemini para encontrar nuevas
  Future<void> buscarConFallbackGemini(List<Ingrediente> ingredientes) async {
    emit(RecetasLoading(usandoGemini: false));
    try {
      // Primero intenta búsqueda local
      final recetasLocales = await casoUso.call(ingredientes);
      
      if (recetasLocales.isNotEmpty) {
        emit(RecetasLoaded(recetasLocales, fueDesdeBD: true));
        return;
      }

      // Si no hay resultados, usar Gemini
      print('\n🔍 No hay recetas locales, usando Gemini...');
      emit(RecetasLoading(usandoGemini: true));
      
      final recetasGemini = await buscarConGemini.buscar(ingredientes);
      
      if (recetasGemini.isNotEmpty) {
        emit(RecetasLoaded(recetasGemini, fueDesdeBD: false));
      } else {
        emit(RecetasError(
          'No se encontraron recetas para los ingredientes: ${ingredientes.map((i) => i.nombre).join(", ")}',
        ));
      }
    } catch (e) {
      emit(RecetasError('Error en búsqueda: $e'));
    }
  }
}
